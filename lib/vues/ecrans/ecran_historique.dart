// =============================
// ecrans/ecran_historique.dart  — export CSV + PDF
// =============================

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../services/service_connectivite.dart';
import '../composants/barre_navigation_inferieure.dart';
import '../composants/barre_superieure.dart';
import '../../controleurs/controleur_historique.dart';
import '../../modeles/modele_historique.dart';

class EcranHistorique extends StatelessWidget {
  const EcranHistorique({super.key});

  Future<File> _writeTemp(String name, String content) async {
    try {
      final dir = await getTemporaryDirectory();
      return File('${dir.path}/$name').writeAsString(content, encoding: utf8);
    } catch (_) {
      final dir = Directory.systemTemp;
      return File('${dir.path}/$name').writeAsString(content, encoding: utf8);
    }
  }

  Future<void> _exportCSV(BuildContext ctx, ControleurHistorique ctl) async {
    final csv = ctl.generateCSV();
    final file = await _writeTemp('historique_${DateTime.now().millisecondsSinceEpoch}.csv', csv);
    await Share.shareXFiles([XFile(file.path)], text: 'Historique de consommation');
  }

  Future<void> _exportPDF(BuildContext ctx, ControleurHistorique ctl) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        build: (pw.Context _) {
          return pw.Table.fromTextArray(
            headers: ['Date', 'Consommation (L)', 'Revenu (FC)'],
            data: ctl.historique
                .map((e) => [
              '${e.date.day}/${e.date.month}/${e.date.year}',
              e.consommation.toString(),
              e.revenu.toStringAsFixed(0)
            ])
                .toList(),
          );
        },
      ),
    );
    final bytes = await doc.save();
    final file = await _writeTemp('historique_${DateTime.now().millisecondsSinceEpoch}.pdf', '');
    await file.writeAsBytes(bytes, flush: true);
    await Share.shareXFiles([XFile(file.path)], text: 'Historique de consommation');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceConnectivite>(
      builder: (context, net, _) {
        if (!net.estConnecte) {
          return const Center(child: Text('Pas de connexion Internet'));
        }

        return ChangeNotifierProvider(
          create: (_) => ControleurHistorique()..chargerHistorique(jours: 7),
          child: Scaffold(
            appBar: BarreSuperieure(
              titre: 'Historique',
              actions: [
                Consumer<ControleurHistorique>(
                  builder: (ctx, ctl, __) => PopupMenuButton<String>(
                    icon: const Icon(Icons.share),
                    onSelected: (val) async {
                      if (val == 'csv') await _exportCSV(ctx, ctl);
                      if (val == 'pdf') await _exportPDF(ctx, ctl);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'csv', child: Text('Exporter CSV')),
                      PopupMenuItem(value: 'pdf', child: Text('Exporter PDF')),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFF4F8FC),
            body: const _CorpsHistorique(),
            bottomNavigationBar: const BarreNavigationInferieure(indexActif: 2),
          ),
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
          if (ctl.historique.isEmpty) {
            return const Center(child: Text('Aucune donnée disponible.'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(scrollDirection: Axis.horizontal, child: _Filtres(ctl: ctl)),
              const SizedBox(height: 12),
              _Graphique(consommations: ctl.historique),
              const SizedBox(height: 18),
              const Text('Détails par jour', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Expanded(child: _ListeDetaillee(ctl: ctl)),
              const SizedBox(height: 8),
              _CartesStats(ctl: ctl),
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
            backgroundColor: actif ? Colors.blue : Colors.grey[300],
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
        BarChartGroupData(x: i, barRods: [BarChartRodData(toY: consommations[i].consommation.toDouble(), width: 12, color: Colors.blue)]),
      );
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: BarChart(BarChartData(
        barGroups: bars,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                if (v.toInt() >= consommations.length) return const SizedBox.shrink();
                final d = consommations[v.toInt()].date;
                return Text('${d.day}/${d.month}', style: const TextStyle(fontSize: 9));
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      )),
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
        final d = '${e.date.day.toString().padLeft(2, '0')}/${e.date.month.toString().padLeft(2, '0')}/${e.date.year}';
        final varPct = ctl.variationPour(i);
        final varText = varPct.isNaN ? '' : ' (${varPct >= 0 ? '+' : ''}${varPct.toStringAsFixed(1)}%)';
        return Row(
          children: [
            Expanded(flex: 2, child: Text(d, style: const TextStyle(fontSize: 13))),
            Expanded(flex: 2, child: Text('${e.consommation} L', style: const TextStyle(fontSize: 13))),
            Expanded(flex: 2, child: Text('${e.revenu.toStringAsFixed(0)} FC', style: const TextStyle(fontSize: 13))),
            Expanded(flex: 2, child: Text(varText, style: TextStyle(fontSize: 12, color: varPct.isNaN ? Colors.grey : (varPct >= 0 ? Colors.green : Colors.red)))),
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
