import 'package:flutter/material.dart';
import '../modeles/modele_parametres.dart';
import '../services/service_parametre.dart';

class ControleurParametres extends ChangeNotifier {
  final ServiceParametresHttp _service = ServiceParametresHttp();
  ParametresCiterne? _parametres;
  bool _chargement = true;

  ParametresCiterne? get parametres => _parametres;
  bool get estCharge => !_chargement;

  Future<void> chargerParametres() async {
    _chargement = true;
    notifyListeners();

    _parametres = await _service.getParametres();

    _chargement = false;
    notifyListeners();
  }

  Future<void> mettreAJour(ParametresCiterne nouveauxParams) async {
    await _service.mettreAJourParametres(nouveauxParams);
    _parametres = nouveauxParams;
    notifyListeners();
  }
}
