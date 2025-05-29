import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controleurs/controleur_accueil.dart';
import 'gestion_routes.dart'; // Ton fichier de routes

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ControleurAccueil>(
          create: (_) => ControleurAccueil(),
        ),
        // Tu peux ajouter d’autres providers ici
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Citerne',
      debugShowCheckedModeBanner: false,
      initialRoute: GestionRoutes.demarrage,
      routes: GestionRoutes.getRoutes(),
    );
  }
}
