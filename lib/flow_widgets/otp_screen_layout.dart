import 'package:flutter/material.dart';

import '../flow_widgets/flow_page.dart';
import '../theme/app_theme.dart';
import 'otp_boxes.dart';

class OtpScreenLayout extends StatelessWidget {
  const OtpScreenLayout({
    super.key,
    required this.code,
    required this.readOnly,
    required this.onChanged,
    required this.onConfirm,
    required this.phoneNumber,
    required this.remainingSeconds,
    required this.onResend,
    this.loading = false,
  });

  final String code;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onConfirm;
  final String phoneNumber;
  final int remainingSeconds;
  final VoidCallback? onResend;
  final bool loading;

  String get maskedPhone {
    final value = phoneNumber.trim();
    if (value.length < 7) return value;
    return '${value.substring(0, 4)}***${value.substring(value.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    return FlowPage(
      buttonLabel: 'Xác nhận',
      onPressed: onConfirm,
      buttonLoading: loading,
      child: Column(
        children: [
          StepHeader(
            step: 'BƯỚC 4/4',
            progress: 1,
            title: 'Xác thực OTP',
            subtitle:
                'Nhập mã xác thực đã được gửi đến số điện thoại $maskedPhone',
          ),
          const SizedBox(height: 20),
          const Text(
            'Mã OTP (6 chữ số)',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 12),
          OtpBoxes(initialCode: code, readOnly: readOnly, onChanged: onChanged),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Gửi lại mã sau',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(width: 8),
              Text(
                '${remainingSeconds}s',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: onResend,
            child: const Text(
              'Gửi lại mã',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
