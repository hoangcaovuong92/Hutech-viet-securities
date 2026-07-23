class RegistrationDraft {
  RegistrationDraft({
    this.cccd = '',
    this.phone = '',
    this.email = '',
    Set<String>? accountTypes,
    this.selectedBrokerAccount = '099C231098',
    Map<String, String>? ocrInformation,
    this.frontImageName = '',
    this.backImageName = '',
  }) : accountTypes = accountTypes ?? {'Tài khoản thường'},
       ocrInformation = ocrInformation ?? <String, String>{};

  String cccd;
  String phone;
  String email;
  Set<String> accountTypes;
  String selectedBrokerAccount;
  Map<String, String> ocrInformation;
  String frontImageName;
  String backImageName;

  Map<String, dynamic> toMap({required bool additionalAccount}) {
    return {
      'cccd': cccd,
      'phone': phone,
      'email': email,
      'accountTypes': accountTypes.toList(),
      'selectedBrokerAccount': selectedBrokerAccount,
      'additionalAccount': additionalAccount,
      'ocrInformation': ocrInformation,
      'identityImages': {
        'frontFileName': frontImageName,
        'backFileName': backImageName,
      },
    };
  }
}
