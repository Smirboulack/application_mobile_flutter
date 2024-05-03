import 'dart:io';

import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:sevenapplication/core/models/Conversation.dart';
import 'package:sevenapplication/core/models/user.dart';


class Message {
  Conversation? conversation;
  User? sender;
  User? receiver;
  String message;
  bool seen;
  String type;
  List<String>? show_message;

  DateTime created;

  // bool? isSelf;
  String objectId;

  Message(
      {this.conversation,
      required this.created,
      this.show_message,
      // this.isSelf,
      this.type = "",
      this.message = "",
      this.objectId = "",
      this.receiver,
      this.seen = false,
      this.sender});

  Message.fromMap(ParseObject map, User user, {User? sender})
      : objectId = map["objectId"],
        sender = sender != null ? sender : User.fromJson(map["sender"]),
        //receiver = User.fromMap(map["receiver"]),
        message = map["message"],
        show_message = List<String>.from(map["show_message"]),
        type = map["type"],
        seen = false,
        created = DateTime.fromMillisecondsSinceEpoch(map["created"])
  //isSelf = user.id == map["sender"]["objectId"] ? true : false`
  ;
}
