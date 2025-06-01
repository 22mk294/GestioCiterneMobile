import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modeles/modele_parametres.dart';

class ServiceParametresHttp {
  final String _baseUrl = "http://smartwatersystem.atwebpages.com/api";
  final String _tankId = "1";
  final String _apiKey = "1ac34bd67sw";

  Future<ParametresCiterne> getParametres() async {
    final uri = Uri.parse("$_baseUrl/get_settings.php?tank_id=$_tankId&api_key=$_apiKey");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return ParametresCiterne.fromJson(jsonData);
    } else {
      throw Exception("Erreur de chargement des paramètres : ${response.statusCode}");
    }
  }

  Future<void> mettreAJourParametres(ParametresCiterne params) async {
    final uri = Uri.parse("$_baseUrl/update_settings.php");

    final response = await http.post(uri, body: {
      'tank_id': _tankId,
      'api_key': _apiKey,
      ...params.toJson(),
    });

    if (response.statusCode != 200) {
      throw Exception("Erreur de mise à jour des paramètres");
    }
  }
}
