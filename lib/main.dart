import 'package:flutter/material.dart';
import 'gestion_routes.dart';

void main() {
  runApp(MonApp());
}

class MonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Citerne',
      debugShowCheckedModeBanner: false,
      initialRoute: GestionRoutes.demarrage,
      routes: GestionRoutes.getRoutes(),
    );
  }
}
