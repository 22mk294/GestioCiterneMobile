import 'package:flutter/material.dart';
import 'dart:math';

import '../../utils/utils_affichage.dart'; // fonction de couleur partagée

// CustomPainter pour dessiner un cercle avec un arc représentant un pourcentage d'eau
class CercleEauPainter extends CustomPainter {
  final double pourcentage; // Valeur du pourcentage à afficher (entre 0 et 1)

  // Constructeur prenant le pourcentage à afficher
  CercleEauPainter({required this.pourcentage});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 13.0; // Largeur du trait du cercle
    final center = size.center(Offset.zero); // Centre du canvas
    final radius = (size.width - strokeWidth) / 2; // Rayon du cercle

    // Peinture pour le cercle d'arrière-plan (gris)
    final backgroundPaint = Paint()
      ..color = Colors.grey // Couleur grise pour l'arrière-plan
      ..style = PaintingStyle.stroke // Style trait (pas rempli)
      ..strokeWidth = strokeWidth; // Largeur du trait

    // Peinture pour l'arc de premier plan (couleur selon le pourcentage)
    final foregroundPaint = Paint()
      ..color = getCouleurPourcentage(pourcentage) // Couleur dynamique selon le pourcentage
      ..style = PaintingStyle.stroke // Style trait
      ..strokeCap = StrokeCap.round // Extrémités arrondies pour l'arc
      ..strokeWidth = strokeWidth; // Largeur du trait

    // Dessine le cercle d'arrière-plan
    canvas.drawCircle(center, radius, backgroundPaint);

    // Calcule l'angle de l'arc à dessiner selon le pourcentage
    final angle = 2 * pi * pourcentage;
    // Dessine l'arc de premier plan (partie colorée)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius), // Zone de l'arc
      -pi / 2, // Commence en haut du cercle
      angle,   // Longueur de l'arc
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true; // Toujours repeindre
}
