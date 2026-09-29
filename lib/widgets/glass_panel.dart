import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlassPanel extends StatelessWidget {
  const GlassPanel({super.key, required this.child, this.padding = const EdgeInsets.all(22)});
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: AppColors.panel.withValues(alpha: .94),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.border),
      boxShadow: const [BoxShadow(color: Color(0x18000000), blurRadius: 22, offset: Offset(0, 10))],
    ),
    child: child,
  );
}
