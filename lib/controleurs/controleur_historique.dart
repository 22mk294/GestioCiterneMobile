import 'package:flutter/material.dart';
import '../modeles/modele_historique.dart';
import '../services/service_historique.dart';

class ControleurHistorique with ChangeNotifier {
  final ServiceHistorique _service = ServiceHistorique();

  List<EntreeHistorique> _historique = [];
  bool _chargement = false;

  List<EntreeHistorique> get historique => _historique;
  bool get chargement => _chargement;

  Future<void> chargerHistorique() async {
    _chargement = true;
    notifyListeners();

    try {
      _historique = await _service.recupererHistorique();
    } catch (e) {
      print("Erreur historique : $e");
    }

    _chargement = false;
    notifyListeners();
  }

  double get coutTotal {
    return _historique.fold(0.0, (somme, e) => somme + e.cout);
  }
}
