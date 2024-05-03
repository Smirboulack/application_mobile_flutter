import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/equipment.dart';
import 'package:sevenapplication/core/models/mobility.dart';
import 'package:sevenapplication/core/models/service.dart';
import 'package:sevenapplication/core/models/status.dart';
import 'package:sevenapplication/core/models/titles.dart';
import 'package:sevenapplication/core/models/user.dart';

class MissionModel {
  final String objectId;
  final String? titre;
  final String? description;
  final User? boss;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Service? service;
  final TitleMetier? title;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? address;
  final ParseGeoPoint? location;
  final Status? status;
  final String? heuresTravaux;
  final String? pauseTravaux;
  final String? nbWorker;
  final List<Equipment>? equipments;
  final List<Mobility>? mobilities;
  final dynamic? totalprice;
  String? distance;

  MissionModel(
      {required this.objectId,
      this.titre,
      this.description,
      this.boss,
      required this.createdAt,
      required this.updatedAt,
      this.service,
      this.title,
      this.startDate,
      this.endDate,
      this.address,
      this.location,
      this.status,
      this.equipments,
      this.mobilities,
      this.heuresTravaux,
      this.nbWorker,
      this.pauseTravaux,
      this.totalprice, this.distance});

  factory MissionModel.fromJson(json) {
    return MissionModel(
        objectId: json['objectId'],
        distance: "",
        description: json['description'],
        boss: json.containsKey('boss') ? User.fromJson(json['boss']) : null,
        titre: json["titre"] ?? "",
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        service: json.containsKey('service')
            ? Service.fromJson(json['service'])
            : null,
        title: json.containsKey('title')
            ? TitleMetier.fromJson(json['title'])
            : null,
        startDate: json.containsKey('start_date') ? json['start_date'] : null,
        endDate: json.containsKey('end_date') ? json['end_date'] : null,
        address: json['address'],
        equipments: List<Equipment>.from(json['equipments']
            .map((equipmentJson) => Equipment.fromJson(equipmentJson))),
        mobilities: List<Mobility>.from(json['mobility']
            .map((mobilityJson) => Mobility.fromJson(mobilityJson))),
        location: json.containsKey('location') ? json['location'] : null,
        status:
            json.containsKey('status') ? Status.fromJson(json['status']) : null,
        heuresTravaux: json['heurestravaux'],
        pauseTravaux: json['pausetravaux'],
        nbWorker: json['nbworker'],
        totalprice: json['totalprice']);
  }
}
