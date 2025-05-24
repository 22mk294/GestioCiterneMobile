import 'package:flutter/material.dart';
import '../composants/barre_navigation_inferieure.dart';
import 'dart:math';

class EcranAccueil extends StatelessWidget {
  const EcranAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          children: [
            // ✅ Cercle stylisé sans dégradé
            SizedBox(
              height: 220,
              width: 220,
              child: CustomPaint(
                painter: CercleEauPainter(pourcentage: 0.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        '0%',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'NIVEAU ACTUEL',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),


            const SizedBox(height: 20),
            // Bouton principal
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blue,
                ),
                child: const Text("Arrêter",
                style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Bouton secondaire
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Réactiver les robinets"),
              ),
            ),
            const SizedBox(height: 30),
            // STATUT / ALERTES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('STATUT', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 4),
                    Text('Pompe', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('ALERTES', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 4),
                    Text('Aucune', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Robinet', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),

              ],
            ),
            const SizedBox(height: 20),
            // Données
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CONSOMMATION', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 4),
                    Text('220 L', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('REVENU', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 4),
                    Text('\$11.00', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),

          ],

        ),
      ),
      bottomNavigationBar: BarreNavigationInferieure(
        indexActif: 0,

      ),
    );
  }
}

class CercleEauPainter extends CustomPainter {
  final double pourcentage;

  CercleEauPainter({required this.pourcentage});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 18.0;
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final foregroundPaint = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    // Cercle de fond gris
    canvas.drawCircle(center, radius, backgroundPaint);

    // Arc bleu foncé représentant le niveau
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
