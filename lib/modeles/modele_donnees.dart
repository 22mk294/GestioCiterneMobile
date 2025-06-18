class DonneesCiterne {
  final double niveauEau;       // %
  final String pompe;
  final String vanne;
  final String buzzer;
  final double capacite;        // m³ ou L selon votre API
  final String alerte;

  // 🔸 NOUVEAU ↓
  final double consommation;    // water_usage en L
  final double revenu;          // revenue en FC

  DonneesCiterne({
    required this.niveauEau,
    required this.pompe,
    required this.vanne,
    required this.buzzer,
    required this.capacite,
    required this.alerte,
    required this.consommation,   // ← ajouté
    required this.revenu,         // ← ajouté
  });

  double get pourcentageEau => (niveauEau / 100).clamp(0.0, 1.0);

  DonneesCiterne copyWith({
    double? niveauEau,
    String? pompe,
    String? vanne,
    String? buzzer,
    double? capacite,
    String? alerte,
    double? consommation,   // ← ajouté
    double? revenu,         // ← ajouté
  }) {
    return DonneesCiterne(
      niveauEau:     niveauEau     ?? this.niveauEau,
      pompe:         pompe         ?? this.pompe,
      vanne:         vanne         ?? this.vanne,
      buzzer:        buzzer        ?? this.buzzer,
      capacite:      capacite      ?? this.capacite,
      alerte:        alerte        ?? this.alerte,
      consommation:  consommation  ?? this.consommation,
      revenu:        revenu        ?? this.revenu,
    );
  }

  factory DonneesCiterne.fromJson(Map<String, dynamic> json) {
    return DonneesCiterne(
      niveauEau:    double.tryParse(json['water_level'].toString()) ?? 0.0,
      pompe:        json['pump']   ?? "-",
      vanne:        json['valve']  ?? "-",
      buzzer:       json['buzzer'] ?? "-",
      capacite:     double.tryParse(json['capacity'].toString())   ?? 1.0,
      alerte:       json['alert']  ?? "-",
      consommation: double.tryParse(json['water_usage'].toString()) ?? 0.0, // ← ajouté
      revenu:       double.tryParse(json['revenue'].toString())     ?? 0.0, // ← ajouté
    );
  }
}
