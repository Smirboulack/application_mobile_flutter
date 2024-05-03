class Equipment {
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String abrv;
  final String objectId;

  Equipment({
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.abrv,
    required this.objectId});

  // Function to create an Equipment object from a Map (JSON-like data)
  factory Equipment.fromJson(json) {
    return Equipment(
      name: json['name'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      abrv: json['abrv'],
      objectId: json['objectId']
    );
  }

}