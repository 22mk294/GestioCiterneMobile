// Modèle de données représentant l'état de la citerne
class DonneesCiterne {
  final double niveauEau;
  final String pompe;
  final String vanne;
  final String buzzer;
  final double capacite;
  final String alerte;
  final double consommation;
  final double revenu;

  DonneesCiterne({
    required this.niveauEau,
    required this.pompe,
    required this.vanne,
    required this.buzzer,
    required this.capacite,
    required this.alerte,
    required this.consommation,
    required this.revenu,
  });

  // Retourne le pourcentage d'eau (entre 0 et 1)
  double get pourcentageEau => (niveauEau / 100).clamp(0.0, 1.0);

  /*
    * Crée une copie de l'instance avec des valeurs modifiées.
    * Utilisé pour mettre à jour les données sans modifier l'instance originale.
    * util pour la programmation immuable.
   */
  DonneesCiterne copyWith({
    double? niveauEau,
    String? pompe,
    String? vanne,
    String? buzzer,
    double? capacite,
    String? alerte,
    double? consommation,
    double? revenu,
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

