import 'package:flutter_test/flutter_test.dart';
import 'package:viet_securities/flow_models/duplicate_registration_result.dart';
import 'package:viet_securities/flow_services/registration_identifier.dart';

void main() {
  test('chuẩn hoá dữ liệu trước khi tạo khoá kiểm tra trùng', () {
    expect(
      RegistrationIdentifier.normalize(DuplicateField.phone, '090 123 4567'),
      '0901234567',
    );
    expect(
      RegistrationIdentifier.normalize(
        DuplicateField.email,
        ' Student@HUTECH.edu.vn ',
      ),
      'student@hutech.edu.vn',
    );
  });

  test('cùng dữ liệu chuẩn hoá tạo cùng document id', () {
    final first = RegistrationIdentifier.documentId(
      DuplicateField.phone,
      '090 123 4567',
    );
    final second = RegistrationIdentifier.documentId(
      DuplicateField.phone,
      '0901234567',
    );

    expect(first, second);
    expect(first, startsWith('phone_'));
  });
}
