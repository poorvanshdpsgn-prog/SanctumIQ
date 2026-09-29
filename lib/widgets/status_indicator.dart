import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatusIndicator extends StatelessWidget {
  const StatusIndicator({super.key, required this.label, this.small = false});
  final String label;
  final bool small;
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: small ? 5 : 7, height: small ? 5 : 7,
      decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)),
    SizedBox(width: small ? 7 : 10),
    Flexible(child: Text(label, maxLines: small ? 1 : 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontFamily: 'monospace', fontSize: small ? 8 : 9,
        color: AppColors.green, letterSpacing: small ? .8 : 1.2, fontWeight: FontWeight.w600))),
  ]);
}
