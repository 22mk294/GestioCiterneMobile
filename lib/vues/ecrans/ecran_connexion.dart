import 'package:flutter/material.dart';
import '../../controleurs/controleur_auth.dart';
import '../../modeles/utilisateur.dart';
import 'ecran_accueil.dart';

class EcranConnexion extends StatefulWidget {
  @override
  _EcranConnexionState createState() => _EcranConnexionState();
}

class _EcranConnexionState extends State<EcranConnexion> {
  final _telephoneController = TextEditingController();
  final _motDePasseController = TextEditingController();
  final _controleur = ControleurAuth();
  bool _isLoading = false;

  void _connecter() async {
    final phone = _telephoneController.text.trim();
    final password = _motDePasseController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final Utilisateur? utilisateur = await _controleur.tenterConnexion(
      phone: phone,
      password: password,
    );

    setState(() => _isLoading = false);

    if (utilisateur != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => EcranAccueil()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Échec de la connexion.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(24),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              children: [
                Icon(Icons.water_drop, size: 80, color: Colors.blue),
                SizedBox(height: 10),
                Text('Smart Water System',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Gestion intelligente de votre système d’eau',
                    textAlign: TextAlign.center),
                SizedBox(height: 30),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Numéro de téléphone',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextField(
                  controller: _telephoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: 'Entrez votre numéro de téléphone',
                  ),
                ),
                SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Mot de passe',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextField(
                  controller: _motDePasseController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Entrez votre mot de passe',
                    suffixIcon: Icon(Icons.visibility),
                  ),
                ),
                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _connecter,
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Se connecter"),
                  ),
                ),
                SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: "Vous n’avez pas de compte ? ",
                    children: [
                      TextSpan(
                        text: "Contactez l’administrateur",
                        style: TextStyle(color: Colors.blue),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
