import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../flow_models/registration_draft.dart';
import '../flow_widgets/capture_card.dart';
import '../flow_widgets/flow_page.dart';
import 'screen_cccd_camera.dart';
import 'screen_ocr_cccd.dart';

class ScreenIdentityCapture extends StatefulWidget {
  const ScreenIdentityCapture({super.key, required this.draft});

  final RegistrationDraft draft;

  @override
  State<ScreenIdentityCapture> createState() => _ScreenIdentityCaptureState();
}

class _ScreenIdentityCaptureState extends State<ScreenIdentityCapture> {
  final _picker = ImagePicker();
  XFile? _frontImage;
  XFile? _backImage;
  Uint8List? _frontBytes;
  Uint8List? _backBytes;

  Future<void> _capture({required bool front}) async {
    final image = await Navigator.of(context).push<XFile>(
      MaterialPageRoute(
        builder: (_) => ScreenCccdCamera(
          sideLabel: front ? 'Mặt trước CCCD' : 'Mặt sau CCCD',
        ),
      ),
    );
    if (image == null || !mounted) return;
    await _setImage(image, front: front);
  }

  Future<void> _upload({required bool front}) async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 95,
      maxWidth: 2200,
    );
    if (image == null || !mounted) return;
    await _setImage(image, front: front);
  }

  Future<void> _setImage(XFile image, {required bool front}) async {
    final bytes = await image.readAsBytes();
    if (!mounted) return;
    setState(() {
      if (front) {
        _frontImage = image;
        _frontBytes = bytes;
        widget.draft.frontImageName = image.name;
      } else {
        _backImage = image;
        _backBytes = bytes;
        widget.draft.backImageName = image.name;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final complete = _frontImage != null && _backImage != null;
    final capturedCount =
        (_frontImage != null ? 1 : 0) + (_backImage != null ? 1 : 0);
    return FlowPage(
      buttonLabel: 'Tiếp tục',
      onPressed: complete
          ? () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ScreenOcrCccd(draft: widget.draft),
              ),
            )
          : null,
      child: Column(
        children: [
          StepHeader(
            step: 'BƯỚC 2/4',
            progress: capturedCount / 2,
            title: 'Xác minh danh tính',
            subtitle:
                'Chụp hoặc tải lên ảnh rõ nét hai mặt của CCCD',
          ),
          const SizedBox(height: 16),
          CaptureCard(
            label: 'Mặt trước CCCD',
            imageBytes: _frontBytes,
            onCapture: () => _capture(front: true),
            onUpload: () => _upload(front: true),
          ),
          const SizedBox(height: 16),
          CaptureCard(
            label: 'Mặt sau CCCD',
            imageBytes: _backBytes,
            enabled: _frontImage != null,
            onCapture: () => _capture(front: false),
            onUpload: () => _upload(front: false),
          ),
          const SizedBox(height: 16),
          const CaptureChecklist(),
        ],
      ),
    );
  }
}
