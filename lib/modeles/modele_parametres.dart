class ParametresCiterne {
  final String pumpMode;
  final double criticalLevel;
  final double pricePer20L;
  final int refreshRate;

  ParametresCiterne({
    required this.pumpMode,
    required this.criticalLevel,
    required this.pricePer20L,
    required this.refreshRate,
  });

  factory ParametresCiterne.fromJson(Map<String, dynamic> json) {
    return ParametresCiterne(
      pumpMode: json['pump_mode'],
      criticalLevel: (json['critical_level'] as num).toDouble(),
      pricePer20L: (json['price_per_20l'] as num).toDouble(),
      refreshRate: json['refresh_rate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pump_mode': pumpMode,
      'critical_level': criticalLevel.toString(),
      'price_per_20l': pricePer20L.toString(),
      'refresh_rate': refreshRate.toString(),
    };
  }
}
