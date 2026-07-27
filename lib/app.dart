import 'package:flutter/material.dart';

import 'flow_screens/screen_welcome.dart';
import 'theme/app_theme.dart';

class VietStockApp extends StatelessWidget {
  const VietStockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VietStock',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const ScreenWelcome(),
    );
  }
}
