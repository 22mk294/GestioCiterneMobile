// lib/composants/barre_superieure.dart

import 'package:flutter/material.dart';

// Widget personnalisé pour la barre supérieure de l'application
class BarreSuperieure extends StatelessWidget implements PreferredSizeWidget {
  final String titre; // Titre affiché dans la barre
  final List<Widget>? actions; // Liste d'icônes ou de boutons alignés à droite
  final bool afficherRetour; // Affiche ou non le bouton retour

  const BarreSuperieure({
    super.key,
    required this.titre,
    this.actions,
    this.afficherRetour = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Si afficherRetour est vrai, affiche un bouton de retour
      leading: afficherRetour
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      )
          : null,
      title: Text(titre), // Affiche le titre
      centerTitle: true, // Centre le titre
      actions: actions, // Actions à droite
      backgroundColor:  Color(0xFFCDE5FE), // Couleur de fond
    );
  }

  @override
  // Indique la taille préférée de la barre d'application
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

