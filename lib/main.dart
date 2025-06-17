import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importation des contrôleurs
import 'controleurs/controleur_accueil.dart';
import 'controleurs/controleur_alertes.dart';
import 'controleurs/controleur_parametres.dart';

// Importation des services
import 'services/service_connectivite.dart';
import 'services/service_etat_eau.dart';
import 'services/service_rafraichissement.dart';
import 'gestion_routes.dart';

void main() {
  // Point d'entrée de l'application : configuration des providers globaux
  runApp(
    MultiProvider(
      providers: [
        // Fournit un ControleurAccueil à tout le widget tree
        ChangeNotifierProvider(create: (_) => ControleurAccueil()),
        // Fournit un ControleurParametres pour gérer les paramètres
        ChangeNotifierProvider(create: (_) => ControleurParametres()),
        // Fournit le service de connectivité (état réseau)
        ChangeNotifierProvider(create: (_) => ServiceConnectivite()),
        // Fournit le service d'état d'eau (niveau d'eau, etc.)
        ChangeNotifierProvider(create: (_) => ServiceEtatEau()),
        // Service de rafraîchissement des données (pas besoin de notifier)
        Provider(create: (_) => ServiceRafraichissementDonnees()),
        // Fournit le contrôleur d'alertes (notifications, alertes)
        ChangeNotifierProvider(create: (_) => ControleurAlertes()),
      ],
      child: const MyApp(),
    ),
  );
}

// Widget racine de l'application
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialise = false; // Pour s'assurer que l'init ne se fait qu'une fois

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Démarre le service de rafraîchissement une seule fois si connecté
    if (!_initialise) {
      final connectivite = Provider.of<ServiceConnectivite>(context, listen: false);
      if (connectivite.estConnecte) {
        final serviceRafraichissement =
            Provider.of<ServiceRafraichissementDonnees>(context, listen: false);
        serviceRafraichissement.demarrer(context);
      }
      _initialise = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Utilise le Consumer pour reconstruire l'application en fonction de la connectivité
    return Consumer<ServiceConnectivite>(
      builder: (context, connectivite, child) {
        return MaterialApp(
          title: 'Gestion Citerne',
          debugShowCheckedModeBanner: false,
          // Choisit la route initiale selon l'état de la connexion
          initialRoute: connectivite.estConnecte
              ? GestionRoutes.demarrage
              : GestionRoutes.erreurConnexion,
          // Définit les routes de l'application
          routes: GestionRoutes.getRoutes(),
        );
      },
    );
  }
}
