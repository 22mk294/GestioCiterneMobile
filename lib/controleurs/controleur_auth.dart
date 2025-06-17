import '../modeles/utilisateur.dart';
import '../services/service_auth_http.dart';
import '../services/service_session.dart';

class ControleurAuth {
  final ServiceAuthHTTP _service = ServiceAuthHTTP();
  final String _apiKey = '1ac34bd67sw'; // fixe ici

  Future<Utilisateur?> tenterConnexion({
    required String phone,
    required String password,
  }) async {
    final utilisateur = await _service.seConnecter(
      phone: phone,
      password: password,
      apiKey: _apiKey,
    );

    if (utilisateur != null) {
      await ServiceSession.enregistrerSession(_apiKey);
    }

    return utilisateur;
  }
}
