import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';

class FlowPage extends StatelessWidget {
  const FlowPage({
    super.key,
    required this.child,
    this.buttonLabel,
    this.onPressed,
    this.buttonLoading = false,
    this.backgroundColor = AppColors.background,
    this.scrollable = true,
  });

  final Widget child;
  final String? buttonLabel;
  final VoidCallback? onPressed;
  final bool buttonLoading;
  final Color backgroundColor;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: child,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: scrollable
                  ? SingleChildScrollView(child: content)
                  : content,
            ),
            if (buttonLabel != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: PrimaryButton(
                  label: buttonLabel!,
                  onPressed: onPressed,
                  isLoading: buttonLoading,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class StepHeader extends StatelessWidget {
  const StepHeader({
    super.key,
    required this.step,
    required this.progress,
    required this.title,
    required this.subtitle,
  });

  final String step;
  final double progress;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              step,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${(progress * 100).round()}% Hoàn thành',
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
        const SizedBox(height: 16),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
