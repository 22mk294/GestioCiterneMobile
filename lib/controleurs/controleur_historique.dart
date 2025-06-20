// =============================
// controleurs/controleur_historique.dart (ajout generateCSV)
// =============================

import 'package:flutter/material.dart';
import '../modeles/modele_historique.dart';
import '../services/service_historique.dart';

class ControleurHistorique with ChangeNotifier {
  final ServiceHistorique _service = ServiceHistorique();
  List<EntreeHistorique> _historique = [];
  bool _chargement = false;
  int _jours = 7;

  List<EntreeHistorique> get historique => _historique;
  bool get chargement => _chargement;
  int get jours => _jours;

  double get consommationMoy => _historique.isEmpty ? 0 : totalConsomation / _historique.length;
  double get totalConsomation => _historique.fold(0, (s, e) => s + e.consommation);
  double get revenuTotal => _historique.fold(0, (s, e) => s + e.revenu);
  int get picConso => _historique.isEmpty ? 0 : _historique.map((e) => e.consommation).reduce((a, b) => a > b ? a : b);

  Future<void> chargerHistorique({int jours = 7}) async {
    _chargement = true;
    _jours = jours;
    notifyListeners();

    try {
      final data = await _service.recupererHistorique(jours);
      data.sort((a, b) => b.date.compareTo(a.date));
      _historique = data;
    } catch (_) {
      _historique = [];
    }

    _chargement = false;
    notifyListeners();
  }

  double variationPour(int i) {
    if (i >= _historique.length - 1) return double.nan;
    final a = _historique[i].consommation;
    final b = _historique[i + 1].consommation;
    return b == 0 ? double.nan : 100 * (a - b) / b;
  }

  String generateCSV() {
    final sb = StringBuffer('Date,Consommation (L),Revenu (FC)\n');
    for (var e in _historique) {
      sb.writeln('${e.date.toIso8601String().split('T').first},${e.consommation},${e.revenu.toStringAsFixed(0)}');
    }
    return sb.toString();
  }
}
