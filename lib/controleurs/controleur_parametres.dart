// lib/controleurs/controleur_parametres.dart
import 'package:flutter/material.dart';
import '../modeles/modele_parametres.dart';
import '../services/service_parametre.dart';

/*
cette classe herite de ChangeNotifier pour notifier les vues
des changements dans les paramètres de la citerne.
 */
class ControleurParametres extends ChangeNotifier {

  //cree une instance du service pour communiquer avec l'API
  final ServiceParametresHttp _service = ServiceParametresHttp();
  // Variable pour stocker les paramètres de la citerne
  ParametresCiterne? parametres;

  /*
  appelle le service pour recuperer les paramètres de la citerne
  stocke les donnée dans la variable parametres
  notifie le widgets qui ecoute ce controleur
   */
  Future<void> chargerParametres() async {
    parametres = await _service.getParametres();
    notifyListeners();
  }

  /*
  utilise le service pour faire un Post
  met à jour les paramètres de la citerne
  notifie les vues qui écoutent ce controleur
   */
  Future<void> mettreAJour(ParametresCiterne nouveauxParametres) async {
    await _service.mettreAJourParametres(nouveauxParametres);
    parametres = nouveauxParametres;
    notifyListeners();
  }
}
