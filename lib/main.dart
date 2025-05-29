// Importation du package Flutter pour l'interface utilisateur.


import 'services/service_connectivite.dart';
import 'gestion_routes.dart';

import 'gestion_routes.dart'; // Ton fichier de routes
// Importation du fichier de gestion des routes personnalisé.
import 'gestion_routes.dart';



// Point d'entrée de l'application.
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ControleurAccueil()),
        ChangeNotifierProvider(create: (_) => ServiceConnectivite()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceConnectivite>(
      builder: (context, connectivite, child) {
        return MaterialApp(
          title: 'Gestion Citerne',
          debugShowCheckedModeBanner: false,
          initialRoute: connectivite.estConnecte
              ? GestionRoutes.demarrage
              : GestionRoutes.erreurConnexion,
          routes: GestionRoutes.getRoutes(),
        );
      },



// Définition du widget principal de l'application.

