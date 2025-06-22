import 'package:share_plus/share_plus.dart';
import '../services/export_service.dart';
import '../controleurs/controleur_historique.dart';

class ExporterHistoriqueUseCase {
  final ExportService service;

  ExporterHistoriqueUseCase({required this.service});

  Future<void> executer(String format, ControleurHistorique ctl) async {
    final file = format == 'csv'
        ? await service.generateCSV(ctl.historique)
        : await service.generatePDF(ctl.historique);
    await Share.shareXFiles([XFile(file.path)], text: 'Historique de consommation');
  }
}
