import 'package:flutter/material.dart';

import '../flow_models/registration_draft.dart';
import '../flow_services/registration_service.dart';
import '../flow_widgets/account_type_options.dart';
import '../flow_widgets/flow_page.dart';
import '../theme/app_theme.dart';
import '../widgets/app_text_field.dart';
import 'screen_cccd_duplicate_popup.dart';
import 'screen_identity_capture.dart';

class ScreenCccdHintText extends StatefulWidget {
  const ScreenCccdHintText({super.key, required this.draft});

  final RegistrationDraft draft;

  @override
  State<ScreenCccdHintText> createState() => _ScreenCccdHintTextState();
}

class _ScreenCccdHintTextState extends State<ScreenCccdHintText> {
  final _formKey = GlobalKey<FormState>();
  late final _cccd = TextEditingController(text: widget.draft.cccd);
  late final _phone = TextEditingController(text: widget.draft.phone);
  late final _email = TextEditingController(text: widget.draft.email);
  late Set<String> _types = {...widget.draft.accountTypes};
  final _registrationService = RegistrationService();
  bool _checking = false;

  @override
  void dispose() {
    _cccd.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;
    widget.draft
      ..cccd = _cccd.text.trim()
      ..phone = _phone.text.trim()
      ..email = _email.text.trim().toLowerCase()
      ..accountTypes = _types;
    setState(() => _checking = true);
    try {
      final duplicate = await _registrationService.checkDuplicates(
        widget.draft,
      );
      if (!mounted) return;
      final next = duplicate.hasDuplicate
          ? ScreenCccdDuplicatePopup(duplicate: duplicate)
          : ScreenIdentityCapture(draft: widget.draft);
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => next));
    } catch (error) {
      if (!mounted) return;
      debugPrint('checkDuplicates failed: $error');
      final message = error.toString().contains('operation-not-allowed')
          ? 'Chưa bật Anonymous Authentication trên Firebase Console.'
          : error.toString().contains('permission-denied')
          ? 'Firestore từ chối quyền đọc. Kiểm tra Rules và đăng nhập.'
          : 'Không thể kiểm tra thông tin trên Firebase. Vui lòng thử lại.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlowPage(
      buttonLabel: 'Tiếp tục',
      onPressed: _checking ? null : _continue,
      buttonLoading: _checking,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepHeader(
              step: 'BƯỚC 1/4',
              progress: 0.25,
              title: 'Thông tin cá nhân',
              subtitle: 'Vui lòng nhập số căn cước công dân của bạn',
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Số căn cước công dân',
              controller: _cccd,
              hintText: 'Nhập số căn cước công dân',
              keyboardType: TextInputType.number,
              validator: (value) => RegExp(r'^\d{12}$').hasMatch(value ?? '')
                  ? null
                  : 'CCCD phải gồm 12 chữ số',
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Số điện thoại',
              controller: _phone,
              hintText: 'Nhập số điện thoại',
              keyboardType: TextInputType.phone,
              validator: (value) => RegExp(r'^0\d{9}$').hasMatch(value ?? '')
                  ? null
                  : 'Số điện thoại phải gồm 10 chữ số',
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Email',
              controller: _email,
              hintText: 'Nhập địa chỉ email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value ?? '')
                  ? null
                  : 'Email không hợp lệ',
            ),
            const SizedBox(height: 16),
            AccountTypeOptions(
              selected: _types,
              onChanged: (value) => setState(() => _types = value),
            ),
          ],
        ),
      ),
    );
  }
}
