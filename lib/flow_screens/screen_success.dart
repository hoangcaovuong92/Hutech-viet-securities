import 'package:flutter/material.dart';

import '../flow_widgets/flow_page.dart';
import '../flow_widgets/success_body.dart';
import 'screen_login.dart';

class ScreenSuccess extends StatelessWidget {
  const ScreenSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowPage(
      backgroundColor: Colors.white,
      buttonLabel: 'Bắt đầu giao dịch',
      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const ScreenLogin()),
        (_) => false,
      ),
      child: const SuccessBody(),
    );
  }
}
