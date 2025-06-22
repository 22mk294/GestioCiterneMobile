// =============================
// composants/barre_navigation_inferieure.dart
// =============================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../gestion_routes.dart';
import '../../utils/utils_affichage.dart';
import '../../services/service_etat_eau.dart';
import '../../controleurs/controleur_alertes.dart'; // 🔥

class BarreNavigationInferieure extends StatelessWidget {
  final int indexActif;
  const BarreNavigationInferieure({Key? key, required this.indexActif}) : super(key: key);

  void _naviguer(int index, BuildContext ctx) {
    switch (index) {
      case 0:
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
  Widget build(BuildContext context) {
    return Consumer2<ServiceEtatEau, ControleurAlertes>(
      builder: (context, etatEau, ctlAlertes, _) {
        final pourcentage = etatEau.donnees?.pourcentageEau ?? 0.0;
        final nbNonLues = ctlAlertes.nombreNonLues;

        return BottomNavigationBar(
          currentIndex: indexActif,
          onTap: (i) => _naviguer(i, context),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFFCDE5FE),
          selectedItemColor: getCouleurPourcentage(pourcentage),
          unselectedItemColor: Colors.black45,
          elevation: 10,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
            const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
            const BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Historique'),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.warning),
                  if (nbNonLues > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text('$nbNonLues',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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