import 'package:flutter/material.dart';
import '../composants/barre_superieure.dart';

// Écran affichant les informations du profil utilisateur
class EcranProfil extends StatelessWidget {
  const EcranProfil({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemple d'informations utilisateur à afficher
    const utilisateur = {
      'nom': 'Jean Dupont',
      'email': 'jean.dupont@example.com',
      'tank_id': '1',
    };

    return Scaffold(
      appBar: const BarreSuperieure(
        titre: 'Profil',
        afficherRetour: true,
      ),
      backgroundColor: const Color(0xFFE3EDF7),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
            _infoLigne('Nom', utilisateur['nom']!), // Affiche le nom
            _infoLigne('Email', utilisateur['email']!), // Affiche l'email
            _infoLigne('Réservoir', 'ID #${utilisateur['tank_id']}'), // Affiche l'ID du réservoir
          ],
        ),
      ),
    );
  }

  // Widget pour afficher une ligne d'information (titre + valeur)
  Widget _infoLigne(String titre, String valeur) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$titre : ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(valeur),
          ),
        ],
      ),
    );
  }
}

