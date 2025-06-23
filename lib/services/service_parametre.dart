// lib/services/service_parametre.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modeles/modele_parametres.dart';

class ServiceParametresHttp {
  final String _baseUrl = 'http://smartwatersystem.atwebpages.com/api';

  /// Récupère les paramètres de la citerne depuis l'API.
  Future<ParametresCiterne> getParametres() async {
    final uri =
    Uri.parse('$_baseUrl/get_settings.php?tank_id=1&api_key=1ac34bd67sw');

    // Effectue une requête GET pour récupérer les paramètres
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return ParametresCiterne.fromJson(jsonData);
    } else {
      throw Exception('Erreur lors du chargement des paramètres');
    }
  }

  /// Met à jour les paramètres de la citerne via l'API.
  Future<void> mettreAJourParametres(ParametresCiterne parametres) async {
    final uri = Uri.parse('$_baseUrl/save_settings.php');

   // Effectue une requête POST pour mettre à jour les paramètres
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parametres.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur de mise à jour des paramètres');
    }
  }
}
