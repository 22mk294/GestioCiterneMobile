import 'package:flutter/material.dart';
import '../composants/barre_navigation_inferieure.dart';

class EcranHistorique extends StatelessWidget {
  const EcranHistorique({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFF4F8FC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CONSOMMATION JOURNALIÈRE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            _buildLigneConsommation('7 AVR. 2024', '220 lit'),
            const Divider(),
            _buildLigneConsommation('6 AVR. 2024', '190 lit'),
            const SizedBox(height: 32),
            const Text(
              '\$11.00',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            //Expanded(
             // child: Image.asset(
                //'assets/images courbe.png',
                //fit: BoxFit.contain,
             // ),
            //),
          ],
        ),
      ),
      bottomNavigationBar: const BarreNavigationInferieure(indexActif: 2),
    );
  }

  Widget _buildLigneConsommation(String date, String valeur) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          date,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          valeur,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
