import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controleurs/controleur_parametres.dart';
import '../../modeles/modele_parametres.dart';
import '../../services/service_connectivite.dart';
import '../composants/barre_navigation_inferieure.dart';
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
  double? _pricePer20L;
  int? _refreshRate;

  @override
  void initState() {
    super.initState();
    final controleur = Provider.of<ControleurParametres>(context, listen: false);
    controleur.chargerParametres();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ServiceConnectivite, ControleurParametres>(
      builder: (context, serviceConnectivite, controleur, child) {
        if (!serviceConnectivite.estConnecte) {
          return  EcranErreurConnexion();
        }

        if (!controleur.estCharge || controleur.parametres == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final param = controleur.parametres!;
        _pumpMode ??= param.pumpMode;
        _criticalLevel ??= param.criticalLevel;
        _pricePer20L ??= param.pricePer20L;
        _refreshRate ??= param.refreshRate;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Paramètres'),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            foregroundColor: Colors.black,
          ),
          backgroundColor: const Color(0xFFF4F8FC),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildDropdownMode(),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: "Niveau critique (%)",
                    initialValue: (_criticalLevel! * 100).toStringAsFixed(0),
                    onChanged: (val) =>
                    _criticalLevel = double.tryParse(val) != null ? double.parse(val) / 100 : _criticalLevel,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: "Prix pour 20 litres (FCFA)",
                    initialValue: _pricePer20L!.toStringAsFixed(0),
                    onChanged: (val) =>
                    _pricePer20L = double.tryParse(val) ?? _pricePer20L,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: "Fréquence d'actualisation (sec)",
                    initialValue: _refreshRate!.toString(),
                    onChanged: (val) =>
                    _refreshRate = int.tryParse(val) ?? _refreshRate,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final nouveauxParametres = ParametresCiterne(
                          pumpMode: _pumpMode!,
                          criticalLevel: _criticalLevel!,
                          pricePer20L: _pricePer20L!,
                          refreshRate: _refreshRate!,
                        );
                        await controleur.mettreAJour(nouveauxParametres);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✅ Paramètres mis à jour avec succès'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    child: const Text("Enregistrer"),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const BarreNavigationInferieure(indexActif: 1),
        );
      },
    );
  }

  Widget _buildDropdownMode() {
    return DropdownButtonFormField<String>(
      value: _pumpMode,
      decoration: const InputDecoration(
        labelText: "Mode de la pompe",
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: "auto", child: Text("Automatique")),
        DropdownMenuItem(value: "manual", child: Text("Manuel")),
      ],
      onChanged: (val) {
        setState(() {
          _pumpMode = val;
        });
      },
      validator: (value) => value == null ? 'Veuillez sélectionner un mode' : null,
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Champ requis';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}
