import 'package:flutter/material.dart';

import '../flow_models/registration_draft.dart';
import '../flow_widgets/flow_page.dart';
import '../theme/app_theme.dart';
import 'screen_bank.dart';

class ScreenOcrCccd extends StatelessWidget {
  const ScreenOcrCccd({super.key, required this.draft});

  final RegistrationDraft draft;

  static const _demoInformation = <String, String>{
    'fullName': 'NGUYỄN VĂN A',
    'dateOfBirth': '01/01/1990',
    'gender': 'Nam',
    'nationality': 'Việt Nam',
    'hometown': 'Hà Nội',
    'address': '123 Đường ABC, Quận 1, TP.HCM',
    'issueDate': '01/06/2021',
    'expiryDate': '01/06/2036',
  };

  @override
  Widget build(BuildContext context) {
    final information = <String, String>{
      'cccd': draft.cccd.isEmpty ? '001234567890' : draft.cccd,
      ..._demoInformation,
    };
    final data = [
      ('Số CCCD', information['cccd']!),
      ('Họ và tên', information['fullName']!),
      ('Ngày sinh', information['dateOfBirth']!),
      ('Giới tính', information['gender']!),
      ('Quốc tịch', information['nationality']!),
      ('Quê quán', information['hometown']!),
      ('Nơi thường trú', information['address']!),
      ('Ngày cấp', information['issueDate']!),
      ('Có giá trị đến', information['expiryDate']!),
    ];
    return FlowPage(
      buttonLabel: 'Xác nhận thông tin',
      onPressed: () {
        draft.ocrInformation = information;
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => ScreenBank(draft: draft)));
      },
      child: Column(
        children: [
          const StepHeader(
            step: 'BƯỚC 3/4',
            progress: 0.75,
            title: 'Thông tin căn cước công dân',
            subtitle: 'Thông tin demo dùng để hoàn tất hồ sơ đăng ký',
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                for (var index = 0; index < data.length; index++) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data[index].$1,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data[index].$2,
                            style: const TextStyle(
                              color: AppColors.navy,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (index != data.length - 1)
                    const Divider(height: 1, color: AppColors.border),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Vui lòng kiểm tra lại thông tin trước khi xác nhận',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
