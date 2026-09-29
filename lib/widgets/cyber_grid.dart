import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CyberGrid extends StatelessWidget {
  const CyberGrid({super.key});
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: CustomPaint(painter: _GridPainter(), child: const SizedBox.expand()),
  );
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.cyan.withValues(alpha: .025)..strokeWidth = 1;
    const step = 44.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    final glowPaint = Paint()..shader = RadialGradient(colors: [
      AppColors.cyan.withValues(alpha: .07), Colors.transparent,
    ]).createShader(Rect.fromCircle(center: Offset(size.width * .78, 240), radius: 440));
    canvas.drawRect(Offset.zero & size, glowPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
