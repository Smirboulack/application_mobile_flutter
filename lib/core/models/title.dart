class Title {
  final String objectId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? name;
  final double? price;

  Title({
    required this.objectId,
    required this.createdAt,
    required this.updatedAt,
    this.name,
    this.price,
  });

  factory Title.fromJson(json) {
    return Title(
      objectId: json['objectId'],
      createdAt: json['createdAt'],
      updatedAt:json['updatedAt'],
      name: json['name'],
      price: json['price']?.toDouble(),
    );
  }
}
