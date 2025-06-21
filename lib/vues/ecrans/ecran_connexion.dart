// =============================
// vues/ecrans/ecran_connexion.dart
// =============================

import 'package:flutter/material.dart';
import '../../controleurs/controleur_auth.dart';
import '../../modeles/utilisateur.dart';
import 'ecran_accueil.dart';

class EcranConnexion extends StatefulWidget {
  const EcranConnexion({super.key});

  @override
  State<EcranConnexion> createState() => _EcranConnexionState();
}

class _EcranConnexionState extends State<EcranConnexion> {
  final _phoneCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _auth = ControleurAuth();
  bool _isLoading = false;
  bool _obscure = true;

  Future<void> _connecter() async {
    final phone = _phoneCtrl.text.trim();
    final pwd = _pwdCtrl.text.trim();

    if (phone.isEmpty || pwd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final Utilisateur? user =
    await _auth.tenterConnexion(phone: phone, password: pwd);
    setState(() => _isLoading = false);

    if (user != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EcranAccueil()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec de la connexion')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFE9F0FA),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ------- Logo & titre -------
              const Icon(Icons.water_drop, size: 80, color: Colors.blue),
              const SizedBox(height: 6),
              const Text('Smart Water System',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),

              // ------- Carte de connexion -------
              Container(
                width: 350,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Numéro de téléphone'),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: _phoneCtrl,
                      hint: 'Ex. 690123456',
                      icon: Icons.phone,
                      type: TextInputType.phone,
                    ),
                    const SizedBox(height: 18),
                    _label('Mot de passe'),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: _pwdCtrl,
                      hint: 'Votre mot de passe',
                      icon: Icons.lock,
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(
                            _obscure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.login, color:Colors.white),
                        label: _isLoading
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                            : const Text('Se connecter',

                        style: TextStyle(fontSize: 16, color:Colors.white
                        )),
                        onPressed: _isLoading ? null : _connecter,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF0076FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  text: 'Pas de compte ? ',
                  children: [
                    TextSpan(
                      text: 'Contactez l’administrateur',
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                style: const TextStyle(fontSize: 12),
              ),

              // Pour combler si l’écran est grand
              SizedBox(height: h < 600 ? 40 : h * .1),
            ],
          ),
        ),
      ),
    );
  }

  /* ---------- Widgets helpers ---------- */
  Widget _label(String txt) =>
      Text(txt, style: const TextStyle(fontWeight: FontWeight.bold));

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType type = TextInputType.text,
  }) =>
      TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF8FBFF),
          prefixIcon: Icon(icon, color: Colors.blue),
          suffixIcon: suffix,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
}
