import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:sevenapplication/core/models/entreprise.dart';
import 'package:sevenapplication/core/models/service.dart';
import 'package:sevenapplication/core/models/BankAccount.dart';

class User {
  final String username;
  final String email;
  final String phoneNumber;
  final String type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Entreprise? entreprise;
  final String id;
  String? image;
  final String? token;
  String? id_notification;
  XFile? Avatar;
  Service? service;
  BankAccount? bankAccount;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.image,
    required this.phoneNumber,
    this.id_notification,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.entreprise,
    this.token,
    this.Avatar,
    this.service,
    this.bankAccount,
  });

  factory User.fromJson(json) {
    return User(
        username: json['username'],
        email: json['email'] ?? "",
        token: json["token"],
        image: json["image"],
        id: json['objectId'],
        id_notification: json["id_notification"],
        phoneNumber: json['phoneNumber'],
        type: json['type'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        entreprise: json['entreprise'] == null
            ? null
            : Entreprise.fromJson(json['entreprise']),
        service:
            json['service'] != null ? Service.fromJson(json['service']) : null,
        bankAccount: json['bankAccount']);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'type': type,
      'token': token,
      /* 'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(), */
      'entreprise': entreprise?.toJson(),
      'service': service?.toJson(),
      'bankAccount': bankAccount?.toJson(),
    };
  }
}
