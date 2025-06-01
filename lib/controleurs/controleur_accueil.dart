import 'dart:async';
import 'package:flutter/material.dart';

import '../modeles/modele_donnees.dart';
import '../services/service_esp32_http.dart';

class ControleurAccueil with ChangeNotifier {
  final ServiceESP32Http _serviceHttp = ServiceESP32Http();

  DonneesCiterne? _donnees;
  DonneesCiterne? get donnees => _donnees;

  bool _chargement = false;
  String? _erreur;

  bool get chargement => _chargement;
  String? get erreur => _erreur;

  Timer? _timer;

  /// Charge les données depuis l'API une fois
  Future<void> chargerDonnees(BuildContext context) async {
    _chargement = true;
    _erreur = null;
    notifyListeners();

    try {
      final resultats = await _serviceHttp.getInfosCiterne();
      _donnees = resultats;
    } catch (e) {
      _erreur = "Erreur lors du chargement des données";
    }

    _chargement = false;
    notifyListeners();
  }

  /// Active le rafraîchissement périodique toutes les 10 secondes
  void demarrerRafraichissement(BuildContext context) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      chargerDonnees(context);
    });
  }

  /// Arrête le rafraîchissement automatique
  void arreterRafraichissement() {
    _timer?.cancel();
    _timer = null;
  }

  /// Active ou désactive la pompe
  Future<void> reglerPompe(BuildContext context, bool activer) async {
    final valeur = activer ? "ON" : "OFF";
    await _serviceHttp.envoyerCommande("pump", valeur);
    await chargerDonnees(context);
  }

  /// Ouvre ou ferme la vanne
  Future<void> reglerVanne(BuildContext context, bool ouvrir) async {
    final valeur = ouvrir ? "OPEN" : "CLOSE";
    await _serviceHttp.envoyerCommande("valve", valeur);
    await chargerDonnees(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
