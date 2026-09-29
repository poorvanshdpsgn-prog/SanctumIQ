import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SciButton extends StatelessWidget {
  const SciButton({super.key, required this.label, required this.onPressed, this.outlined = false, this.compact = false});
  final String label;
  final VoidCallback onPressed;
  final bool outlined, compact;
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontFamily: 'monospace', fontSize: compact ? 9 : 10,
      letterSpacing: 1, fontWeight: FontWeight.w700,
      color: outlined ? AppColors.cyan : AppColors.background);
    return SizedBox(height: compact ? 36 : 46,
      child: outlined
        ? OutlinedButton(onPressed: onPressed, style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.cyan, side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 20)), child: Text(label, style: style))
        : FilledButton(onPressed: onPressed, style: FilledButton.styleFrom(
            backgroundColor: AppColors.cyan, foregroundColor: AppColors.background,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 20)), child: Text(label, style: style)));
  }
}
