import 'dart:ui';
import 'package:flutter/material.dart';

class PerformanceOverviewChartPainter extends CustomPainter {
  final List<double> points;
  final List<double> pointsDashed;

  PerformanceOverviewChartPainter({required this.points, required this.pointsDashed});

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = const Color(0xFF040A18)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paintDashed = Paint()
      ..color = const Color(0xFF9CA3AF)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final paintPoint = Paint()
      ..color = const Color(0xFF040A18)
      ..style = PaintingStyle.fill;

    final paintPointDashed = Paint()
      ..color = const Color(0xFF9CA3AF)
      ..style = PaintingStyle.fill;

    final path = Path();
    final dashedPath = Path();

    for (int i = 0; i < points.length; i++) {
      final x = (size.width / (points.length - 1)) * i;
      final y = size.height * (1 - points[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 4, paintPoint);
    }

    for (int i = 0; i < pointsDashed.length; i++) {
      final x = (size.width / (pointsDashed.length - 1)) * i;
      final y = size.height * (1 - pointsDashed[i]);
      if (i == 0) {
        dashedPath.moveTo(x, y);
      } else {
        dashedPath.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 3, paintPointDashed);
    }

    canvas.drawPath(path, paintLine);

    // Simple dashed line implementation
    _drawDashedPath(canvas, dashedPath, paintDashed);

    // Draw grid lines (horizontal)
    final paintGrid = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), paintGrid);
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double distance = 0.0;
    for (final PathMetric metric in path.computeMetrics()) {
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 5.0;
    const dashSpace = 3.0;

    double currentX = p1.dx;
    double currentY = p1.dy;
    while (currentX < p2.dx) {
      canvas.drawLine(
        Offset(currentX, currentY),
        Offset(currentX + dashWidth, currentY),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
