import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AccountTypeOptions extends StatelessWidget {
  const AccountTypeOptions({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const values = [
    'Tài khoản thường',
    'Tài khoản margin',
    'Tài khoản trái phiếu',
  ];

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loại tài khoản',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        for (final value in values)
          InkWell(
            onTap: () {
              final next = {...selected};
              if (value == values.first) return;
              next.contains(value) ? next.remove(value) : next.add(value);
              onChanged(next);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Checkbox(
                    value: selected.contains(value),
                    onChanged: value == values.first
                        ? null
                        : (_) {
                            final next = {...selected};
                            next.contains(value)
                                ? next.remove(value)
                                : next.add(value);
                            onChanged(next);
                          },
                    activeColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border),
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(value, style: const TextStyle(color: AppColors.text)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
