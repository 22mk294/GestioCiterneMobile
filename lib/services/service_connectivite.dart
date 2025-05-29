import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ServiceConnectivite extends ChangeNotifier {
  bool _enLigne = true;
  late StreamSubscription _subscription;

  bool get estConnecte => _enLigne;

  ServiceConnectivite() {
    _verifierInitial();
    _subscription = Connectivity().onConnectivityChanged.listen(_mettreAJourEtat);
  }

  void _verifierInitial() async {
    final resultat = await Connectivity().checkConnectivity();
    _mettreAJourEtat(resultat);
  }

  void _mettreAJourEtat(ConnectivityResult result) {
    final connecte = result != ConnectivityResult.none;
    if (connecte != _enLigne) {
      _enLigne = connecte;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
