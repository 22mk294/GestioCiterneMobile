// =============================
// composants/barre_navigation_inferieure.dart
// =============================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../gestion_routes.dart';
import '../../utils/utils_affichage.dart';
import '../../services/service_etat_eau.dart';
import '../../controleurs/controleur_alertes.dart'; // 🔥

// Widget pour la barre de navigation inférieure
class BarreNavigationInferieure extends StatelessWidget {
  final int indexActif; // Index de l'onglet actif
  const BarreNavigationInferieure({Key? key, required this.indexActif}) : super(key: key);

  // Méthode pour naviguer vers l'écran correspondant via Navigator.pushReplacementNamed
  void _naviguer(int index, BuildContext ctx) {
    switch (index) {
      case 0:
        // Vérifie si l'écran actuel n'est pas déjà l'accueil
        if (ModalRoute.of(ctx)?.settings.name != GestionRoutes.accueil) {
          Navigator.pushReplacementNamed(ctx, GestionRoutes.accueil);
        }
        break;
      case 1:
        if (ModalRoute.of(ctx)?.settings.name != GestionRoutes.parametres) {
          Navigator.pushReplacementNamed(ctx, GestionRoutes.parametres);
        }
        break;
      case 2:
        if (ModalRoute.of(ctx)?.settings.name != GestionRoutes.historique) {
          Navigator.pushReplacementNamed(ctx, GestionRoutes.historique);
        }
        break;
      case 3:
        if (ModalRoute.of(ctx)?.settings.name != GestionRoutes.alertes) {
          Navigator.pushReplacementNamed(ctx, GestionRoutes.alertes);
        }
        break;
    }
  }

  @override
  // Méthode build qui construit la barre de navigation inférieure
  // Utilise Consumer2 pour écouter les changements dans ServiceEtatEau et ControleurAlertes
  Widget build(BuildContext context) {
    return Consumer2<ServiceEtatEau, ControleurAlertes>(
      builder: (context, etatEau, ctlAlertes, _) {
        final pourcentage = etatEau.donnees?.pourcentageEau ?? 0.0; // Récupère le pourcentage d'eau
        final nbNonLues = ctlAlertes.nombreNonLues; // Nombre d'alertes non lues

        // Retourne un widget BottomNavigationBar
        return BottomNavigationBar(
          currentIndex: indexActif, // Onglet actif
          onTap: (i) => _naviguer(i, context), // Navigation lors du clic
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFFCDE5FE),
          selectedItemColor: getCouleurPourcentage(pourcentage), // Couleur dynamique
          unselectedItemColor: Colors.blueGrey,
          elevation: 10,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
            const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
            const BottomNavigationBarItem(icon: Icon(Icons.show_chart_rounded), label: 'Historique'),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.warning_amber),
                  // Affiche un badge si il y a des alertes non lues
                  if (nbNonLues > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text('$nbNonLues',
                            style: const TextStyle(color: Colors.yellow, fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                      ),
                    ),
                ],
              ),
              label: 'Alertes',
            ),
          ],
        );
      },
    );
  }
}
