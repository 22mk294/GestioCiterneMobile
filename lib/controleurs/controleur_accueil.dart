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


  /// Arrête le rafraîchissement automatique

  /// Active ou désactive la pompe
  Future<void> reglerPompe(BuildContext context, bool activer) async {
    final pompe = activer ? "1" : "0";
    final vanne = _donnees?.vanne.toUpperCase() == "OPEN" ? "1" : "0";
    final buzzer = _donnees?.buzzer.toUpperCase() == "ON" ? "1" : "0";

    final success = await _serviceHttp.envoyerCommandeControle(
      pumpState: pompe,
      valveState: vanne,
      buzzerState: buzzer,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors du contrôle de la pompe")),
      );
    }

    await chargerDonnees(context);
  }


  /// Ouvre ou ferme la vanne
  Future<void> reglerVanne(BuildContext context, bool ouvrir) async {
    final pompe = _donnees?.pompe.toUpperCase() == "ON" ? "1" : "0";
    final vanne = ouvrir ? "1" : "0";
    final buzzer = _donnees?.buzzer.toUpperCase() == "ON" ? "1" : "0";

    final success = await _serviceHttp.envoyerCommandeControle(
      pumpState: pompe,
      valveState: vanne,
      buzzerState: buzzer,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors du contrôle du robinet")),
      );
    }

    await chargerDonnees(context);
  }
  /// Active ou désactive l'alarme (buzzer)
  Future<void> reglerBuzzer(BuildContext context, bool activer) async {
    final valeur = activer ? "ON" : "OFF";
    await _serviceHttp.envoyerCommande("buzzer", valeur);
    await chargerDonnees(context);
  }


}
