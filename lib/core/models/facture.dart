import 'dart:ui';

import 'package:sevenapplication/core/models/mission_model.dart';
import 'package:sevenapplication/core/models/user.dart';

class Facture {
  String objectId;
  DateTime createdAt;
  DateTime updatedAt;
  MissionModel mission;
  User jobber;
  String? status;

  Facture({
    required this.objectId,
    required this.createdAt,
    required this.updatedAt,
    required this.mission,
    required this.jobber,
    this.status,
  });

  factory Facture.fromJson(json) {
    return Facture(
      objectId: json['objectId'],
      createdAt: DateTime.parse(json['createdAt'].toString()),
      updatedAt: DateTime.parse(json['updatedAt'].toString()),
      mission: MissionModel.fromJson(json['mission']),
      jobber: User.fromJson(json['jobber']),
      status: json['status'],
    );
  }
}
