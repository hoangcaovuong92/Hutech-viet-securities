import 'package:flutter/material.dart';

import '../flow_models/duplicate_registration_result.dart';
import '../flow_models/registration_draft.dart';
import '../theme/app_theme.dart';
import 'screen_cccd_hint_text.dart';
import 'screen_welcome.dart';

class ScreenCccdDuplicatePopup extends StatelessWidget {
  const ScreenCccdDuplicatePopup({super.key, required this.duplicate});

  final DuplicateRegistrationResult duplicate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 80, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BƯỚC 1/4',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 18),
                LinearProgressIndicator(
                  value: 0.25,
                  color: AppColors.primary,
                  backgroundColor: AppColors.border,
                ),
                SizedBox(height: 18),
                Text(
                  'Thông tin cá nhân',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const ColoredBox(color: Color(0x80000000)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Color(0x26000000), blurRadius: 32),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF2E0),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '!',
                          style: TextStyle(
                            color: Color(0xFFF59E0A),
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Thông báo',
                        style: TextStyle(
                          color: AppColors.navy,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        duplicate.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.muted,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Loại tài khoản hiện có:',
                              style: TextStyle(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Tài khoản thường',
                              style: TextStyle(color: AppColors.muted),
                            ),
                            Divider(height: 28),
                            Text(
                              'Bạn có thể mở thêm:',
                              style: TextStyle(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Tài khoản margin',
                              style: TextStyle(color: AppColors.primary),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '• Tài khoản trái phiếu',
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (_) => const ScreenWelcome(),
                                    ),
                                    (_) => false,
                                  ),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                              ),
                              child: const Text('Huỷ'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: () =>
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (_) => ScreenCccdHintText(
                                        draft: RegistrationDraft(),
                                      ),
                                    ),
                                    (_) => false,
                                  ),
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                                backgroundColor: AppColors.primary,
                              ),
                              child: const Text('Mở tài khoản khác'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
