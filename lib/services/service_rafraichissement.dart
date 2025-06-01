// lib/services/service_rafraichissement.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'service_esp32_http.dart';
import 'service_etat_eau.dart';
import '../modeles/modele_donnees.dart';

class ServiceRafraichissementDonnees {
  final ServiceESP32Http _serviceHttp = ServiceESP32Http();
  Timer? _timer;

  void demarrer(BuildContext context) {
    // Chargement initial
    _chargerDonnees(context);

    // Toutes les 5 secondes
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _chargerDonnees(context);
    });
  }

  Future<void> _chargerDonnees(BuildContext context) async {
    try {
      final nouvellesDonnees = await _serviceHttp.getInfosCiterne();

      // Mettre à jour le provider global avec les nouvelles données
      Provider.of<ServiceEtatEau>(context, listen: false)
          .mettreAJourDonnees(nouvellesDonnees);
    } catch (e) {
      debugPrint("Erreur de mise à jour automatique : $e");
    }
  }

  void arreter() {
    _timer?.cancel();
  }
}
