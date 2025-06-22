import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controleurs/controleur_historique.dart';

class ServiceRafraichissementHistorique {
  static final ServiceRafraichissementHistorique _instance = ServiceRafraichissementHistorique._internal();
  factory ServiceRafraichissementHistorique() => _instance;
  ServiceRafraichissementHistorique._internal();

  static ServiceRafraichissementHistorique get instance => _instance;

  Timer? _timer;

  void demarrer(BuildContext context, {int intervalle = 10}) {
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: intervalle), (_) async {
      try {
        final ctl = Provider.of<ControleurHistorique>(context, listen: false);
        await ctl.chargerHistoriqueSilencieusement(); // 👈 cette méthode doit exister dans ton controleur
      } catch (e) {
        debugPrint("Erreur de rafraîchissement historique : $e");
      }
    });
  }

  void arreter() {
    _timer?.cancel();
  }
}
