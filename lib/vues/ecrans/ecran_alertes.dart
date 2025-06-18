import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/service_connectivite.dart';
import '../../controleurs/controleur_alertes.dart';
import '../../modeles/modele_alerte.dart';
import '../composants/barre_navigation_inferieure.dart';
import '../../gestion_routes.dart';
import '../composants/barre_superieure.dart';

class EcranAlertes extends StatefulWidget {
  const EcranAlertes({super.key});

  @override
  State<EcranAlertes> createState() => _EcranAlertesState();
}

class _EcranAlertesState extends State<EcranAlertes> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final connectivite = Provider.of<ServiceConnectivite>(context, listen: false);
      if (!connectivite.estConnecte) {
        Navigator.pushReplacementNamed(context, GestionRoutes.erreurConnexion);
        return;
      }

      final ctl = Provider.of<ControleurAlertes>(context, listen: false);
      ctl.chargerAlertes().then((_) {
        ctl.marquerToutesCommeLues(); // Mise à jour des non lues
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceConnectivite>(
      builder: (context, connectivite, _) {
        if (!connectivite.estConnecte) {
          Future.microtask(() => Navigator.pushReplacementNamed(context, GestionRoutes.erreurConnexion));
          return const SizedBox.shrink();
        }

        return Scaffold(
          appBar: const BarreSuperieure(titre: 'Gestion des Alertes'),
          backgroundColor: const Color(0xFFE9F0FA),
          body: Consumer<ControleurAlertes>(
            builder: (context, ctl, _) {
              if (ctl.chargement) return const Center(child: CircularProgressIndicator());
              if (ctl.erreur != null) return Center(child: Text('Erreur : ${ctl.erreur}'));

              final resume = Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _resumeCard(Icons.warning_amber_rounded, Colors.redAccent, ctl.nbCritiques, 'Alertes\ncritiques'),
                  _resumeCard(Icons.error_outline, Colors.orange, ctl.nbImportantes, 'Alertes\nimportantes'),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      _resumeCard(Icons.info_outline, Colors.blue, ctl.nbInfos, 'Notifications'),
                      if (ctl.nbNonLues > 0)
                        Positioned(
                          top: 4,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            child: Text('${ctl.nbNonLues}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                          ),
                        ),
                    ],
                  ),
                ],
              );

              final filtres = Wrap(
                spacing: 8,
                children: [
                  _chip('Toutes', ctl.categorie == CategorieAlerte.toutes, () => ctl.changerCategorie(CategorieAlerte.toutes)),
                  _chip('Critiques', ctl.categorie == CategorieAlerte.critiques, () => ctl.changerCategorie(CategorieAlerte.critiques)),
                  _chip('Importantes', ctl.categorie == CategorieAlerte.importantes, () => ctl.changerCategorie(CategorieAlerte.importantes)),
                  _chip('Informations', ctl.categorie == CategorieAlerte.informations, () => ctl.changerCategorie(CategorieAlerte.informations)),
                ],
              );

              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      resume,
                      const SizedBox(height: 16),
                      filtres,
                      const SizedBox(height: 8),
                      Expanded(
                        child: ctl.alertes.isEmpty
                            ? const Center(child: Text('Aucune alerte.'))
                            : ListView.builder(
                          padding: const EdgeInsets.only(top: 12),
                          itemCount: ctl.alertes.length,
                          itemBuilder: (context, i) => _carteAlerte(ctl.alertes[i]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: BarreNavigationInferieure(indexActif: 3),
        );
      },
    );
  }

  Widget _resumeCard(IconData icon, Color color, int nombre, String libelle) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 15, backgroundColor: color.withOpacity(.15), child: Icon(icon, color: color)),
          const SizedBox(height: 4),
          Text('$nombre', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(libelle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _chip(String titre, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(titre),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: Colors.blue,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
    );
  }

  Widget _carteAlerte(Alerte alerte) {
    final color = _colorForType(alerte.type);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 1.5),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.15),
          child: Icon(_iconForType(alerte.type), color: color),
        ),
        title: Text(_titreCourt(alerte.type), style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 4),
          Text(alerte.message, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          Row(children: [
            Text(alerte.timestamp.toLocal().toString().substring(0, 16), style: const TextStyle(fontSize: 11, color: Colors.black54)),
            const Spacer(),
            _badge(_badgeLabel(alerte.type), color),
          ]),
        ]),
        isThreeLine: true,
      ),
    );
  }

  IconData _iconForType(String t) {
    switch (t) {
      case 'LOW_LEVEL': return Icons.warning;
      case 'PUMP_FAILURE': return Icons.build;
      case 'HIGH_FLOW': return Icons.speed;
      case 'VALVE_STUCK': return Icons.lock;
      case 'POWER_FAILURE': return Icons.power_off;
      case 'SENSOR_ERROR': return Icons.sensors_off;
      case 'SYSTEM_UPDATE': return Icons.system_update;
      default: return Icons.warning_amber_rounded;
    }
  }

  Color _colorForType(String t) {
    if ({'LOW_LEVEL', 'PUMP_FAILURE'}.contains(t)) return Colors.redAccent;
    if ({'HIGH_FLOW', 'VALVE_STUCK', 'POWER_FAILURE'}.contains(t)) return Colors.orange;
    return Colors.blue;
  }

  String _titreCourt(String t) {
    switch (t) {
      case 'LOW_LEVEL': return "Niveau d'eau critique";
      case 'PUMP_FAILURE': return 'Panne de pompe';
      case 'HIGH_FLOW': return 'Débit élevé';
      case 'VALVE_STUCK': return 'Vanne bloquée';
      case 'POWER_FAILURE': return 'Coupure de courant';
      case 'SYSTEM_UPDATE': return 'Mise à jour système';
      case 'SENSOR_ERROR': return 'Erreur capteur';
      default: return 'Alerte';
    }
  }

  String _badgeLabel(String t) {
    if ({'LOW_LEVEL', 'PUMP_FAILURE'}.contains(t)) return 'Critique';
    if ({'HIGH_FLOW', 'VALVE_STUCK', 'POWER_FAILURE'}.contains(t)) return 'Importante';
    return 'Info';
  }

  Widget _badge(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: color.withOpacity(.15), borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
  );
}
