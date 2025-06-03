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
  int? _refreshRate;
  int? _pricePer20L;

  bool _initialise = false;

  @override
  void initState() {
    super.initState();
    final controleur = Provider.of<ControleurParametres>(context, listen: false);
    controleur.chargerParametres();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ServiceConnectivite, ControleurParametres>(
      builder: (context, connectivite, controleur, child) {
        if (!connectivite.estConnecte) {
          return EcranErreurConnexion();
        }

        final param = controleur.parametres;

        if (param == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Initialiser une seule fois
        if (!_initialise) {
          _pumpMode = param.pumpMode;
          _criticalLevel = param.criticalLevel;
          _refreshRate = param.refreshRate;
          _pricePer20L = param.pricePer20L;
          _initialise = true;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Paramètres"),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
          ),
          backgroundColor: const Color(0xFFF4F8FC),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildDropdownPumpMode(),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: "Niveau critique (%)",
                    initialValue: (_criticalLevel! * 100).toStringAsFixed(0),
                    onChanged: (val) {
                      final parsed = double.tryParse(val);
                      if (parsed != null) {
                        _criticalLevel = parsed / 100;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: "Prix pour 20L (FCFA)",
                    initialValue: _pricePer20L.toString(),
                    onChanged: (val) {
                      final parsed = int.tryParse(val);
                      if (parsed != null) {
                        _pricePer20L = parsed;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: "Fréquence d'actualisation (sec)",
                    initialValue: _refreshRate.toString(),
                    onChanged: (val) {
                      final parsed = int.tryParse(val);
                      if (parsed != null) {
                        _refreshRate = parsed;
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final nouveauxParametres = ParametresCiterne(
                          pumpMode: _pumpMode!,
                          criticalLevel: _criticalLevel!,
                          refreshRate: _refreshRate!,
                          pricePer20L: _pricePer20L!,
                        );

                        try {
                          await controleur.mettreAJour(nouveauxParametres);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("✅ Paramètres mis à jour"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("❌ Échec : ${e.toString()}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text("Enregistrer"),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BarreNavigationInferieure(indexActif: 1),
        );
      },
    );
  }

  Widget _buildDropdownPumpMode() {
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
          _pumpMode = val!;
        });
      },
      validator: (val) =>
      val == null || val.isEmpty ? "Veuillez choisir un mode" : null,
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required void Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) =>
      value == null || value.isEmpty ? 'Champ requis' : null,
      onChanged: onChanged,
    );
  }
}
