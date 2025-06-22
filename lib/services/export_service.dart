import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import '../modeles/modele_historique.dart';

class ExportService {
  Future<File> _writeTemp(String name, String content) async {
    try {
      final dir = await getTemporaryDirectory();
      return File('${dir.path}/$name').writeAsString(content, encoding: utf8);
    } catch (_) {
      final dir = Directory.systemTemp;
      return File('${dir.path}/$name').writeAsString(content, encoding: utf8);
    }
  }

  Future<File> generateCSV(List<EntreeHistorique> historique) async {
    final buffer = StringBuffer('Date,Consommation (L),Revenu (FC)\n');
    for (final e in historique) {
      buffer.writeln('${e.date.toIso8601String().split('T').first},${e.consommation.toStringAsFixed(0)},${e.revenu.toStringAsFixed(0)}');
    }
    return _writeTemp('historique_${DateTime.now().millisecondsSinceEpoch}.csv', buffer.toString());
  }

  Future<File> generatePDF(List<EntreeHistorique> historique) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        build: (_) => pw.Table.fromTextArray(
          headers: ['Date', 'Consommation (L)', 'Revenu (FC)'],
          data: historique
              .map((e) => [
            '${e.date.day}/${e.date.month}/${e.date.year}',
            e.consommation.toString(),
            e.revenu.toStringAsFixed(0)
          ])
              .toList(),
        ),
      ),
    );
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/historique_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await doc.save(), flush: true);
    return file;
  }
}
