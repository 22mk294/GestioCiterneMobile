class DonneesCiterne {
  final double niveauEau;
  final String pompe;
  final String vanne;
  final String buzzer;
  final double capacite;
  final String alerte;

  DonneesCiterne({
    required this.niveauEau,
    required this.pompe,
    required this.vanne,
    required this.buzzer,
    required this.capacite,
    required this.alerte,
  });

  // ➕ Pourcentage calculé (valeur entre 0.0 et 1.0)
  double get pourcentageEau {
    if (capacite == 0) return 0.0;
    return (niveauEau / capacite).clamp(0.0, 1.0);
  }

  factory DonneesCiterne.fromJson(Map<String, dynamic> json) {
    return DonneesCiterne(
      niveauEau: double.tryParse(json['water_level'].toString()) ?? 0.0,
      pompe: json['pump'],
      vanne: json['valve'],
      buzzer: json['buzzer'],
      capacite: double.tryParse(json['capacity'].toString()) ?? 1.0,
      alerte: json['alert'],
    );
  }
}
