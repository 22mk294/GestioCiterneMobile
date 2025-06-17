import 'package:flutter/material.dart';
import 'package:water/vues/ecrans/ecran_profil.dart';
import 'vues/ecrans/ecran_accueil.dart';
import 'vues/ecrans/ecran_parametres.dart';
import 'vues/ecrans/ecran_historique.dart';
import 'vues/ecrans/ecran_alertes.dart';
import 'vues/ecrans/ecran_demarrage.dart';
import 'vues/ecrans/ecran_erreur_connexion.dart';
import 'vues/ecrans/ecran_connexion.dart'; // Ajout

class GestionRoutes {
  static const String demarrage = '/';
  static const String accueil = '/accueil';
  static const String connexion = '/connexion';
  static const String parametres = '/parametres';
  static const String historique = '/historique';
  static const String alertes = '/alertes';
  static const String erreurConnexion = '/erreur_connexion';
  static const String profil = '/profil';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      demarrage: (context) => EcranDemarrage(),
      connexion: (context) => EcranConnexion(), // Ajout
      accueil: (context) => EcranAccueil(),
      parametres: (context) => EcranParametres(),
      historique: (context) => EcranHistorique(),
      alertes: (context) => EcranAlertes(),
      erreurConnexion: (context) => EcranErreurConnexion(),
      profil: (context) => EcranProfil(),
    };
  }
}
