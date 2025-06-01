import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../composants/barre_navigation_inferieure.dart';
import '../../controleurs/controleur_accueil.dart';
import '../../services/service_connectivite.dart';
import '../../gestion_routes.dart';
import '../composants/cercle_eau.dart';
import '../../utils/utils_affichage.dart';

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
        return;
      }

      Provider.of<ControleurAccueil>(context, listen: false)
          .demarrerRafraichissement(context);
    });
  }

  @override
  void dispose() {
    Provider.of<ControleurAccueil>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceConnectivite>(
      builder: (context, connectivite, _) {
        if (!connectivite.estConnecte) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, GestionRoutes.erreurConnexion);
          });
          return const SizedBox.shrink();
        }

        return Consumer<ControleurAccueil>(
          builder: (context, controleur, _) {
            final donnees = controleur.donnees;

            if (donnees == null) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final pourcentage = donnees.pourcentageEau;
            final niveau = donnees.niveauEau;
            final capacite = donnees.capacite;

            return Scaffold(
              appBar: AppBar(
                title: const Text("Accueil", style: TextStyle(color: Colors.black)),
                backgroundColor: const Color(0xFFECEBF9),
                centerTitle: true,
                elevation: 0,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    _buildCercleEau(pourcentage, niveau, capacite),
                    const SizedBox(height: 18),
                    _buildBoutonsCommande(controleur, pourcentage),
                    const SizedBox(height: 18),
                    _buildInfosStatuts(donnees),
                    const SizedBox(height: 20),
                    _infoLigne(
                      "CONSOMMATION",
                      '${(capacite * 1000).toInt()} L',
                      "REVENU",
                      '${(capacite * 50).toStringAsFixed(2)} F CFA',
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: const BarreNavigationInferieure(indexActif: 0),
            );
          },
        );
      },
    );
  }

  /// Affiche le cercle représentant le niveau d'eau
  Widget _buildCercleEau(double pourcentage, double niveau, double capacite) {
    return SizedBox(
      height: 220,
      width: 220,
      child: CustomPaint(
        painter: CercleEauPainter(pourcentage: pourcentage),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(pourcentage * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: getCouleurPourcentage(pourcentage),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${niveau.toStringAsFixed(1)} L sur ${capacite.toStringAsFixed(1)} L',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              const Text(
                'NIVEAU ACTUEL',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Affiche les boutons de contrôle (pompe, vanne)
  Widget _buildBoutonsCommande(ControleurAccueil controleur, double pourcentage) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => controleur.reglerPompe(context, false),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              backgroundColor: getCouleurPourcentage(pourcentage),
            ),
            child: const Text("Arrêter", style: TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => controleur.reglerVanne(context, true),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: const Text("Réactiver les robinets"),
          ),
        ),
      ],
    );
  }

  /// Affiche les informations de statut (pompe, robinet, alertes)
  Widget _buildInfosStatuts(donnees) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _infoBlocAvecIconeInline("POMPE", donnees.pompe),
            _infoBloc("ALERTES", donnees.alerte ?? "Aucune"),
          ],
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: _infoBlocAvecIconeInline("ROBINET", donnees.vanne),
        ),
      ],
    );
  }

  /// Affiche une ligne avec deux blocs : gauche et droite
  Widget _infoLigne(String gaucheTitre, String gaucheValeur, String droiteTitre, String droiteValeur) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoBloc(gaucheTitre, gaucheValeur),
        _infoBloc(droiteTitre, droiteValeur),
      ],
    );
  }

  /// Bloc simple (titre + valeur)
  Widget _infoBloc(String titre, String valeur) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titre, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(valeur, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  /// Bloc avec une icône de statut (ON/OFF)
  Widget _infoBlocAvecIconeInline(String titre, String? statut) {
    final isActif = statut != null &&
        (statut.toUpperCase() == 'ON' || statut.toUpperCase() == 'OPEN');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$titre ',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  Icons.circle,
                  size: 14,
                  color: isActif ? const Color(0XFF0D9C03) : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
