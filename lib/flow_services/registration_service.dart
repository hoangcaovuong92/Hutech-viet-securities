import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../flow_models/duplicate_registration_result.dart';
import '../flow_models/registration_draft.dart';
import 'registration_identifier.dart';

class DuplicateRegistrationException implements Exception {
  const DuplicateRegistrationException(this.result);

  final DuplicateRegistrationResult result;
}

class BrokerAccountAlreadyExistsException implements Exception {
  const BrokerAccountAlreadyExistsException();
}

class RegistrationService {
  RegistrationService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<DuplicateRegistrationResult> checkDuplicates(
    RegistrationDraft draft,
  ) async {
    await _requireUser();
    final values = _identifierValues(draft);
    final snapshots = await Future.wait(
      values.entries.map((entry) {
        final documentId = RegistrationIdentifier.documentId(
          entry.key,
          entry.value,
        );
        return _firestore
            .collection('registration_identifiers')
            .doc(documentId)
            .get();
      }),
    );
    final duplicateFields = <DuplicateField>{};
    final entries = values.entries.toList();
    for (var index = 0; index < snapshots.length; index++) {
      if (snapshots[index].exists) duplicateFields.add(entries[index].key);
    }
    return DuplicateRegistrationResult(duplicateFields);
  }

  Future<void> completeRegistration(
    RegistrationDraft draft, {
    required bool additionalAccount,
  }) async {
    final user = await _requireUser();
    if (!additionalAccount) {
      final duplicate = await checkDuplicates(draft);
      if (duplicate.hasDuplicate) {
        throw DuplicateRegistrationException(duplicate);
      }
    }
    final registration = _firestore.collection('registrations').doc();
    final brokerAccount = _firestore
        .collection('broker_accounts')
        .doc(draft.selectedBrokerAccount);
    final values = _identifierValues(draft);

    await _firestore.runTransaction((transaction) async {
      final brokerAccountSnapshot = await transaction.get(brokerAccount);
      if (brokerAccountSnapshot.exists) {
        throw const BrokerAccountAlreadyExistsException();
      }
      if (!additionalAccount) {
        final duplicateFields = <DuplicateField>{};
        for (final entry in values.entries) {
          final identifier = _firestore
              .collection('registration_identifiers')
              .doc(RegistrationIdentifier.documentId(entry.key, entry.value));
          final snapshot = await transaction.get(identifier);
          if (snapshot.exists) duplicateFields.add(entry.key);
        }
        if (duplicateFields.isNotEmpty) {
          throw DuplicateRegistrationException(
            DuplicateRegistrationResult(duplicateFields),
          );
        }
      }

      transaction.set(registration, {
        ...draft.toMap(additionalAccount: additionalAccount),
        'ownerId': user.uid,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      transaction.set(brokerAccount, {
        'ownerId': user.uid,
        'registrationId': registration.id,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!additionalAccount) {
        for (final entry in values.entries) {
          final identifier = _firestore
              .collection('registration_identifiers')
              .doc(RegistrationIdentifier.documentId(entry.key, entry.value));
          transaction.set(identifier, {
            'type': entry.key.name,
            'ownerId': user.uid,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
    });
  }

  Future<User> _requireUser() async {
    var user = _auth.currentUser;
    user ??= (await _auth.signInAnonymously()).user;
    if (user == null) {
      throw StateError('Không thể khởi tạo phiên đăng ký Firebase.');
    }
    return user;
  }

  Map<DuplicateField, String> _identifierValues(RegistrationDraft draft) {
    return {
      DuplicateField.cccd: draft.cccd,
      DuplicateField.phone: draft.phone,
      DuplicateField.email: draft.email,
    };
  }
}
