import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../admin_models/registration_request.dart';
import '../flow_models/duplicate_registration_result.dart';
import '../flow_services/registration_identifier.dart';

class AdminRegistrationService {
  AdminRegistrationService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<List<RegistrationRequest>> watchRequests() {
    return _firestore
        .collection('registrations')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final requests = snapshot.docs
              .map(RegistrationRequest.fromDocument)
              .toList();
          unawaited(_backfillLookupDocuments(requests).catchError((_) {}));
          return requests;
        });
  }

  Future<void> updateStatus(String id, String status) {
    return _firestore.collection('registrations').doc(id).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _backfillLookupDocuments(
    List<RegistrationRequest> requests,
  ) async {
    final documents = <String, _LookupDocument>{};
    for (final request in requests) {
      if (request.ownerId.isEmpty) continue;

      final values = <DuplicateField, String>{
        DuplicateField.cccd: request.cccd,
        DuplicateField.phone: request.phone,
        DuplicateField.email: request.email,
      };
      for (final entry in values.entries) {
        if (entry.value.trim().isEmpty) continue;
        final reference = _firestore
            .collection('registration_identifiers')
            .doc(RegistrationIdentifier.documentId(entry.key, entry.value));
        documents[reference.path] = _LookupDocument(reference, {
          'type': entry.key.name,
          'ownerId': request.ownerId,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (request.brokerAccount.isNotEmpty) {
        final reference = _firestore
            .collection('broker_accounts')
            .doc(request.brokerAccount);
        documents[reference.path] = _LookupDocument(reference, {
          'ownerId': request.ownerId,
          'registrationId': request.id,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }

    final candidates = documents.values.toList();
    final snapshots = await Future.wait(
      candidates.map((item) => item.reference.get()),
    );
    await Future.wait([
      for (var index = 0; index < candidates.length; index++)
        if (!snapshots[index].exists)
          candidates[index].reference.set(candidates[index].data),
    ]);
  }
}

class _LookupDocument {
  const _LookupDocument(this.reference, this.data);

  final DocumentReference<Map<String, dynamic>> reference;
  final Map<String, dynamic> data;
}
