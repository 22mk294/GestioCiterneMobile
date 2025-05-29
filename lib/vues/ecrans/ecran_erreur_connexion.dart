import 'package:flutter/material.dart';

class EcranErreurConnexion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, color: Colors.red, size: 100),
              const SizedBox(height: 20),
              const Text(
                "Connexion Internet requise",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Veuillez activer vos données mobiles ou le Wi-Fi pour continuer.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Redémarre l’app (forcé)
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: const Text("Réessayer"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
