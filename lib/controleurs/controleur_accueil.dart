import 'dart:async';
import 'package:flutter/material.dart';
import '../modeles/modele_donnees.dart';
import '../services/service_esp32_http.dart';

class ControleurAccueil with ChangeNotifier {
  final ServiceESP32Http _serviceHttp = ServiceESP32Http();

  DonneesCiterne? _donnees;
  bool _chargement = false;
  String? _erreur;

  Timer? _timer;

  ControleurAccueil() {
    _demarrerRafraichissementAutomatique();
  }

  DonneesCiterne? get donnees => _donnees;
  bool get chargement => _chargement;
  String? get erreur => _erreur;

  void _demarrerRafraichissementAutomatique() {
    // Premier chargement immédiat
    chargerDonnees();
    // Lancement du timer
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      chargerDonnees();
    });
  }

  Future<void> chargerDonnees() async {
    _chargement = true;
    notifyListeners();

    try {
      _donnees = await _serviceHttp.getInfosCiterne();
      _erreur = null;
    } catch (e) {
      _erreur = "Erreur lors de la récupération : $e";
      print("❌ $_erreur");
    }

    _chargement = false;
    notifyListeners();
  }

  Future<void> activerPompe() async {
    await _serviceHttp.envoyerCommande("pump", "ON");
    await chargerDonnees();
  }

  Future<void> arreterPompe() async {
    await _serviceHttp.envoyerCommande("pump", "OFF");
    await chargerDonnees();
  }

  Future<void> fermerVanne() async {
    await _serviceHttp.envoyerCommande("valve", "CLOSE");
    await chargerDonnees();
  }

  Future<void> ouvrirVanne() async {
    await _serviceHttp.envoyerCommande("valve", "OPEN");
    await chargerDonnees();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
