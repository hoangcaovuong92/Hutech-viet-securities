import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../flow_models/duplicate_registration_result.dart';

class RegistrationIdentifier {
  const RegistrationIdentifier._();

  static String normalize(DuplicateField field, String value) {
    final trimmed = value.trim();
    return switch (field) {
      DuplicateField.cccd ||
      DuplicateField.phone => trimmed.replaceAll(RegExp(r'\D'), ''),
      DuplicateField.email => trimmed.toLowerCase(),
    };
  }

  static String documentId(DuplicateField field, String value) {
    final normalized = normalize(field, value);
    final digest = sha256.convert(utf8.encode('${field.name}:$normalized'));
    return '${field.name}_${digest.toString()}';
  }
}
