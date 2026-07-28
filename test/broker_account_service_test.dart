import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:lttbdd/flow_services/broker_account_service.dart';

void main() {
  test('số tài khoản luôn bắt đầu bằng 099C và có đúng 6 chữ số', () {
    final account = BrokerAccountService.generateAccountNumber(Random(1));

    expect(account, matches(RegExp(r'^099C\d{6}$')));
    expect(account.length, 10);
  });
}
