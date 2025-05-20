// Importation du package Flutter pour l'interface utilisateur.
import 'package:flutter/material.dart';
// Importation du fichier de gestion des routes personnalisé.
import 'gestion_routes.dart';

// Point d'entrée de l'application.
void main() {
  // Lance l'application en appelant le widget principal MonApp.
  runApp(MonApp());
}

// Définition du widget principal de l'application.
class MonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retourne une application MaterialApp avec des configurations personnalisées.
    return MaterialApp(
      title: 'Gestion Citerne', // Titre de l'application.
      debugShowCheckedModeBanner: false, // Désactive le bandeau de debug.
      initialRoute: GestionRoutes.demarrage, // Définit la route initiale au démarrage.
      routes: GestionRoutes.getRoutes(), // Définit les routes de navigation de l'application.
    );
  }
}
