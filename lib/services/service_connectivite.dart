import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

// Service qui gère l'état de la connectivité réseau
class ServiceConnectivite extends ChangeNotifier {
  bool _enLigne = true; // État de la connexion
  late StreamSubscription _subscription; // Abonnement au flux de connectivité

  bool get estConnecte => _enLigne; // Getter pour l'état de connexion

  ServiceConnectivite() {
    _verifierInitial(); // Vérifie l'état initial
    _subscription = Connectivity().onConnectivityChanged.listen(_mettreAJourEtat); // Écoute les changements
  }

  // Vérifie l'état de connexion au démarrage
  void _verifierInitial() async {
    final resultat = await Connectivity().checkConnectivity();
    _mettreAJourEtat(resultat);
  }

  // Met à jour l'état de connexion et notifie les listeners si changement
  void _mettreAJourEtat(ConnectivityResult result) {
    final connecte = result != ConnectivityResult.none;
    if (connecte != _enLigne) {
      _enLigne = connecte;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel(); // Annule l'abonnement lors de la destruction
    super.dispose();
  }
}

