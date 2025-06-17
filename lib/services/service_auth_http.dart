import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modeles/utilisateur.dart';

class ServiceAuthHTTP {
  final String _url = 'http://smartwatersystem.atwebpages.com/api/auth.php';

  Future<Utilisateur?> seConnecter({
    required String apiKey,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'api_key': apiKey,
          'password': password,
          'phone': phone,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return Utilisateur.fromJson(data['user']);
        }
      } else {
        print('Erreur API : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur connexion : $e');
    }
    return null;
  }
}
