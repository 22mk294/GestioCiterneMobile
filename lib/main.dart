import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'controleurs/controleur_accueil.dart';
import 'services/service_connectivite.dart';
import 'gestion_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ControleurAccueil()),
        ChangeNotifierProvider(create: (_) => ServiceConnectivite()),
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
