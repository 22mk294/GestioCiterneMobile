import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../composants/barre_navigation_inferieure.dart';
import '../../controleurs/controleur_accueil.dart';
import '../../services/service_connectivite.dart';
import '../../services/service_etat_eau.dart';
import '../../gestion_routes.dart';
import '../composants/barre_superieure.dart';
import '../composants/cercle_eau.dart';
import '../../utils/utils_affichage.dart';
import '../../modeles/modele_donnees.dart';

// Écran principal d'accueil de l'application
class EcranAccueil extends StatefulWidget {
  const EcranAccueil({super.key});

  @override
  State<EcranAccueil> createState() => _EcranAccueilState();
}

class _EcranAccueilState extends State<EcranAccueil> {
  @override
  void initState() {
    super.initState();
    // Au démarrage, vérifie la connexion et charge les données de la citerne
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final connectivite = Provider.of<ServiceConnectivite>(context, listen: false);
      if (!connectivite.estConnecte) {
        // Redirige vers l'écran d'erreur si pas de connexion
        Navigator.pushReplacementNamed(context, GestionRoutes.erreurConnexion);
      } else {
        // Charge les données de la citerne via le contrôleur
        Provider.of<ControleurAccueil>(context, listen: false).chargerDonnees(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Utilise Consumer3 pour écouter les changements de connectivité, état de l'eau et contrôleur d'accueil
    return Consumer3<ServiceConnectivite, ServiceEtatEau, ControleurAccueil>(
      builder: (context, connectivite, etatEau, controleur, _) {
        if (!connectivite.estConnecte) {
          // Redirige vers l'écran d'erreur si pas de connexion
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, GestionRoutes.erreurConnexion);
          });
          return const SizedBox
              .shrink(); // Retourne un widget vide pendant la redirection
        }

        final donnees = etatEau.donnees ?? controleur.donnees;

        // Affiche un indicateur de chargement global uniquement au tout premier chargement
        if (controleur.chargement && (donnees == null)) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final pourcentage = donnees?.pourcentageEau;
        final niveau = donnees?.niveauEau;
        final capacite = donnees?.capacite;

        return Scaffold(
          appBar: BarreSuperieure(
            titre: 'Accueil',
            actions: [
              // Bouton pour accéder au profil utilisateur
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.pushNamed(context, GestionRoutes.profil);
                },
              ),
            ],
          ),
          backgroundColor: const Color(0xFFE3EDF7),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
            child: Column(
              children: [
                _buildCercleEau(pourcentage!, niveau!, capacite!), // Affiche le cercle d'eau
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Contrôle de la citerne",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                ),
                const SizedBox(height: 12),
                // Passe les états de chargement locaux à la méthode
                _buildCartesCommandes(
                  donnees!,
                  controleur,
                  controleur.chargementPompe ?? false,
                  controleur.chargementVanne ?? false,
                ), // Affiche les cartes de commandes/statistiques
              ],
            ),
          ),
          bottomNavigationBar: BarreNavigationInferieure(indexActif: 0), // Barre de navigation inférieure
        );
      },
    );
  }

  // Widget pour afficher le cercle d'eau avec le pourcentage et le niveau actuel
  Widget _buildCercleEau(double pourcentage, double niveau, double capacite) {
    return SizedBox(
      height: 200,
      width: 200,
      child: CustomPaint(
        painter: CercleEauPainter(pourcentage: pourcentage), // Dessine le cercle avec l'arc de niveau d'eau
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Affiche le pourcentage d'eau
              Text(
                '${(pourcentage * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: getCouleurPourcentage(pourcentage),
                ),
              ),
              const SizedBox(height: 4),
              // Affiche le niveau d'eau en litres et la capacité totale
              Text(
                '${(niveau * 3).toStringAsFixed(1)} L / ${(capacite * 1000 * 2.3077).toStringAsFixed(1)} L',
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              ),
              const SizedBox(height: 4),
              // Libellé du niveau actuel
              const Text(
                'NIVEAU ACTUEL',
                style: TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ajoute les paramètres de chargement locaux
  Widget _buildCartesCommandes(
    DonneesCiterne donnees,
    ControleurAccueil controleur,
    bool chargementPompe,
    bool chargementVanne,
  ) {
    // Formate la consommation et le revenu pour l'affichage
    final consommationAffichee = "${donnees.consommation.toStringAsFixed(0)} L";
    final revenuAffiche = "${donnees.revenu.toStringAsFixed(2)} Fc";

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        // Carte pour commander la pompe avec loader local
        _carteCommande(
          titre: "Pompe",
          icone: Icons.water,
          actif: donnees.pompe.toUpperCase() == "ON",
          onChanged: (val) => controleur.reglerPompe(context, val),
          chargement: chargementPompe,
        ),
        // Carte pour commander le robinet avec loader local
        _carteCommande(
          titre: "Robinet",
          icone: Icons.water_drop,
          actif: donnees.vanne.toUpperCase() == "OPEN",
          onChanged: (val) => controleur.reglerVanne(context, val),
          chargement: chargementVanne,
        ),
        // Carte affichant la consommation
        _carteStatique(
          titre: "Consommation",
          icone: Icons.local_drink,
          valeur: consommationAffichee,
        ),
        // Carte affichant le revenu
        _carteStatique(
          titre: "Revenu",
          icone: Icons.attach_money,
          valeur: revenuAffiche,
        ),
      ],
    );
  }

  // Carte interactive pour commander la pompe ou le robinet
  Widget _carteCommande({
    required String titre,
    required IconData icone,
    required bool actif,
    required Function(bool) onChanged,
    bool chargement = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône de la commande (pompe ou robinet)
            Icon(icone, size: 24, color: actif ? Color(0xFF26A101) : Colors.red),
            const SizedBox(height: 4),
            // Titre de la commande
            Text(titre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            // Affiche un loader local si la commande est en cours, sinon le switch
            chargement
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Switch(
                    value: actif,
                    onChanged: onChanged,
                    activeColor: Color(0xFF26A101),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
          ],
        ),
      ),
    );
  }

  // Carte statique pour afficher une statistique (consommation ou revenu)
  Widget _carteStatique({
    required String titre,
    required IconData icone,
    required String valeur,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône de la statistique
            Icon(icone, size: 22, color: Colors.blueGrey),
            const SizedBox(height: 4),
            // Titre de la statistique
            Text(titre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            // Valeur de la statistique
            Text(valeur, style: const TextStyle(fontSize: 13, color: Colors.blueGrey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}