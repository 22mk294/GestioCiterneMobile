import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../modeles/modele_donnees.dart';

class ServiceESP32Http {
  final String _baseUrl = "http://smartwatersystem.atwebpages.com/api";
  final String _tankId = "1";
  final String _apiKey = "1ac34bd67sw";

  Future<DonneesCiterne> getInfosCiterne() async {
    final uri = Uri.parse("$_baseUrl/get_data.php?tank_id=$_tankId&api_key=$_apiKey");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains("application/json")) {
        final jsonData = jsonDecode(response.body);
        return DonneesCiterne.fromJson(jsonData);
      } else {
        print("⚠️ Réponse inattendue (non-JSON) : ${response.body}");
        throw FormatException("La réponse n'est pas au format JSON");
      }
    } else {
      throw Exception("Échec de récupération des données : ${response.statusCode}");
    }
  }

  Future<void> envoyerCommande(String action, String valeur) async {
    final uri = Uri.parse("$_baseUrl/send_command.php");

    final response = await http.post(uri, body: {
      'tank_id': _tankId,
      'api_key': _apiKey,
      'action': action,
      'value': valeur,
    });

    if (response.statusCode != 200) {
      throw Exception("Échec de la commande : $action -> $valeur (${response.statusCode})");
    }
  }

  Future<bool> envoyerCommandeControle({
    required String pumpState,
    required String valveState,
    required String buzzerState,
  }) async {
    final uri = Uri.parse("$_baseUrl/save_control.php");

    final corps = jsonEncode({
      "tank_id": int.parse(_tankId),
      "api_key": _apiKey,
      "pump_state": pumpState,
      "valve_state": valveState,
      "buzzer_state": buzzerState,
    });

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: corps,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json["success"] == true || json["status"] == "success";
      } else {
        debugPrint("Erreur API: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Exception lors de l'envoi du contrôle : $e");
      return false;
    }
  }

}
