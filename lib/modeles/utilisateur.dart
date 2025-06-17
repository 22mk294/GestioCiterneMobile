class Utilisateur {
  final int id;
  final String nomComplet;
  final String adresse;
  final String telephone;
  final String role;
  final int tankId;

  Utilisateur({
    required this.id,
    required this.nomComplet,
    required this.adresse,
    required this.telephone,
    required this.role,
    required this.tankId,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'],
      nomComplet: json['full_name'],
      adresse: json['address'],
      telephone: json['phone'],
      role: json['role'],
      tankId: json['tank_id'],
    );
  }


}
