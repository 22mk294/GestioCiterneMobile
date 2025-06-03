import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/service_connectivite.dart';
import '../../controleurs/controleur_alertes.dart';
import '../../modeles/modele_alerte.dart';
import '../composants/barre_navigation_inferieure.dart';
import '../../gestion_routes.dart';

class EcranAlertes extends StatefulWidget {
  const EcranAlertes({super.key});

  @override
  State<EcranAlertes> createState() => _EcranAlertesState();
}

class _EcranAlertesState extends State<EcranAlertes> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final connectivite = Provider.of<ServiceConnectivite>(context, listen: false);
      if (!connectivite.estConnecte) {
        Navigator.pushReplacementNamed(context, GestionRoutes.erreurConnexion);
        return;
      }

      final controleur = Provider.of<ControleurAlertes>(context, listen: false);
      controleur.chargerAlertes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceConnectivite>(
      builder: (context, connectivite, _) {
        if (!connectivite.estConnecte) {
          Future.microtask(() =>
              Navigator.pushReplacementNamed(context, GestionRoutes.erreurConnexion));
          return const SizedBox.shrink();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Alertes'),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
          ),
          backgroundColor: const Color(0xFFF4F8FC),
          body: Consumer<ControleurAlertes>(
            builder: (context, controleur, _) {
              if (controleur.chargement) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controleur.erreur != null) {
                return Center(child: Text('Erreur : ${controleur.erreur}'));
              }

              if (controleur.alertes.isEmpty) {
                return const Center(child: Text("Aucune alerte disponible."));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: controleur.alertes.length,
                itemBuilder: (context, index) {
                  final alerte = controleur.alertes[index];
                  return _carteAlerte(alerte);
                },
              );
            },
          ),
          bottomNavigationBar: BarreNavigationInferieure(indexActif: 3),
        );
      },
    );
  }

  Widget _carteAlerte(Alerte alerte) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      child: ListTile(
        leading: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
        title: Text(
          alerte.message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Type : ${alerte.type}\n${alerte.timestamp.toLocal().toString().substring(0, 16)}',
          style: const TextStyle(fontSize: 13),
        ),
        isThreeLine: true,
      ),
    );
  }
}
