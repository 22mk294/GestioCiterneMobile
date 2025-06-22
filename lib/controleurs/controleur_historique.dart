import 'package:flutter/material.dart';
import '../modeles/modele_historique.dart';
import '../services/service_historique.dart';

class ControleurHistorique with ChangeNotifier {
  final ServiceHistorique _service = ServiceHistorique();
  List<EntreeHistorique> _historique = [];
  bool _chargement = false;
  int _jours = 7;

  /* ---------- Getters ---------- */
  List<EntreeHistorique> get historique => _historique;
  bool get chargement => _chargement;
  int get jours => _jours;

  double get totalConsomation =>
      _historique.fold(0, (s, e) => s + e.consommation);

  double get consommationMoy =>
      _historique.isEmpty ? 0 : totalConsomation / _historique.length;

  double get revenuTotal =>
      _historique.fold(0, (s, e) => s + e.revenu);

  int get picConso => _historique.isEmpty
      ? 0
      : _historique.map((e) => e.consommation).reduce((a, b) => a > b ? a : b).round();

  /* ---------- API ---------- */
  Future<void> chargerHistorique({int? jours}) async {
    _chargement = true;
    if (jours != null) _jours = jours;
    notifyListeners();

    try {
      _historique = await _service.recupererHistorique(_jours)
        ..sort((a, b) => b.date.compareTo(a.date));
    } catch (_) {
      _historique = [];
    }

    _chargement = false;
    notifyListeners();
  }

  /// 🔁 Rafraîchissement silencieux pour mise à jour en arrière-plan
  Future<void> chargerHistoriqueSilencieusement({int? jours}) async {
    if (jours != null) _jours = jours;
    try {
      final nouvellesDonnees = await _service.recupererHistorique(_jours)
        ..sort((a, b) => b.date.compareTo(a.date));

      // Rafraîchir uniquement si les données ont changé
      if (_sontDifferentes(nouvellesDonnees, _historique)) {
        _historique = nouvellesDonnees;
        notifyListeners();
      }
    } catch (_) {
      // silencieux
    }
  }

  /* ---------- Comparaison intelligente ---------- */
  bool _sontDifferentes(List<EntreeHistorique> a, List<EntreeHistorique> b) {
    if (a.length != b.length) return true;
    for (int i = 0; i < a.length; i++) {
      if (a[i].date != b[i].date ||
          a[i].consommation != b[i].consommation ||
          a[i].revenu != b[i].revenu) return true;
    }
    return false;
  }

  /* ---------- Utils ---------- */
  double variationPour(int i) {
    if (i >= _historique.length - 1) return double.nan;
    final a = _historique[i].consommation;
    final b = _historique[i + 1].consommation;
    return b == 0 ? double.nan : 100 * (a - b) / b;
  }

  String generateCSV() {
    final sb = StringBuffer('Date,Consommation (L),Revenu (FC)\n');
    for (var e in _historique) {
      sb.writeln(
          '${e.date.toIso8601String().split('T').first},${e.consommation.toStringAsFixed(0)},${e.revenu.toStringAsFixed(0)}');
    }
    return sb.toString();
  }
}
