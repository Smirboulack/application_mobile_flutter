class Mobility {
  final String name;
  final String objectId;

  Mobility({
    required this.name,
    required this.objectId
  });

  factory Mobility.fromJson(json) {
    return Mobility(
      name: json['name'],
      objectId: json['objectId']
    );
  }

}