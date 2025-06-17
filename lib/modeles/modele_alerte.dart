class Alerte {
  final int id;
  final int tankId;
  final String type;
  final String message;
  final DateTime timestamp;

  Alerte({
    required this.id,
    required this.tankId,
    required this.type,
    required this.message,
    required this.timestamp,
  });

  factory Alerte.fromJson(Map<String, dynamic> json) {
    return Alerte(
      id: int.parse(json['id'].toString()),
      tankId: int.parse(json['tank_id'].toString()),
      type: json['type'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
