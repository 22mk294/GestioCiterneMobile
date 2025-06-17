import 'package:flutter/material.dart';
import '../modeles/modele_historique.dart';
import '../services/service_historique.dart';

class ControleurHistorique with ChangeNotifier {
  final ServiceHistorique _service = ServiceHistorique();

  List<EntreeHistorique> _historique = [];
  bool _chargement = false;
  int _jours = 7; // valeur par défaut

  List<EntreeHistorique> get historique => _historique;
  bool get chargement => _chargement;
  int get jours => _jours;

  Future<void> chargerHistorique({int jours = 7}) async {
    _chargement = true;
    _jours = jours;
    notifyListeners();

    try {
      _historique = await _service.recupererHistorique(jours);
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
