import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../composants/barre_navigation_inferieure.dart';
import '../../controleurs/controleur_accueil.dart';
import '../../services/service_connectivite.dart';
import '../../services/service_etat_eau.dart';
import '../../gestion_routes.dart';
import '../composants/cercle_eau.dart';
import '../../utils/utils_affichage.dart';
import '../../modeles/modele_donnees.dart';

class EcranAccueil extends StatefulWidget {
  const EcranAccueil({super.key});

  @override
  State<EcranAccueil> createState() => _EcranAccueilState();
}

class _EcranAccueilState extends State<EcranAccueil> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final connectivite = Provider.of<ServiceConnectivite>(context, listen: false);
      if (!connectivite.estConnecte) {
        Navigator.pushReplacementNamed(context, GestionRoutes.erreurConnexion);
      } else {
        Provider.of<ControleurAccueil>(context, listen: false).chargerDonnees(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ServiceConnectivite, ServiceEtatEau, ControleurAccueil>(
      builder: (context, connectivite, etatEau, controleur, _) {
        if (!connectivite.estConnecte) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, GestionRoutes.erreurConnexion);
          });
          return const SizedBox.shrink();
        }

        final donnees = etatEau.donnees ?? controleur.donnees;

        if (controleur.chargement || donnees == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final pourcentage = donnees.pourcentageEau;
        final niveau = donnees.niveauEau;
        final capacite = donnees.capacite;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Accueil'),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
          ),
          backgroundColor: const Color(0xFFF4F8FC),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
            child: Column(
              children: [
                _buildCercleEau(pourcentage, niveau, capacite),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Contrôles du système",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                _buildCartesCommandes(donnees, controleur),
              ],
            ),
          ),
          bottomNavigationBar: BarreNavigationInferieure(indexActif: 0),
        );
      },
    );
  }

  Widget _buildCercleEau(double pourcentage, double niveau, double capacite) {
    return SizedBox(
      height: 200,
      width: 200,
      child: CustomPaint(
        painter: CercleEauPainter(pourcentage: pourcentage),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(pourcentage * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: getCouleurPourcentage(pourcentage),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${niveau.toStringAsFixed(1)} L / ${capacite.toStringAsFixed(1)} L',
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              ),
              const SizedBox(height: 4),
              const Text(
                'NIVEAU ACTUEL',
                style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartesCommandes(DonneesCiterne donnees, ControleurAccueil controleur) {
    final consommation = (donnees.capacite * 1000).toInt(); // litres
    final revenu = (donnees.capacite * 50).toStringAsFixed(2); // FCFA

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _carteCommande(
          titre: "Pompe",
          icone: Icons.water,
          actif: donnees.pompe.toUpperCase() == "ON",
          onChanged: (val) async {
            try {
              await controleur.reglerPompe(context, val);

            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Erreur : ${e.toString()}")),
              );
            }
          },
        ),
        _carteCommande(
          titre: "Robinet",
          icone: Icons.water_drop,
          actif: donnees.vanne.toUpperCase() == "OPEN",
          onChanged: (val) async {
            try {
              await controleur.reglerVanne(context, val);


            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Erreur : ${e.toString()}")),
              );
            }
          },
        ),
        _carteStatique(
          titre: "Consommation",
          icone: Icons.local_drink,
          valeur: "$consommation L",
        ),
        _carteStatique(
          titre: "Revenu",
          icone: Icons.attach_money,
          valeur: "$revenu Fc",
        ),
      ],
    );
  }

  Widget _carteCommande({
    required String titre,
    required IconData icone,
    required bool actif,
    required Function(bool) onChanged,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 30, color: actif ? Colors.blue : Colors.red),
            const SizedBox(height: 8),
            Text(titre, style: const TextStyle(fontWeight: FontWeight.bold)),
            Switch(
              value: actif,
              onChanged: onChanged,
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _carteStatique({
    required String titre,
    required IconData icone,
    required String valeur,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(titre, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(valeur, style: const TextStyle(fontSize: 14), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
