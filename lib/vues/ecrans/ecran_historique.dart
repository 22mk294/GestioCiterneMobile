import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/export_service.dart';
import '../../services/service_connectivite.dart';
import '../../services/service_rafraichissement_historique.dart';
import '../../controleurs/controleur_historique.dart';
import '../../modeles/modele_historique.dart';
import '../composants/barre_navigation_inferieure.dart';
import '../composants/barre_superieure.dart';

class EcranHistorique extends StatefulWidget {
  const EcranHistorique({super.key});

  @override
  State<EcranHistorique> createState() => _EcranHistoriqueState();
}

class _EcranHistoriqueState extends State<EcranHistorique> {
  final exportService = ExportService();
  final _rafraichisseur = ServiceRafraichissementHistorique();

  Future<void> _export(BuildContext ctx, ControleurHistorique ctl, String format) async {
    File file = (format == 'csv')
        ? await exportService.generateCSV(ctl.historique)
        : await exportService.generatePDF(ctl.historique);
    await Share.shareXFiles([XFile(file.path)], text: 'Historique de consommation');
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctl = Provider.of<ControleurHistorique>(context, listen: false);
      ctl.chargerHistorique(jours: 7);
      _rafraichisseur.demarrer(context, intervalle: 5);
    });
  }

  @override
  void dispose() {
    _rafraichisseur.arreter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceConnectivite>(
      builder: (context, net, _) {
        if (!net.estConnecte) {
          return const Center(child: Text('Pas de connexion Internet'));
        }

        return Scaffold(
          appBar: BarreSuperieure(
            titre: 'Historique',
            actions: [
              Consumer<ControleurHistorique>(
                builder: (ctx, ctl, __) => PopupMenuButton<String>(
                  icon: const Icon(Icons.share),
                  onSelected: (val) async => _export(ctx, ctl, val),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'csv', child: Text('Exporter CSV')),
                    PopupMenuItem(value: 'pdf', child: Text('Exporter PDF')),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFCDE5FE),
          body: const _CorpsHistorique(),
          bottomNavigationBar: const BarreNavigationInferieure(indexActif: 2),
        );
      },
    );
  }
}



/* ================= CORPS PRINCIPAL ================= */
class _CorpsHistorique extends StatelessWidget {
  const _CorpsHistorique();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Consumer<ControleurHistorique>(
        builder: (context, ctl, _) {
          if (ctl.chargement) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(scrollDirection: Axis.horizontal, child: _Filtres(ctl: ctl)),
              const SizedBox(height: 12),
              if (ctl.historique.isEmpty)
                const Expanded(
                  child: Center(child: Text('Aucune donnée disponible.')),
                )
              else ...[
                _Graphique(consommations: ctl.historique),
                const SizedBox(height: 18),
                const Text('Détails par jour', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Expanded(child: _ListeDetaillee(ctl: ctl)),
                const SizedBox(height: 8),
                _CartesStats(ctl: ctl),
              ],
            ],
          );
        },
      ),
    );
  }
}

/* ================= WIDGETS SECONDAIRES ================= */
class _Filtres extends StatelessWidget {
  final ControleurHistorique ctl;
  const _Filtres({required this.ctl});

  @override
  Widget build(BuildContext context) {
    Widget bouton(String lbl, int j) {
      final actif = ctl.jours == j;
      return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: ElevatedButton(
          onPressed: () => ctl.chargerHistorique(jours: j),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            backgroundColor: actif ? Colors.blue : Colors.white,
            foregroundColor: actif ? Colors.white : Colors.black,
            textStyle: const TextStyle(fontSize: 12),
          ),
          child: Text(lbl),
        ),
      );
    }

    return Row(children: [bouton('7 j', 7), bouton('30 j', 30), bouton('1 an', 365)]);
  }
}

class _Graphique extends StatelessWidget {
  final List<EntreeHistorique> consommations;
  const _Graphique({required this.consommations});

  @override
  Widget build(BuildContext context) {
    final bars = <BarChartGroupData>[];
    for (int i = 0; i < consommations.length; i++) {
      bars.add(
        BarChartGroupData(x: i, barRods: [
          BarChartRodData(toY: consommations[i].consommation.toDouble(), width: 12, color: Colors.blue)
        ]),
      );
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        //meet moi un commentaire de fonction suivante
        //
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: BarChart(
        BarChartData(
          barGroups: bars,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) {
                  if (v.toInt() >= consommations.length) return const SizedBox.shrink();
                  final d = consommations[v.toInt()].date;
                  return Text('${d.day}/${d.month}', style: const TextStyle(fontSize: 9, color: Colors.black));
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 18, // Réduit la taille de la colonne à gauche
                getTitlesWidget: (v, _) => Text(
                  '${v.toInt()}',
                  style: const TextStyle(fontSize: 8), // Réduit la taille de la police
                ),
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}

class _ListeDetaillee extends StatelessWidget {
  final ControleurHistorique ctl;
  const _ListeDetaillee({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: ctl.historique.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, i) {
        final e = ctl.historique[i];
        final d =
            '${e.date.day.toString().padLeft(2, '0')}/${e.date.month.toString().padLeft(2, '0')}/${e.date.year}';
        final varPct = ctl.variationPour(i);
        final varText = varPct.isNaN
            ? ''
            : ' (${varPct >= 0 ? '+' : ''}${varPct.toStringAsFixed(1)}%)';
        return Row(
          children: [
            Expanded(flex: 2, child: Text(d, style: const TextStyle(fontSize: 13))),
            Expanded(flex: 2, child: Text('${e.consommation.toStringAsFixed(1)} L', style: const TextStyle(fontSize: 13))),
            Expanded(flex: 2, child: Text('${e.revenu.toStringAsFixed(0)} FC', style: const TextStyle(fontSize: 13))),
            Expanded(
              flex: 2,
              child: Text(
                varText,
                style: TextStyle(
                  fontSize: 12,
                  color: varPct.isNaN ? Colors.grey : (varPct >= 0 ? Colors.green : Colors.red),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CartesStats extends StatelessWidget {
  final ControleurHistorique ctl;
  const _CartesStats({required this.ctl});

  Widget _card(String titre, String val) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blueAccent),
        ),
        child: Column(
          children: [
            Text(val, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(titre, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _card('Moyenne', '${ctl.consommationMoy.toStringAsFixed(0)} L'),
        _card('Revenu total', '${ctl.revenuTotal.toStringAsFixed(0)} FC'),
        _card('Pic', '${ctl.picConso} L'),
      ],
    );
  }
}