import 'package:flutter/material.dart';

import '../auth_services/auth_service.dart';
import '../theme/app_theme.dart';
import 'screen_admin_registrations.dart';
import 'screen_market.dart';
import 'screen_welcome.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key, required this.session});

  final AuthSession session;

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final _authService = AuthService();
  int _selectedIndex = 0;

  Future<void> _logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ScreenWelcome()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const ScreenMarket(),
      if (widget.session.isAdmin) const ScreenAdminRegistrations(),
    ];
    final titles = <String>[
      'Thông tin thị trường',
      if (widget.session.isAdmin) 'Quản lý đăng ký',
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(titles[_selectedIndex]),
          actions: [
            PopupMenuButton<String>(
              tooltip: 'Tài khoản',
              onSelected: (value) {
                if (value == 'logout') _logout();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  enabled: false,
                  child: Text(
                    widget.session.email,
                    style: const TextStyle(color: AppColors.text),
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded),
                      SizedBox(width: 10),
                      Text('Đăng xuất'),
                    ],
                  ),
                ),
              ],
              icon: CircleAvatar(
                radius: 17,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: Icon(
                  widget.session.isAdmin
                      ? Icons.admin_panel_settings_outlined
                      : Icons.person_outline,
                  color: AppColors.primaryDark,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: IndexedStack(index: _selectedIndex, children: pages),
        bottomNavigationBar: widget.session.isAdmin
            ? NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (value) {
                  setState(() => _selectedIndex = value);
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.candlestick_chart_outlined),
                    selectedIcon: Icon(Icons.candlestick_chart),
                    label: 'Thị trường',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.assignment_outlined),
                    selectedIcon: Icon(Icons.assignment),
                    label: 'Yêu cầu',
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
