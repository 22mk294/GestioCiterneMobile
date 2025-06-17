import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../gestion_routes.dart';
import '../../utils/utils_affichage.dart';
import '../../services/service_etat_eau.dart'; // ✅ on utilise le service qui contient les données à jour

class BarreNavigationInferieure extends StatelessWidget {
  final int indexActif;

  const BarreNavigationInferieure({
    Key? key,
    required this.indexActif,
  }) : super(key: key);

  void _naviguer(int index, BuildContext context) {
    switch (index) {
      case 0:
        if (ModalRoute.of(context)?.settings.name != GestionRoutes.accueil) {
          Navigator.pushReplacementNamed(context, GestionRoutes.accueil);
        }
        break;
      case 1:
        if (ModalRoute.of(context)?.settings.name != GestionRoutes.parametres) {
          Navigator.pushReplacementNamed(context, GestionRoutes.parametres);
        }
        break;
      case 2:
        if (ModalRoute.of(context)?.settings.name != GestionRoutes.historique) {
          Navigator.pushReplacementNamed(context, GestionRoutes.historique);
        }
        break;
      case 3:
        if (ModalRoute.of(context)?.settings.name != GestionRoutes.alertes) {
          Navigator.pushReplacementNamed(context, GestionRoutes.alertes);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceEtatEau>(
      builder: (context, etatEau, _) {
        final pourcentageEau = etatEau.donnees?.pourcentageEau ?? 0.0;

        return BottomNavigationBar(
          currentIndex: indexActif,
          onTap: (index) => _naviguer(index, context),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: getCouleurPourcentage(pourcentageEau),
          unselectedItemColor: Colors.black45,
          elevation: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Paramètres',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: 'Historique',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.warning),
              label: 'Alertes',
            ),
          ],
        );
      },
    );
  }
}
