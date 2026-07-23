enum DuplicateField { cccd, phone, email }

class DuplicateRegistrationResult {
  const DuplicateRegistrationResult(this.fields);

  final Set<DuplicateField> fields;

  bool get hasDuplicate => fields.isNotEmpty;

  String get message {
    final labels = fields.map((field) {
      return switch (field) {
        DuplicateField.cccd => 'số căn cước công dân',
        DuplicateField.phone => 'số điện thoại',
        DuplicateField.email => 'email',
      };
    }).toList();

    if (labels.length == 1) {
      return '${_capitalize(labels.first)} này đã có tài khoản chứng khoán trước đó.';
    }
    if (labels.length == 2) {
      return '${_capitalize(labels.first)} và ${labels.last} đã tồn tại trên hệ thống.';
    }
    return 'Số căn cước công dân, số điện thoại và email đã tồn tại trên hệ thống.';
  }

  static String _capitalize(String value) {
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}
