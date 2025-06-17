import 'package:flutter/cupertino.dart';

import '../modeles/modele_donnees.dart';

class ServiceEtatEau with ChangeNotifier {
  DonneesCiterne? _donnees;
  int _frequence = 10; // Valeur par défaut en secondes

  DonneesCiterne? get donnees => _donnees;
  double get pourcentageEau => _donnees?.pourcentageEau ?? 0.0;
  int get frequence => _frequence;

  void mettreAJourDonnees(DonneesCiterne nouvellesDonnees) {
    _donnees = nouvellesDonnees;
    notifyListeners();
  }




}
