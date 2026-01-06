import 'dart:math';
import 'package:flutter/material.dart';

class ClockTicksPainter extends CustomPainter {
  final Color color;
  final int ticks;

  ClockTicksPainter({required this.color, this.ticks = 60});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    for (int i = 0; i < ticks; i++) {
      // Calculate angle for each tick
      final angle = 2 * pi * i / ticks;

      // Determine tick length (every 5th tick is slightly longer)
      final isMajor = i % 5 == 0;
      final tickLength = isMajor ? 15.0 : 8.0;

      // Start point (outer rim)
      final startX = center.dx + (radius) * cos(angle);
      final startY = center.dy + (radius) * sin(angle);

      // End point (inner rim)
      final endX = center.dx + (radius - tickLength) * cos(angle);
      final endY = center.dy + (radius - tickLength) * sin(angle);

      // Adjust paint for major ticks if needed
      paint.strokeWidth = isMajor ? 3 : 1.5;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
