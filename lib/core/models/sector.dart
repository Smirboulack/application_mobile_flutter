class Sector {
  final String name;
  final String objectId;

  Sector({required this.name, required this.objectId});

  factory Sector.fromJson(json) {
    return Sector(
      name: json['name'],
      objectId: json['objectId'],
    );
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'objectId': objectId,
      };
}