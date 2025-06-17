class ParametresCiterne {
  final String pumpMode;
  final double criticalLevel;
  final int refreshRate;
  final int pricePer20L;

  ParametresCiterne({
    required this.pumpMode,
    required this.criticalLevel,
    required this.refreshRate,
    required this.pricePer20L,
  });

  factory ParametresCiterne.fromJson(Map<String, dynamic> json) {
    return ParametresCiterne(
      pumpMode: json['pump_mode'],
      criticalLevel: (json['critical_level'] as num).toDouble(),
      refreshRate: json['refresh_rate'],
      pricePer20L: json['price_per_20l'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tank_id': 1,
      'api_key': '1ac34bd67sw',
      'pump_mode': pumpMode,
      'critical_level': criticalLevel.toString(),
      'refresh_rate': refreshRate.toString(),
      'price_per_20l': pricePer20L.toString(),
    };
  }
}
