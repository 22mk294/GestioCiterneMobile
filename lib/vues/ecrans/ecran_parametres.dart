import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/service_connectivite.dart';
import '../composants/barre_navigation_inferieure.dart';
import 'ecran_erreur_connexion.dart';

class EcranParametres extends StatelessWidget {
  const EcranParametres({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceConnectivite>(
      builder: (context, serviceConnectivite, child) {
        if (!serviceConnectivite.estConnecte) {
          return EcranErreurConnexion(); // Affiche la page d’erreur
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Paramètres'),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            foregroundColor: Colors.black,
          ),
          backgroundColor: const Color(0xFFF4F8FC),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLigneParametre('Niveau critique', '30%'),
                  _buildLigneParametre('Mode', 'Automatique'),
                  _buildLigneParametre('Notifications', 'Activées'),
                  _buildLigneParametre('Prix pour 20 litres', '1,00'),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const BarreNavigationInferieure(indexActif: 1),
        );
      },
    );
  }

  Widget _buildLigneParametre(String libelle, String valeur) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            libelle,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            valeur,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
