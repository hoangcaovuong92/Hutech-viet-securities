import 'package:flutter/material.dart';

import '../flow_models/registration_draft.dart';
import '../flow_services/broker_account_service.dart';
import '../flow_widgets/flow_page.dart';
import '../theme/app_theme.dart';
import 'screen_sms_otp.dart';

class ScreenBank extends StatefulWidget {
  const ScreenBank({super.key, required this.draft});

  final RegistrationDraft draft;

  @override
  State<ScreenBank> createState() => _ScreenBankState();
}

class _ScreenBankState extends State<ScreenBank> {
  final _accountService = BrokerAccountService();
  List<String> _accounts = const [];
  String _selected = '';
  bool _agreed = true;
  bool _loadingAccounts = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    setState(() {
      _loadingAccounts = true;
      _loadError = null;
    });
    try {
      final accounts = await _accountService.generateAvailableAccounts();
      if (!mounted) return;
      setState(() {
        _accounts = accounts;
        _selected = accounts.first;
        _loadingAccounts = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingAccounts = false;
        _loadError = 'Không thể tạo danh sách tài khoản. Vui lòng thử lại.';
      });
    }
  }

  Future<void> _continue() async {
    widget.draft.selectedBrokerAccount = _selected;
    final reloadAccounts = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ScreenSmsOtp(draft: widget.draft)),
    );
    if (reloadAccounts == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Số tài khoản vừa chọn đã được sử dụng. Đã tạo danh sách mới.',
          ),
          backgroundColor: AppColors.danger,
        ),
      );
      await _loadAccounts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlowPage(
      buttonLabel: 'Hoàn tất đăng ký',
      onPressed: _agreed && _selected.isNotEmpty && !_loadingAccounts
          ? _continue
          : null,
      buttonLoading: _loadingAccounts,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
            step: 'BƯỚC 4/4',
            progress: 1,
            title: 'Chọn số tài khoản chứng khoán',
            subtitle: 'Chọn số tài khoản chứng khoán để tiếp tục đăng ký',
          ),
          const SizedBox(height: 20),
          const Text(
            'Danh sách tài khoản chứng khoán',
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (_loadingAccounts)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_loadError != null)
            _AccountLoadError(message: _loadError!, onRetry: _loadAccounts)
          else
            for (final account in _accounts) ...[
              _AccountOption(
                account: account,
                selected: account == _selected,
                onTap: () => setState(() => _selected = account),
              ),
              const SizedBox(height: 12),
            ],
          OutlinedButton.icon(
            onPressed: _loadingAccounts ? null : _loadAccounts,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Đổi nhóm số tài khoản khác'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              foregroundColor: AppColors.primaryDark,
              side: const BorderSide(color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: _agreed,
            onChanged: (value) => setState(() => _agreed = value ?? false),
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text.rich(
              TextSpan(
                text:
                    'Tôi cam kết các thông tin cung cấp là chính xác và hoàn toàn đồng ý với ',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
                children: [
                  TextSpan(
                    text: 'Điều khoản sử dụng dịch vụ',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountLoadError extends StatelessWidget {
  const _AccountLoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.danger,
            size: 36,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 10),
          TextButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    );
  }
}

class _AccountOption extends StatelessWidget {
  const _AccountOption({
    required this.account,
    required this.selected,
    required this.onTap,
  });

  final String account;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFECFDF5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tài khoản chứng khoán',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    account,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.background,
                shape: BoxShape.circle,
                border: selected ? null : Border.all(color: AppColors.border),
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
