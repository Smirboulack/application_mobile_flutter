import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:sevenapplication/core/models/user.dart';

class Conversation {
  String id;
  User? user1;
  User? user2;
  String lastMessage;
  DateTime? lastTime;
  bool accepted;
  String type;
  bool vu;


  Conversation(
      {this.id = "",
      this.user1,
      this.user2,
      this.lastMessage = "",
      this.type = "",
      this.lastTime,
      this.vu = false,
      this.accepted = false});

  Conversation.fromMap(ParseObject map, id_me)
      : id = map["objectId"],
        lastMessage = map["lastMessage"]??"",
        type = "",
        vu = false/* map["user1"]["objectId"] != id_me
            ? map["vu_sender"]
            : map["vu_receiver"]*/,
        accepted = map["accepted"] ?? false,
        lastTime = DateTime.fromMillisecondsSinceEpoch(map["lastTime"]),
        user1 = User.fromJson(map["user1"]),
        user2 = User.fromJson(map["user2"]);
}
