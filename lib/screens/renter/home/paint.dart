import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:math' as math;

import 'package:gti_rides/styles/styles.dart';

class PercentagePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    var frontColoredPaint = Paint();
    frontColoredPaint.style = PaintingStyle.stroke;
    // frontColoredPaint.strokeCap = StrokeCap.round;
    frontColoredPaint.strokeWidth = 7;
    frontColoredPaint.color = primaryColor;

    double start = 300;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      start.toRadians(),
      // (220 * (percentage / 100)).toRadians(),
      193.toRadians(),

      false,
      frontColoredPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

extension NumToRadians on num {
  double toRadians() {
    return toDouble() * (math.pi / 180.0);
  }

  double toDegree() {
    return toDouble() * (180 / math.pi);
  }
}
