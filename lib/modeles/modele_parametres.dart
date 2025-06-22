// lib/modeles/modele_parametres.dart
class ParametresCiterne {
  final String pumpMode;      // 'auto' ou 'manual'
  final double criticalLevel; // 0.00 – 1.00  (ex. 0.20 ⇔ 20 %)
  final int refreshRate;      // secondes
  final int pricePer20L;      // FC

  ParametresCiterne({
    required this.pumpMode,
    required this.criticalLevel,
    required this.refreshRate,
    required this.pricePer20L,
  });

  /// Convertit le JSON de l’API → objet Dart
  factory ParametresCiterne.fromJson(Map<String, dynamic> json) {
    return ParametresCiterne(
      pumpMode: json['pump_mode'],
      // 20 envoyé par l’API  →  0.20 interne
      criticalLevel: (json['critical_level'] as num).toDouble() / 100,
      refreshRate: json['refresh_rate'],
      pricePer20L: json['price_per_20l'],
    );
  }

  /// Convertit l’objet Dart → JSON pour l’API
  Map<String, dynamic> toJson() {
    return {
      'tank_id': 1,
      'api_key': '1ac34bd67sw',
      'pump_mode': pumpMode,
      // 0.20 interne  →  20 pour l’API
      'critical_level': (criticalLevel * 100).round(),
      'refresh_rate': refreshRate,
      'price_per_20l': pricePer20L,
    };
  }
}
