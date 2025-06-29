import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modeles/modele_historique.dart';

class ServiceHistorique {
  Future<List<EntreeHistorique>> recupererHistorique(int jours) async {
    final url =
        'http://smartwatersystem.atwebpages.com/api/get_history.php?tank_id=1&api_key=1ac34bd67sw&days=$jours';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonListe = jsonDecode(response.body);
      return jsonListe
          .map((json) => EntreeHistorique.fromJson(json))
          .toList();
    } else {
      throw Exception('Échec de récupération de l’historique');
    }
  }
}
