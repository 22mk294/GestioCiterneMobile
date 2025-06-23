import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modeles/utilisateur.dart';

// Service pour l'authentification via une API HTTP
class ServiceAuthHTTP {
  final String _url = 'http://smartwatersystem.atwebpages.com/api/auth.php'; // URL de l'API

  // Méthode pour se connecter avec apiKey, mot de passe et téléphone
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
          return Utilisateur.fromJson(data['user']); // Retourne l'utilisateur si succès
        }
      } else {
        print('Erreur API : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur connexion : $e');
    }
    return null; // Retourne null en cas d'échec
  }
}

