import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controleurs/controleur_accueil.dart';
import 'controleurs/controleur_alertes.dart';
import 'controleurs/controleur_parametres.dart';
import 'controleurs/controleur_historique.dart'; // 👈 nouveau
import 'services/service_connectivite.dart';
import 'services/service_etat_eau.dart';
import 'services/service_rafraichissement.dart';
import 'services/service_rafraichissement_historique.dart'; // 👈 nouveau
import 'gestion_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ControleurAccueil()),
        ChangeNotifierProvider(create: (_) => ControleurParametres()),
        ChangeNotifierProvider(create: (_) => ServiceConnectivite()),
        ChangeNotifierProvider(create: (_) => ServiceEtatEau()),
        ChangeNotifierProvider(create: (_) => ControleurAlertes()),
        ChangeNotifierProvider(create: (_) => ControleurHistorique()), // 👈 injection globale
        Provider(create: (_) => ServiceRafraichissementDonnees()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialise = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialise) {
      final connectivite = Provider.of<ServiceConnectivite>(context, listen: false);

      if (connectivite.estConnecte) {
        final serviceRafraichissement =
        Provider.of<ServiceRafraichissementDonnees>(context, listen: false);
        serviceRafraichissement.demarrer(context);

        // 👇 démarre le service historique global
        ServiceRafraichissementHistorique.instance.demarrer(context, intervalle: 10);
      }

      _initialise = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceConnectivite>(
      builder: (context, connectivite, child) {
        return MaterialApp(
          title: 'Gestion Citerne',
          debugShowCheckedModeBanner: false,
          initialRoute: connectivite.estConnecte
              ? GestionRoutes.demarrage
              : GestionRoutes.erreurConnexion,
          routes: GestionRoutes.getRoutes(),
        );
      },
    );
  }
}
