import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CaptureCard extends StatelessWidget {
  const CaptureCard({
    super.key,
    required this.label,
    required this.onCapture,
    required this.onUpload,
    this.imageBytes,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onCapture;
  final VoidCallback? onUpload;
  final Uint8List? imageBytes;
  final bool enabled;

  bool get captured => imageBytes != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: captured ? AppColors.primary : AppColors.border,
          width: captured ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (captured)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.memory(
                imageBytes!,
                width: 110,
                height: 70,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.badge_outlined, color: AppColors.muted),
            ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (captured) ...[
                const Icon(
                  Icons.check_rounded,
                  color: AppColors.primary,
                  size: 19,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                captured ? '$label (Đã tải lên)' : label,
                style: TextStyle(
                  color: captured ? AppColors.primary : AppColors.navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: enabled ? onCapture : null,
                icon: const Icon(Icons.camera_alt_outlined, size: 17),
                label: const Text('Chụp ảnh'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: enabled ? onUpload : null,
                icon: const Icon(Icons.upload_file_outlined, size: 17),
                label: const Text('Tải ảnh lên'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CaptureChecklist extends StatelessWidget {
  const CaptureChecklist({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yêu cầu khi chụp:',
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '• Giấy tờ còn hạn sử dụng, nguyên vẹn',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          SizedBox(height: 10),
          Text(
            '• Ảnh đủ sáng, không lóa mờ, mất góc',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
