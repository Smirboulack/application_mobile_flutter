class TitleMetier {
  final String objectId;

  // final DateTime createdAt;
  //final DateTime updatedAt;
  final String? name;
  final double? price;
  bool? check;

  TitleMetier({
    required this.objectId,
    this.check,
    // required this.createdAt,
    //required this.updatedAt,
    this.name,
    this.price,
  });

  factory TitleMetier.fromJson(json) {
    return TitleMetier(
      objectId: json['objectId'],
      check: false,
      //  createdAt: json['createdAt'],
      // updatedAt:json['updatedAt'],
      name: json['name'],
      price: json['price']?.toDouble(),
    );
  }

}