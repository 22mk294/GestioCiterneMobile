import 'package:flutter/material.dart';
import '../modeles/modele_donnees.dart';
import '../services/service_esp32_http.dart';

class ControleurAccueil with ChangeNotifier {
  final ServiceESP32Http _serviceHttp = ServiceESP32Http();

  DonneesCiterne? _donnees;
  bool _chargement = false;

  DonneesCiterne? get donnees => _donnees;
  bool get chargement => _chargement;

  Future<void> chargerDonnees() async {
    _chargement = true;
    notifyListeners();

    try {
      _donnees = await _serviceHttp.getInfosCiterne();
    } catch (e) {
      print("Erreur lors de la récupération : $e");
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
}
