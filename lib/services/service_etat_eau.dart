// lib/services/service_etat_eau.dart

import 'package:flutter/material.dart';
import '../modeles/modele_donnees.dart';

class ServiceEtatEau with ChangeNotifier {
  DonneesCiterne? _donnees;

  DonneesCiterne? get donnees => _donnees;
  double get pourcentageEau => _donnees?.pourcentageEau ?? 0.0;

  void mettreAJourDonnees(DonneesCiterne nouvellesDonnees) {
    _donnees = nouvellesDonnees;
    notifyListeners();
  }

  void mettreAJourPourcentage(double pourcentage) {
    if (_donnees != null) {
      _donnees = _donnees!.copyWith(pourcentageEau: pourcentage);
      notifyListeners();
    }
  }
}
