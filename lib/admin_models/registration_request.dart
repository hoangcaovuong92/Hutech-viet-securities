import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationRequest {
  const RegistrationRequest({
    required this.id,
    required this.cccd,
    required this.phone,
    required this.email,
    required this.fullName,
    required this.accountTypes,
    required this.brokerAccount,
    required this.status,
    required this.createdAt,
    required this.ownerId,
    required this.additionalAccount,
  });

  final String id;
  final String cccd;
  final String phone;
  final String email;
  final String fullName;
  final List<String> accountTypes;
  final String brokerAccount;
  final String status;
  final DateTime? createdAt;
  final String ownerId;
  final bool additionalAccount;

  factory RegistrationRequest.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? const <String, dynamic>{};
    final ocr = data['ocrInformation'];
    final ocrData = ocr is Map ? ocr : const <String, dynamic>{};
    final types = data['accountTypes'];

    return RegistrationRequest(
      id: document.id,
      cccd: data['cccd']?.toString() ?? '',
      phone: data['phone']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      fullName: ocrData['fullName']?.toString() ?? 'Chưa cập nhật',
      accountTypes: types is List
          ? types.map((item) => item.toString()).toList()
          : const [],
      brokerAccount: data['selectedBrokerAccount']?.toString() ?? '',
      status: data['status']?.toString() ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      ownerId: data['ownerId']?.toString() ?? '',
      additionalAccount: data['additionalAccount'] == true,
    );
  }
}
