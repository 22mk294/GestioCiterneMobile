// lib/vues/ecrans/ecran_parametres.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../controleurs/controleur_parametres.dart';
import '../../modeles/modele_parametres.dart';
import '../../services/service_connectivite.dart';
import '../composants/barre_navigation_inferieure.dart';
import '../composants/barre_superieure.dart';
import 'ecran_erreur_connexion.dart';

class EcranParametres extends StatefulWidget {
  const EcranParametres({super.key});

  @override
  State<EcranParametres> createState() => _EcranParametresState();
}

class _EcranParametresState extends State<EcranParametres> {
  final _formKey = GlobalKey<FormState>();
  String? _pumpMode;
  double? _criticalLevel;
  int? _refreshRate;
  int? _pricePer20L;
  bool _init = false;

  @override
  // Initialisation de l'état
  void initState() {
    super.initState();
    // Charge les paramètres dès que l'écran est construit
    Provider.of<ControleurParametres>(context, listen: false)
        .chargerParametres();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ServiceConnectivite, ControleurParametres>(
      builder: (_, net, ctl, __) {
        if (!net.estConnecte) return EcranErreurConnexion();
        final param = ctl.parametres;
        if (param == null) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        // Initialisation des champs si ce n'est pas déjà fait
        if (!_init) {
          _pumpMode = param.pumpMode;
          _criticalLevel = param.criticalLevel;
          _refreshRate = param.refreshRate;
          _pricePer20L = param.pricePer20L;
          _init = true; // Évite la réinitialisation à chaque build
        }

        return Scaffold(
          appBar: const BarreSuperieure(titre: 'Paramètres'),
          backgroundColor: const Color(0xFFE9F0FA),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _sectionCard(children: [
                    _titleWithIcon(Icons.settings_remote, 'Mode Pompe'),
                    const SizedBox(height: 6),
                    _buildDropdownPumpMode(),
                    const SizedBox(height: 14),
                    _titleWithIcon(Icons.warning, 'Seuil d’alerte (%)'),
                    const SizedBox(height: 6),
                    _buildCriticalLevelField(),
                    const SizedBox(height: 14),
                    _titleWithIcon(Icons.monetization_on, 'Prix pour 20 L (FC)'),
                    const SizedBox(height: 6),
                    _buildNumberField(
                      initialValue: '$_pricePer20L',
                      hint: 'Ex. 500',
                      onChanged: (v) => _pricePer20L = int.tryParse(v) ?? 0,
                    ),
                    const SizedBox(height: 14),
                    _titleWithIcon(Icons.refresh, 'Taux de rafraîchissement (s)'),
                    const SizedBox(height: 6),
                    _buildNumberField(
                      initialValue: '$_refreshRate',
                      hint: 'Ex. 2',
                      onChanged: (v) => _refreshRate = int.tryParse(v) ?? 0,
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          'Enregistrer les paramètres',
                          style: TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF0076FF),
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          final p = ParametresCiterne(
                            pumpMode: _pumpMode!,
                            criticalLevel: _criticalLevel!,
                            refreshRate: _refreshRate!,
                            pricePer20L: _pricePer20L!,
                          );
                          try {
                            await ctl.mettreAJour(p);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Paramètres mis à jour',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Erreur : $e',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _infoCard(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const BarreNavigationInferieure(indexActif: 1),
        );
      },
    );
  }

  /* ---------- Widgets helpers ---------- */

  Widget _sectionCard({required List<Widget> children}) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
    ),
    child: Column(children: children),
  );

  Widget _titleWithIcon(IconData i, String t) => Row(
    children: [
      Icon(i, size: 18, color: Colors.blue),
      const SizedBox(width: 6),
      Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );

  Widget _buildDropdownPumpMode() => DropdownButtonFormField<String>(
    value: _pumpMode,
    decoration: _inputDeco(),
    items: const [
      DropdownMenuItem(value: 'auto', child: Text('Automatique')),
      DropdownMenuItem(value: 'manual', child: Text('Manuel')),
    ],
    onChanged: (v) => setState(() => _pumpMode = v),
    validator: (v) => v == null ? 'Choisir un mode' : null,
  );

  /// Champ limité à 2 chiffres (1–99) pour le pourcentage
  Widget _buildCriticalLevelField() => TextFormField(
    initialValue: (_criticalLevel! * 100).toStringAsFixed(0),
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(2),
    ],
    decoration: _inputDeco(hintText: 'Ex. 55'),
    onChanged: (v) =>
    _criticalLevel = (double.tryParse(v) ?? 0) / 100, // remet sur 0–1
    validator: (v) {
      if (v == null || v.isEmpty) return 'Champ requis';
      final n = int.tryParse(v);
      if (n == null || n < 1 || n > 99) return '1 – 99 %';
      return null;
    },
  );

  Widget _buildNumberField({
    required String initialValue,
    required String hint,
    required Function(String) onChanged,
  }) =>
      TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: _inputDeco(hintText: hint),
        onChanged: onChanged,
        validator: (v) => (v == null || v.isEmpty) ? 'Champ requis' : null,
      );

  InputDecoration _inputDeco({String? hintText}) => InputDecoration(
    hintText: hintText,
    filled: true,
    fillColor: const Color(0xFFF8FBFF),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  );

  Widget _infoCard() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFCDE5FE),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Icon(Icons.info_outline, color: Colors.blue),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Les changements sont appliqués immédiatement. '
                'Le mode automatique gère la pompe selon le niveau d’eau, '
                'alors que le mode manuel vous laisse le contrôle complet.',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    ),
  );
}
