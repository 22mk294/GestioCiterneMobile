import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/service_connectivite.dart';
import '../composants/barre_navigation_inferieure.dart';
import 'ecran_erreur_connexion.dart';
import '../../controleurs/controleur_historique.dart';
import '../../modeles/modele_historique.dart';
import 'ecran_erreur_connexion.dart';

class EcranHistorique extends StatelessWidget {
  const EcranHistorique({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceConnectivite>(
      builder: (context, serviceConnectivite, child) {
        if (!serviceConnectivite.estConnecte) {
          return  EcranErreurConnexion();
        }

        return ChangeNotifierProvider(
          create: (_) => ControleurHistorique()..chargerHistorique(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Historique'),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              foregroundColor: Colors.black,
            ),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          itemCount: controleur.historique.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            EntreeHistorique entree = controleur.historique[index];
                            return _buildLigneConsommation(
                              "${entree.date.day} ${_mois(entree.date.month)} ${entree.date.year}",
                              "${entree.consommation} lit",
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "\$${controleur.coutTotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            bottomNavigationBar: const BarreNavigationInferieure(indexActif: 2),


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

  String _mois(int mois) {
    const nomsMois = [
      "JAN.", "FÉV.", "MARS", "AVR.", "MAI", "JUIN",
      "JUIL.", "AOÛT", "SEPT.", "OCT.", "NOV.", "DÉC."
    ];
    return nomsMois[mois - 1];
  }
}
