import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

class OtpBoxes extends StatefulWidget {
  const OtpBoxes({
    super.key,
    this.initialCode = '',
    this.readOnly = false,
    this.onChanged,
  });

  final String initialCode;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  @override
  State<OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<OtpBoxes> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (index) {
      final value = index < widget.initialCode.length
          ? widget.initialCode[index]
          : '';
      return TextEditingController(text: value);
    });
    _focusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _change(int index, String value) {
    if (value.isNotEmpty && index < 5) _focusNodes[index + 1].requestFocus();
    if (value.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
    widget.onChanged?.call(_controllers.map((e) => e.text).join());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(6, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == 5 ? 0 : 6),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              readOnly: widget.readOnly,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                color: AppColors.navy,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              onChanged: (value) => _change(index, value),
            ),
          ),
        );
      }),
    );
  }
}
