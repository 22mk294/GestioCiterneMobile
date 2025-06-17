import 'package:shared_preferences/shared_preferences.dart';

class ServiceSession {
  static const String cleApi = 'api_key';

  static Future<void> enregistrerSession(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(cleApi, apiKey);
  }

  static Future<String?> obtenirApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(cleApi);
  }

  static Future<void> supprimerSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cleApi);
  }

  static Future<bool> estConnecte() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(cleApi);
  }
}
