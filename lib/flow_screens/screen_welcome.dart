import 'package:flutter/material.dart';

import '../flow_models/registration_draft.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';
import 'screen_cccd_hint_text.dart';
import 'screen_login.dart';

class ScreenWelcome extends StatelessWidget {
  const ScreenWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/welcome_background.png',
            fit: BoxFit.cover,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x335A6A80), Color(0xDD050B12)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.show_chart_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'VietStock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  const Text(
                    'Mở tài khoản chứng khoán',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Bắt đầu hành trình tự do tài chính của bạn ngay hôm nay cùng VietStock',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const _Benefit(text: 'Phí giao dịch cực thấp chỉ từ 0.1%'),
                  const _Benefit(
                    text: 'Mở tài khoản trực tuyến eKYC chỉ trong 3 phút',
                  ),
                  const _Benefit(
                    text: 'Giao dịch mọi lúc mọi nơi thông minh & an toàn',
                  ),
                  const Spacer(),
                  PrimaryButton(
                    label: 'Bắt đầu ngay',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            ScreenCccdHintText(draft: RegistrationDraft()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ScreenLogin()),
                    ),
                    child: const Text.rich(
                      TextSpan(
                        text: 'Đã có tài khoản? ',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: 'Đăng nhập',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: AppColors.primary, size: 13),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
