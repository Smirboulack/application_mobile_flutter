import 'package:sevenapplication/core/models/titles.dart';

class Service {
  final String? objectId;
  //final DateTime createdAt;
  //final DateTime updatedAt;
  final String? name;
  final List<TitleMetier> titles;

  Service({
   this.objectId,
  //  required this.createdAt,
   // required this.updatedAt,
    this.name,
    this.titles = const [],
  });

  factory Service.fromJson(json) {
    return Service(
      objectId: json['objectId'],
     // createdAt: json['createdAt'],
     // updatedAt: json['updatedAt'],
      name: json['name'],
      titles: json['titles'] != null
          ? json['titles'].map<TitleMetier>((title) {
              return TitleMetier.fromJson(title);
            }).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objectId': objectId,
     // 'createdAt': createdAt.toIso8601String(),
      //'updatedAt': updatedAt.toIso8601String(),
      'name': name,
      'titles': titles,
    };
  }

}

