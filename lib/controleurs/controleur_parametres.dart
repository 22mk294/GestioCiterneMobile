// lib/controleurs/controleur_parametres.dart
import 'package:flutter/material.dart';
import '../modeles/modele_parametres.dart';
import '../services/service_parametre.dart';

class ControleurParametres extends ChangeNotifier {
  final ServiceParametresHttp _service = ServiceParametresHttp();
  ParametresCiterne? parametres;

  Future<void> chargerParametres() async {
    parametres = await _service.getParametres();
    notifyListeners();
  }

  Future<void> mettreAJour(ParametresCiterne nouveauxParametres) async {
    await _service.mettreAJourParametres(nouveauxParametres);
    parametres = nouveauxParametres;
    notifyListeners();
  }
}
