// lib/composants/barre_superieure.dart

import 'package:flutter/material.dart';

class BarreSuperieure extends StatelessWidget implements PreferredSizeWidget {
  final String titre;
  final List<Widget>? actions;
  final bool afficherRetour;

  const BarreSuperieure({
    super.key,
    required this.titre,
    this.actions,
    this.afficherRetour = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: afficherRetour
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      )
          : null,
      title: Text(titre),
      centerTitle: true,
      actions: actions,
      backgroundColor:  Color(0xFFD3ECFF),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
