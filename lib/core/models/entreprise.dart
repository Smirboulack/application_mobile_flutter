import 'dart:convert';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/sector.dart';

class Entreprise {
  final String contact;
  final String interlocutor;
  final String siret;
  final String name;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String objectId;
  final Sector? sector;

  Entreprise({
    required this.contact,
    required this.interlocutor,
    required this.siret,
    required this.name,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.objectId,
    this.sector,
  });


  factory Entreprise.fromJson(json) {
    return Entreprise(
      contact: json['contact']??null,
      interlocutor: json['interlocutor'],
      siret: json['siret'],
      name: json['name'],
      address: json['address'],
      createdAt: json['createdAt'],
      updatedAt:json['updatedAt'],
      objectId: json['objectId'],
      sector: json['sector'] != null ? Sector.fromJson(json['sector']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact': contact,
      'interlocutor': interlocutor,
      'siret': siret,
      'name': name,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'objectId': objectId,
      'sector': sector?.toJson(),
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}
