// Importation des bibliothèques nécessaires
import 'package:flutter/material.dart';
// Importation des différents écrans utilisés dans l'application
import 'vues/ecrans/ecran_accueil.dart';
import 'vues/ecrans/ecran_parametres.dart';
import 'vues/ecrans/ecran_historique.dart';
import 'vues/ecrans/ecran_alertes.dart';
import 'vues/ecrans/ecran_demarrage.dart';
import 'vues/ecrans/ecran_erreur_connexion.dart';

// Classe qui gère les routes de navigation de l'application
class GestionRoutes {
  // Définition des routes sous forme de constantes pour éviter les erreurs de frappe
  static const String demarrage = '/';
  static const String accueil = '/accueil';
  static const String parametres = '/parametres';
  static const String historique = '/historique';
  static const String alertes = '/alertes';
  static const String erreurConnexion = '/erreur_connexion';

  // Méthode statique qui retourne une map des routes de l'application
  // Chaque route est associée à une fonction qui construit l'écran correspondant
  static Map<String, WidgetBuilder> getRoutes() {
    return {

      demarrage: (context) => EcranDemarrage(),
      accueil: (context) => EcranAccueil(),
      erreurConnexion: (_) => EcranErreurConnexion(),
      parametres: (context) => EcranParametres(),
      historique: (context) => EcranHistorique(),
      alertes: (context) => EcranAlertes(),

              // Route de l'écran des alertes

    };
  }
}
