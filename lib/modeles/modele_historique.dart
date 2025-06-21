class EntreeHistorique {
  final DateTime date;
  final double consommation; // en litres
  final double revenu;       // en FC

  EntreeHistorique({
    required this.date,
    required this.consommation,
    required this.revenu,
  });

  factory EntreeHistorique.fromJson(Map<String, dynamic> json) {
    return EntreeHistorique(
      date: DateTime.parse(json['date']),
      consommation: double.parse(json['water_usage'].toString()),
      revenu: double.parse(json['revenue'].toString()),
    );
  }
}
