import 'package:flutter/material.dart';
import '../../gestion_routes.dart';
import 'dart:async';

class EcranDemarrage extends StatefulWidget {
  @override
  _EcranDemarrageState createState() => _EcranDemarrageState();
}

class _EcranDemarrageState extends State<EcranDemarrage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacementNamed(context, GestionRoutes.accueil);
    });
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
            SizedBox(height: 18),
            Text(
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
