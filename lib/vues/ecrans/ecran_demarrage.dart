import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../gestion_routes.dart';
import '../../services/service_session.dart';

class EcranDemarrage extends StatefulWidget {
  @override
  _EcranDemarrageState createState() => _EcranDemarrageState();
}

class _EcranDemarrageState extends State<EcranDemarrage> {
  @override
  void initState() {
    super.initState();
    _verifierConnexionEtSession();
  }

  Future<void> _verifierConnexionEtSession() async {
    final result = await Connectivity().checkConnectivity();
    final actif = result != ConnectivityResult.none;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (!actif) {
      Navigator.pushReplacementNamed(context, GestionRoutes.erreurConnexion);
      return;
    }

    final estConnecte = await ServiceSession.estConnecte();

    Navigator.pushReplacementNamed(
      context,
      estConnecte ? GestionRoutes.accueil : GestionRoutes.connexion,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/logoo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 18),
            const Text(
              "Traitement...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
