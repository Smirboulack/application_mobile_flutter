import 'dart:ui';

import 'package:sevenapplication/core/models/mission_model.dart';
import 'package:sevenapplication/core/models/user.dart';

class Demand {
  String objectId;
  DateTime createdAt;
  DateTime updatedAt;
  MissionModel mission;
  User jobber;
  String? status;

  Demand({
    required this.objectId,
    required this.createdAt,
    required this.updatedAt,
    required this.mission,
    required this.jobber,
    this.status,
  });

  factory Demand.fromJson(json) {
    return Demand(
      objectId: json['objectId'],
      createdAt: DateTime.parse(json['createdAt'].toString()),
      updatedAt: DateTime.parse(json['updatedAt'].toString()),
      mission: MissionModel.fromJson(json['mission']),
      jobber: User.fromJson(json['jobber']),
      status: json['status'],
    );
  }
}

