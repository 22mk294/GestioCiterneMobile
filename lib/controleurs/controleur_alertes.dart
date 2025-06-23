// =============================
// controleurs/controleur_alertes.dart
// =============================

import 'package:flutter/material.dart';
import '../modeles/modele_alerte.dart';
import '../services/service_alertes_http.dart';

// Enumération des catégories d'alertes
//permet de selectionner dynamique une catégorie d'alerte
enum CategorieAlerte { toutes, critiques, importantes, informations }

// Contrôleur pour la gestion des alertes
class ControleurAlertes with ChangeNotifier {
  final ServiceAlertesHttp _service = ServiceAlertesHttp();

  List<Alerte> _alertes = []; // Liste des alertes
  bool _chargement = false;   // Indique si le chargement est en cours
  String? _erreur;            // Message d'erreur éventuel
  CategorieAlerte _categorie = CategorieAlerte.toutes; // Catégorie sélectionnée

  // ---------------- GETTERS ----------------
  bool get chargement => _chargement;
  String? get erreur => _erreur;
  CategorieAlerte get categorie => _categorie;

  /// Nombre total d'alertes non lues (calculé dynamiquement)
  int get nombreNonLues => _alertes.where((a) => !a.estLue).length;

  /// Alias pour compatibilité avec les anciens appels (nbNonLues)
  int get nbNonLues => nombreNonLues;

  /// Liste d'alertes filtrée par catégorie sélectionnée
  List<Alerte> get alertes {
    switch (_categorie) {
      case CategorieAlerte.critiques:
        return _alertes.where((a) => _isCritique(a.type)).toList();
      case CategorieAlerte.importantes:
        return _alertes.where((a) => _isImportante(a.type)).toList();
      case CategorieAlerte.informations:
        return _alertes.where((a) => _isInformation(a.type)).toList();
      case CategorieAlerte.toutes:
      default:
        return _alertes;
    }
  }

  int get nbCritiques   => _alertes.where((a) => _isCritique(a.type)).length;
  int get nbImportantes => _alertes.where((a) => _isImportante(a.type)).length;
  int get nbInfos       => _alertes.where((a) => _isInformation(a.type)).length;

  // ---------------- ACTIONS ----------------
  /// Récupère les alertes depuis l'API puis fusionne leur état « lue / non lue »
  Future<void> chargerAlertes() async {
    _chargement = true;
    notifyListeners();

    try {
      final recues = await _service.recupererAlertes();

      // Conserve l'état "estLue" si l'alerte existait déjà
      final etatLuParId = {for (var a in _alertes) a.id: a.estLue};
      _alertes = recues
          .map((a) => a.copyWith(estLue: etatLuParId[a.id] ?? false))
          .toList();

      _erreur = null;
    } catch (e) {
      _erreur = e.toString();
      _alertes = [];
    }

    _chargement = false;
    notifyListeners();
  }

  // Change la catégorie d'alerte affichée
  void changerCategorie(CategorieAlerte cat) {
    _categorie = cat;
    notifyListeners();
  }

  /// Marque toutes les alertes comme lues et met à jour le compteur
  void marquerToutesCommeLues() {
    if (nombreNonLues == 0) return;
    _alertes = _alertes.map((a) => a.copyWith(estLue: true)).toList();
    notifyListeners();
  }

  // ------------- HELPERS PRIVÉS -------------
  // Détermine si une alerte est critique selon son type
  bool _isCritique(String t)   => {'LOW_LEVEL', 'PUMP_FAILURE'}.contains(t);
  // Détermine si une alerte est importante selon son type
  bool _isImportante(String t) => {'HIGH_FLOW', 'VALVE_STUCK', 'POWER_FAILURE'}.contains(t);
  // Détermine si une alerte est une information selon son type
  bool _isInformation(String t)=> {'SYSTEM_UPDATE', 'SENSOR_ERROR'}.contains(t);
}
