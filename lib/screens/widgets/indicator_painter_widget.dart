import 'package:flutter/material.dart';

class IndicatorPainterWidget extends CustomPainter {
  final Color color;

  IndicatorPainterWidget({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, size.height); // Top center
    path.lineTo(size.width, 0); // Bottom right
    path.lineTo(0, 0); // Bottom left
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
