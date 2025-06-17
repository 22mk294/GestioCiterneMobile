import 'package:flutter/material.dart';
import '../modeles/modele_alerte.dart';
import '../services/service_alertes_http.dart';

class ControleurAlertes with ChangeNotifier {
  final ServiceAlertesHttp _service = ServiceAlertesHttp();

  List<Alerte> _alertes = [];
  bool _chargement = false;
  String? _erreur;

  List<Alerte> get alertes => _alertes;
  bool get chargement => _chargement;
  String? get erreur => _erreur;

  Future<void> chargerAlertes() async {
    _chargement = true;
    notifyListeners();

    try {
      _alertes = await _service.recupererAlertes();
      _erreur = null;
    } catch (e) {
      _erreur = e.toString();
      _alertes = [];
    }

    _chargement = false;
    notifyListeners();
  }
}
