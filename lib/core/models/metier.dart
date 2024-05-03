import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/titles.dart';

class Metier {
  final List<TitleMetier> titles;
  final String name;
  final IconMetier icon;
  final String objectId;
  bool? check;

  Metier(
      {required this.titles,
      required this.name,
      required this.icon,
      this.check,
      required this.objectId});

  factory Metier.fromJson(json) {
    // Parsing titles
    List<TitleMetier> titles = [];
    if (json['titles'] != null) {
      json['titles'].forEach((title) {
        titles.add(TitleMetier.fromJson(title));
      });
    }

    // Parsing icon (assuming you have IconMetier data for the icon)
    IconMetier iconMetier = IconMetier.fromJson(json['icon']);

    return Metier(
        titles: titles,
        name: json['name'],
        icon: iconMetier,
        objectId: json['objectId'],
        check: false);
  }
}

class IconMetier {
  final String name;
  final String url;

  IconMetier({
    required this.name,
    required this.url,
  });

  factory IconMetier.fromJson(json) {
    return IconMetier(
      name: json['name'],
      url: json['url'],
    );
  }
}
