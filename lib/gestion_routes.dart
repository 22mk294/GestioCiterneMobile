import 'package:flutter/material.dart';
import 'vues/ecrans/ecran_accueil.dart';
import 'vues/ecrans/ecran_parametres.dart';
import 'vues/ecrans/ecran_historique.dart';
import 'vues/ecrans/ecran_alertes.dart';
import 'vues/ecrans/ecran_demarrage.dart';

class GestionRoutes {
  static const String demarrage = '/';
  static const String accueil = '/accueil';
  static const String parametres = '/parametres';
  static const String historique = '/historique';
  static const String alertes = '/alertes';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      demarrage: (context) => EcranDemarrage(),
      accueil: (context) => EcranAccueil(),
      parametres: (context) => EcranParametres(),
      historique: (context) => EcranHistorique(),
      alertes: (context) => EcranAlertes(),
    };
  }
}
