import 'package:flutter/material.dart';
import '../../gestion_routes.dart';

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
    return BottomNavigationBar(
      currentIndex: indexActif,
      onTap: (index) => _naviguer(index, context),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0XFFECEBF9),
      selectedItemColor: Colors.indigo,
      unselectedItemColor: Colors.black54,
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
  }
}
