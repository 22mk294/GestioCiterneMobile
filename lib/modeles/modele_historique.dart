class EntreeHistorique {
  final DateTime date;
  final int consommation; // en L
  final double revenu;    // en FC

  EntreeHistorique({
    required this.date,
    required this.consommation,
    required this.revenu,
  });

  factory EntreeHistorique.fromJson(Map<String, dynamic> json) {
    return EntreeHistorique(
      date: DateTime.parse(json['date']),
      consommation: int.parse(json['water_usage'].toString()),
      revenu: double.parse(json['revenue'].toString()),
    );
  }
}
