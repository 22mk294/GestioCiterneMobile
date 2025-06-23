// Modèle de données représentant l'état de la citerne
class DonneesCiterne {
  final double niveauEau;       // Niveau d'eau en pourcentage
  final String pompe;           // État de la pompe ("ON"/"OFF")
  final String vanne;           // État de la vanne ("OPEN"/"CLOSED")
  final String buzzer;          // État du buzzer
  final double capacite;        // Capacité de la citerne (m³ ou L selon l'API)
  final String alerte;          // Message d'alerte

  // 🔸 NOUVEAU ↓
  final double consommation;    // Consommation d'eau en L
  final double revenu;          // Revenu généré en FC

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

  // Retourne le pourcentage d'eau (entre 0 et 1)
  double get pourcentageEau => (niveauEau / 100).clamp(0.0, 1.0);

  // Crée une copie de l'objet avec des valeurs modifiées si besoin
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

  // Crée une instance à partir d'un JSON
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

