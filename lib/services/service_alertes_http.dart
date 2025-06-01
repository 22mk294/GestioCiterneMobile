import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modeles/modele_alerte.dart';

class ServiceAlertesHttp {
  final String _url = "http://smartwatersystem.atwebpages.com/api/get_alerts.php?tank_id=1&api_key=1ac34bd67sw&limit=10";

  Future<List<Alerte>> recupererAlertes() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final List<dynamic> donnees = json.decode(response.body);
      return donnees.map((json) => Alerte.fromJson(json)).toList();
    } else {
      throw Exception("Erreur lors du chargement des alertes");
    }
  }
}
