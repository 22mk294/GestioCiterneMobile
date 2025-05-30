import 'package:flutter/material.dart';
import 'dart:math';

import '../../utils/utils_affichage.dart'; // fonction de couleur partagée

class CercleEauPainter extends CustomPainter {
  final double pourcentage;

  CercleEauPainter({required this.pourcentage});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 18.0;
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final foregroundPaint = Paint()
      ..color = getCouleurPourcentage(pourcentage) // fonction externe partagée
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    final angle = 2 * pi * pourcentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
