import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/service_connectivite.dart';
import '../composants/barre_navigation_inferieure.dart';
import '../composants/barre_superieure.dart';
import 'ecran_erreur_connexion.dart';
import '../../controleurs/controleur_historique.dart';
import '../../modeles/modele_historique.dart';

class EcranHistorique extends StatelessWidget {
  const EcranHistorique({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceConnectivite>(
      builder: (context, serviceConnectivite, child) {
        if (!serviceConnectivite.estConnecte) {
          return EcranErreurConnexion();
        }

        return ChangeNotifierProvider(
          create: (_) => ControleurHistorique()..chargerHistorique(jours: 7),
          child: Scaffold(
            appBar: const BarreSuperieure(titre: 'Historique'),
            backgroundColor: const Color(0xFFF4F8FC),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<ControleurHistorique>(
                builder: (context, controleur, child) {
                  if (controleur.chargement) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controleur.historique.isEmpty) {
                    return const Center(child: Text("Aucune donnée disponible."));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CONSOMMATION JOURNALIÈRE',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      _buildFiltreHistorique(context, controleur),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.separated(
                          itemCount: controleur.historique.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            EntreeHistorique entree = controleur.historique[index];
                            return _buildLigneConsommation(
                              "${entree.date.day} ${_mois(entree.date.month)} ${entree.date.year}",
                              "${entree.consommation} L",
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "${controleur.coutTotal.toStringAsFixed(2)} FC",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
            ),
            bottomNavigationBar: BarreNavigationInferieure(indexActif: 2),
          ),
        );
      },
    );
  }

  Widget _buildLigneConsommation(String date, String valeur) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(date, style: const TextStyle(fontSize: 16)),
        Text(valeur, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildFiltreHistorique(BuildContext context, ControleurHistorique controleur) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _boutonFiltre(context, controleur, "7 jours", 7),
        _boutonFiltre(context, controleur, "30 jours", 30),
        _boutonFiltre(context, controleur, "1 mois", 31),
      ],
    );
  }

  Widget _boutonFiltre(BuildContext context, ControleurHistorique controleur, String label, int jours) {
    final bool estActif = controleur.jours == jours;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: estActif ? Colors.blue : Colors.grey[300],
        foregroundColor: estActif ? Colors.white : Colors.black,
      ),
      onPressed: () {
        controleur.chargerHistorique(jours: jours);
      },
      child: Text(label),
    );
  }

  String _mois(int mois) {
    const nomsMois = [
      "JAN.", "FÉV.", "MARS", "AVR.", "MAI", "JUIN",
      "JUIL.", "AOÛT", "SEPT.", "OCT.", "NOV.", "DÉC."
    ];
    return nomsMois[mois - 1];
  }
}
