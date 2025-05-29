import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../composants/barre_navigation_inferieure.dart';
import '../../controleurs/controleur_accueil.dart';
import '../../services/service_connectivite.dart';
import '../../gestion_routes.dart';
import 'dart:math';

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

      final controleur = Provider.of<ControleurAccueil>(context, listen: false);
      controleur.chargerDonnees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceConnectivite>(
      builder: (context, connectivite, child) {
        if (!connectivite.estConnecte) {
          // Si la connexion est perdue, redirige immédiatement
          Future.microtask(() =>
              Navigator.pushReplacementNamed(context, GestionRoutes.erreurConnexion));
          return const SizedBox.shrink(); // Évite un build inutile
        }

        return Consumer<ControleurAccueil>(
          builder: (context, controleur, child) {
            final donnees = controleur.donnees;

            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Accueil",
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: const Color(0XFFECEBF9),
                centerTitle: true,
                elevation: 0,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 18),

                    /// Cercle de niveau d'eau
                    SizedBox(
                      height: 220,
                      width: 220,
                      child: CustomPaint(
                        painter: CercleEauPainter(
                          pourcentage: donnees?.pourcentageEau ?? 0.0,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${((donnees?.pourcentageEau ?? 0.0) * 100).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(donnees?.niveauEau ?? 0.0).toStringAsFixed(1)} L / ${(donnees?.capacite ?? 1.0).toStringAsFixed(1)} L',
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
                    ),
                    const SizedBox(height: 18),

                    /// Bouton "Arrêter"
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: donnees == null ? null : () => controleur.arreterPompe(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: Colors.indigo,
                        ),
                        child: const Text("Arrêter", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 18),

                    /// Bouton "Réactiver les robinets"
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: donnees == null ? null : () => controleur.ouvrirVanne(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text("Réactiver les robinets"),
                      ),
                    ),
                    const SizedBox(height: 18),

                    /// POMPE + ALERTES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoBlocAvecIconeInline("POMPE", donnees?.pompe),
                        _infoBloc("ALERTES", donnees?.alerte ?? "Aucune"),
                      ],
                    ),
                    const SizedBox(height: 10),

                    /// ROBINET seul (aligné à gauche)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _infoBlocAvecIconeInline("ROBINET", donnees?.vanne),
                    ),
                    const SizedBox(height: 20),

                    /// CONSO + REVENU
                    _infoLigne(
                      "CONSOMMATION",
                      '${((donnees?.capacite ?? 1.0) * 1000).toInt()} L',
                      "REVENU",
                      '${((donnees?.capacite ?? 1.0) * 50).toStringAsFixed(2)} F',
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

  Widget _infoLigne(String gaucheTitre, String gaucheValeur, String droiteTitre, String droiteValeur) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoBloc(gaucheTitre, gaucheValeur),
        _infoBloc(droiteTitre, droiteValeur),
      ],
    );
  }

  Widget _infoBloc(String titre, String valeur) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titre.isNotEmpty)
          Text(titre, style: const TextStyle(color: Colors.grey)),
        if (titre.isNotEmpty) const SizedBox(height: 4),
        Text(valeur, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

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
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  Icons.circle,
                  size: 14,
                  color: isActif ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Painter du cercle avec couleur dynamique
class CercleEauPainter extends CustomPainter {
  final double pourcentage;

  CercleEauPainter({required this.pourcentage});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 18.0;
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final foregroundPaint = Paint()
      ..color = _getCouleurPourcentage(pourcentage)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    final angle = 2 * pi * pourcentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
      foregroundPaint,
    );
  }

  Color _getCouleurPourcentage(double p) {
    if (p < 0.2) return Colors.red;
    if (p < 0.5) return Colors.orangeAccent;
    return Colors.green;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
