import 'package:flutter/material.dart';

import '../auth_services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import 'screen_home.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _authService = AuthService();
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final session = await _authService.signIn(
        email: _email.text,
        password: _password.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => ScreenHome(session: session)),
        (_) => false,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AuthService.messageFor(error)),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.show_chart_rounded,
                            size: 34,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Đăng nhập VietStock',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Theo dõi thị trường và quản lý yêu cầu đăng ký tài khoản.',
                        style: TextStyle(color: AppColors.muted, height: 1.45),
                      ),
                      const SizedBox(height: 28),
                      AppTextField(
                        label: 'Email',
                        controller: _email,
                        hintText: 'Nhập email đăng nhập',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        validator: (value) =>
                            RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            ).hasMatch(value?.trim() ?? '')
                            ? null
                            : 'Email không hợp lệ',
                      ),
                      const SizedBox(height: 18),
                      AppTextField(
                        label: 'Mật khẩu',
                        controller: _password,
                        hintText: 'Nhập mật khẩu',
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        validator: (value) => (value?.length ?? 0) >= 6
                            ? null
                            : 'Mật khẩu phải có ít nhất 6 ký tự',
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      PrimaryButton(
                        label: 'Đăng nhập',
                        onPressed: _login,
                        isLoading: _loading,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.admin_panel_settings_outlined,
                              color: AppColors.primaryDark,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Tài khoản có quyền admin sẽ được hiển thị thêm chức năng quản lý đăng ký.',
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
