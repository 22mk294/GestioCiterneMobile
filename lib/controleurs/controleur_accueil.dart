import 'dart:async';
import 'package:flutter/material.dart';

import '../modeles/modele_donnees.dart';
import '../services/service_esp32_http.dart';

/*
  c'est une classe qui etend les capacités de ChangeNotifier
  cela permet à la vue d'^tre notifiée des changements
  notifierListeners() est appelé pour notifier les vues
 */
class ControleurAccueil with ChangeNotifier {
  // Instance du service HTTP pour communiquer avec l'ESP32
  final ServiceESP32Http _serviceHttp = ServiceESP32Http();

  // le point ? signifie que la variable peut être nulle
  DonneesCiterne? _donnees;
  DonneesCiterne? get donnees => _donnees;


  bool _chargement = false;
  String? _erreur;

  // Getters pour les états de chargement et d'erreur et pour exposer les donnéesde façon sécurisée
  bool get chargement => _chargement;
  String? get erreur => _erreur;

  // Ajout des états de chargement locaux pour la pompe et la vanne
  bool? _chargementPompe = false;
  bool? _chargementVanne = false;

  bool? get chargementPompe => _chargementPompe; //pour afficher le chargement de la pompe dans la vue
  bool? get chargementVanne => _chargementVanne;

  // Un timer pour les mises à jour automatiques
  Timer? _timer;

  /// Charge les données depuis l'API une fois
  Future<void> chargerDonnees(BuildContext context) async {
    _chargement = true;
    _erreur = null;
    notifyListeners();

    try {
      //await le résultat de l'appel à l'API
      final resultats = await _serviceHttp.getInfosCiterne();
      _donnees = resultats;
    } catch (e) {
      _erreur = "Erreur lors du chargement des données";
    }

    _chargement = false;
    notifyListeners();
  }

  /// Active ou désactive la pompe
  Future<void> reglerPompe(BuildContext context, bool activer) async {
    _chargementPompe = true;
    notifyListeners();

    final pompe = activer ? "1" : "0";
    final vanne = _donnees?.vanne.toUpperCase() == "OPEN" ? "1" : "0";

    //envoyer la commande de contrôle à l'ESP32 http
    final success = await _serviceHttp.envoyerCommandeControle(
      pumpState: pompe,
      valveState: vanne,

    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors du contrôle de la pompe")),
      );
    }

    await chargerDonnees(context);

    _chargementPompe = false;
    notifyListeners();
  }

  /// Ouvre ou ferme la vanne
  Future<void> reglerVanne(BuildContext context, bool ouvrir) async {
    _chargementVanne = true;
    notifyListeners();

    final pompe = _donnees?.pompe.toUpperCase() == "ON" ? "1" : "0";
    final vanne = ouvrir ? "1" : "0";

    final success = await _serviceHttp.envoyerCommandeControle(
      pumpState: pompe,
      valveState: vanne,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors du contrôle du robinet")),
      );
    }

    await chargerDonnees(context);

    _chargementVanne = false;
    notifyListeners();
  }
}
