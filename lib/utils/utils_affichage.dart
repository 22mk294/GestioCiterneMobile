import 'package:flutter/material.dart';

Color getCouleurPourcentage(double p) {
  if (p < 0.2) return Colors.red;
  if (p < 0.5) return Colors.orangeAccent;
  return Color(0XFF0D9C03);
}
