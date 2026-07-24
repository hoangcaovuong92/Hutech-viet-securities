import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BrokerAccountService {
  BrokerAccountService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    Random? random,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _random = random ?? Random.secure();

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final Random _random;

  Future<List<String>> generateAvailableAccounts({int count = 4}) async {
    await _requireUser();
    final available = <String>{};
    var attempts = 0;

    while (available.length < count && attempts < 100) {
      attempts++;
      final candidate = generateAccountNumber(_random);
      if (available.contains(candidate)) continue;
      if (await isAvailable(candidate)) available.add(candidate);
    }

    if (available.length < count) {
      throw StateError('Không thể tạo đủ số tài khoản chưa sử dụng.');
    }
    return available.toList();
  }

  Future<bool> isAvailable(String accountNumber) async {
    final reserved = await _firestore
        .collection('broker_accounts')
        .doc(accountNumber)
        .get();
    return !reserved.exists;
  }

  static String generateAccountNumber(Random random) {
    final suffix = random.nextInt(1000000).toString().padLeft(6, '0');
    return '099C$suffix';
  }

  Future<User> _requireUser() async {
    var user = _auth.currentUser;
    user ??= (await _auth.signInAnonymously()).user;
    if (user == null) {
      throw StateError('Không thể khởi tạo phiên Firebase.');
    }
    return user;
  }
}
