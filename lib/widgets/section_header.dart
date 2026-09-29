import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.number, required this.eyebrow, required this.title, required this.subtitle});
  final String number, eyebrow, title, subtitle;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [Text(number, style: const TextStyle(color: AppColors.cyan, fontFamily: 'monospace', fontSize: 10, letterSpacing: 1.2)),
      const SizedBox(width: 12), Container(width: 30, height: 1, color: AppColors.border), const SizedBox(width: 12),
      Text(eyebrow, style: const TextStyle(color: AppColors.muted, fontFamily: 'monospace', fontSize: 9, letterSpacing: 1.4, fontWeight: FontWeight.w600))]),
    const SizedBox(height: 18),
    Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: MediaQuery.sizeOf(context).width < 600 ? 31 : 42, letterSpacing: -1.4)),
    const SizedBox(height: 12), ConstrainedBox(constraints: const BoxConstraints(maxWidth: 720), child: Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 14, height: 1.8))),
  ]);
}
