import 'package:flutter_test/flutter_test.dart';
import 'package:lttbdd/flow_models/registration_draft.dart';

void main() {
  test('RegistrationDraft chuyển đúng dữ liệu sang Firestore', () {
    final draft = RegistrationDraft(
      cccd: '001234567890',
      phone: '0901234567',
      email: 'student@hutech.edu.vn',
      accountTypes: {'Tài khoản thường', 'Tài khoản margin'},
      selectedBrokerAccount: '099C231098',
      ocrInformation: {'fullName': 'NGUYỄN VĂN A', 'dateOfBirth': '01/01/1990'},
      frontImageName: 'cccd-front.jpg',
      backImageName: 'cccd-back.jpg',
    );

    final map = draft.toMap(additionalAccount: false);

    expect(map['cccd'], '001234567890');
    expect(map['phone'], '0901234567');
    expect(map['accountTypes'], contains('Tài khoản margin'));
    expect(map['selectedBrokerAccount'], '099C231098');
    expect(map['additionalAccount'], isFalse);
    expect(map['ocrInformation']['fullName'], 'NGUYỄN VĂN A');
    expect(map['identityImages']['frontFileName'], 'cccd-front.jpg');
  });
}
