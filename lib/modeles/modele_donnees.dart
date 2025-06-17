class DonneesCiterne {
  final double niveauEau; // => déjà en pourcentage (ex: 78.0)
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

  /// 🔄 Convertit le niveau en % vers une valeur [0.0 - 1.0]
  double get pourcentageEau => (niveauEau / 100).clamp(0.0, 1.0);

  DonneesCiterne copyWith({
    double? niveauEau,
    String? pompe,
    String? vanne,
    String? buzzer,
    double? capacite,
    String? alerte,
  }) {
    return DonneesCiterne(
      niveauEau: niveauEau ?? this.niveauEau,
      pompe: pompe ?? this.pompe,
      vanne: vanne ?? this.vanne,
      buzzer: buzzer ?? this.buzzer,
      capacite: capacite ?? this.capacite,
      alerte: alerte ?? this.alerte,
    );
  }

  factory DonneesCiterne.fromJson(Map<String, dynamic> json) {
    return DonneesCiterne(
      niveauEau: double.tryParse(json['water_level'].toString()) ?? 0.0, // déjà en %
      pompe: json['pump'],
      vanne: json['valve'],
      buzzer: json['buzzer'],
      capacite: double.tryParse(json['capacity'].toString()) ?? 1.0,
      alerte: json['alert'],
    );
  }
}
