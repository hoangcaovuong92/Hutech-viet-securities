import 'dart:async';

import 'package:flutter/material.dart';

import '../flow_models/registration_draft.dart';
import '../flow_services/registration_service.dart';
import '../flow_widgets/otp_screen_layout.dart';
import '../theme/app_theme.dart';
import 'screen_success.dart';

class ScreenSmsOtp extends StatefulWidget {
  const ScreenSmsOtp({
    super.key,
    required this.draft,
    this.additionalAccount = false,
    this.initialCode = '',
  });

  final RegistrationDraft draft;
  final bool additionalAccount;
  final String initialCode;

  @override
  State<ScreenSmsOtp> createState() => _ScreenSmsOtpState();
}

class _ScreenSmsOtpState extends State<ScreenSmsOtp> {
  final _service = RegistrationService();
  late String _code = widget.initialCode;
  bool _loading = false;
  int _remainingSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() => _remainingSeconds = 0);
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _resendCode() {
    if (_remainingSeconds > 0) return;
    setState(() => _remainingSeconds = 60);
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mã OTP mới đã được gửi lại.')),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (_code.length != 6) return;
    setState(() => _loading = true);
    try {
      await _service.completeRegistration(
        widget.draft,
        additionalAccount: widget.additionalAccount,
      );
      if (!mounted) return;
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ScreenSuccess()));
    } on DuplicateRegistrationException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.result.message),
          backgroundColor: AppColors.danger,
        ),
      );
    } on BrokerAccountAlreadyExistsException {
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Không thể lưu đăng ký. Hãy bật Anonymous Auth và thử lại.',
          ),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OtpScreenLayout(
      code: widget.initialCode,
      readOnly: false,
      onChanged: (value) => setState(() => _code = value),
      onConfirm: _code.length == 6 ? _confirm : null,
      loading: _loading,
      phoneNumber: widget.draft.phone,
      remainingSeconds: _remainingSeconds,
      onResend: _remainingSeconds == 0 ? _resendCode : null,
    );
  }
}
