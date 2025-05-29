class EntreeHistorique {
  final DateTime date;
  final int consommation;
  final double cout;

  EntreeHistorique({
    required this.date,
    required this.consommation,
    required this.cout,
  });

  factory EntreeHistorique.fromJson(Map<String, dynamic> json) {
    return EntreeHistorique(
      date: DateTime.parse(json['date']),
      consommation: json['water_usage'],
      cout: json['cost'].toDouble(),
    );
  }
}
