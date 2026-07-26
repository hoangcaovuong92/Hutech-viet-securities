import 'package:flutter/material.dart';

import '../admin_models/registration_request.dart';
import '../admin_services/admin_registration_service.dart';
import '../theme/app_theme.dart';

class ScreenAdminRegistrations extends StatefulWidget {
  const ScreenAdminRegistrations({super.key});

  @override
  State<ScreenAdminRegistrations> createState() =>
      _ScreenAdminRegistrationsState();
}

class _ScreenAdminRegistrationsState extends State<ScreenAdminRegistrations> {
  final _service = AdminRegistrationService();
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RegistrationRequest>>(
      stream: _service.watchRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const _AdminError();
        }

        final requests = snapshot.data ?? const <RegistrationRequest>[];
        final filtered = _filter == 'all'
            ? requests
            : requests.where((item) => item.status == _filter).toList();

        return Column(
          children: [
            SizedBox(
              height: 54,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(
                    label: 'Tất cả (${requests.length})',
                    selected: _filter == 'all',
                    onSelected: () => setState(() => _filter = 'all'),
                  ),
                  _FilterChip(
                    label: 'Chờ duyệt (${_count(requests, 'pending')})',
                    selected: _filter == 'pending',
                    onSelected: () => setState(() => _filter = 'pending'),
                  ),
                  _FilterChip(
                    label: 'Đã duyệt (${_count(requests, 'approved')})',
                    selected: _filter == 'approved',
                    onSelected: () => setState(() => _filter = 'approved'),
                  ),
                  _FilterChip(
                    label: 'Từ chối (${_count(requests, 'rejected')})',
                    selected: _filter == 'rejected',
                    onSelected: () => setState(() => _filter = 'rejected'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const _EmptyRequests()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, index) => _RegistrationCard(
                        request: filtered[index],
                        onStatusChanged: _changeStatus,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  int _count(List<RegistrationRequest> items, String status) {
    return items.where((item) => item.status == status).length;
  }

  Future<void> _changeStatus(RegistrationRequest request, String status) async {
    try {
      await _service.updateStatus(request.id, status);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã cập nhật: ${_statusLabel(status)}')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể cập nhật trạng thái yêu cầu.'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}

class _RegistrationCard extends StatelessWidget {
  const _RegistrationCard({
    required this.request,
    required this.onStatusChanged,
  });

  final RegistrationRequest request;
  final void Function(RegistrationRequest request, String status)
  onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(request.status);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: const Icon(Icons.person_outline, color: AppColors.primaryDark),
        ),
        title: Text(
          request.fullName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel(request.status),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _formatDate(request.createdAt),
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
        children: [
          const Divider(),
          _InformationRow(label: 'CCCD', value: request.cccd),
          _InformationRow(label: 'Điện thoại', value: request.phone),
          _InformationRow(label: 'Email', value: request.email),
          _InformationRow(
            label: 'Loại tài khoản',
            value: request.accountTypes.join(', '),
          ),
          _InformationRow(label: 'TK môi giới', value: request.brokerAccount),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: request.status == 'rejected'
                      ? null
                      : () => onStatusChanged(request, 'rejected'),
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Từ chối'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: request.status == 'approved'
                      ? null
                      : () => onStatusChanged(request, 'approved'),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Duyệt'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Chưa cập nhật' : value,
              style: const TextStyle(color: AppColors.text, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyRequests extends StatelessWidget {
  const _EmptyRequests();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 54, color: AppColors.muted),
          SizedBox(height: 12),
          Text('Không có yêu cầu đăng ký.'),
        ],
      ),
    );
  }
}

class _AdminError extends StatelessWidget {
  const _AdminError();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Không thể đọc danh sách. Hãy kiểm tra quyền admin và Firestore Rules.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

String _statusLabel(String status) {
  return switch (status) {
    'approved' => 'Đã duyệt',
    'rejected' => 'Từ chối',
    'completed' => 'Hoàn tất',
    _ => 'Chờ duyệt',
  };
}

Color _statusColor(String status) {
  return switch (status) {
    'approved' => AppColors.primaryDark,
    'rejected' => AppColors.danger,
    'completed' => const Color(0xFF2563EB),
    _ => const Color(0xFFD97706),
  };
}

String _formatDate(DateTime? value) {
  if (value == null) return 'Chưa có thời gian';
  String twoDigits(int number) => number.toString().padLeft(2, '0');
  return '${twoDigits(value.day)}/${twoDigits(value.month)}/${value.year} '
      '${twoDigits(value.hour)}:${twoDigits(value.minute)}';
}
