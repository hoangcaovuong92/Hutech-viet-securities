import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SuccessBody extends StatelessWidget {
  const SuccessBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 44,
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Chúc mừng!',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Tài khoản chứng khoán của bạn đã được tạo thành công. '
          'Thông tin tài khoản sẽ được gửi về tin nhắn hoặc email bạn đã cung cấp.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 16, height: 1.5),
        ),
      ],
    );
  }
}
