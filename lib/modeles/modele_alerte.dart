// =============================
// modeles/modele_alerte.dart (avec estLue + copyWith)
// =============================

class Alerte {
  final int id;
  final int tankId;
  final String type;
  final String message;
  final DateTime timestamp;
  final bool estLue;

  Alerte({
    required this.id,
    required this.tankId,
    required this.type,
    required this.message,
    required this.timestamp,
    this.estLue = false,
  });

  /*
  factory pour créer une instance de Alerte à partir d'un JSON
  convertit les types de données si nécessaire
  en particulier pour les entiers et les dates
   */
  factory Alerte.fromJson(Map<String, dynamic> json) => Alerte(
    id: int.parse(json['id'].toString()),
    tankId: int.parse(json['tank_id'].toString()),
    type: json['type'],
    message: json['message'],
    timestamp: DateTime.parse(json['timestamp']),
  );

  //duplique l'instance actuelle avec des modifications
  Alerte copyWith({bool? estLue}) => Alerte(
    id: id,
    tankId: tankId,
    type: type,
    message: message,
    timestamp: timestamp,
    estLue: estLue ?? this.estLue,
  );
}
