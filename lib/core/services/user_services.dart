import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/BankAccount.dart';
import 'package:sevenapplication/core/models/Conversation.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/utils/const_app.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as clientHttp;

class UserDataRepository {
  static users_list(User user) async {
    QueryBuilder<ParseObject>? query;

    String url = ConstApp.keyParseServerUrl +
        '/classes/_User?include=sad_song,happy_song,while_song,current_song,lives,styles,activity,activity.activity_duration,activity.activity_type,city,state,country&where={"hide_profile":false}';

    var response =
        await clientHttp.get(Uri.parse(Uri.decodeFull(url)), headers: {
      "X-Parse-Application-Id": ConstApp.keyApplicationId,
      "Content-Type": 'applicaton/json'
    });

    String jsonBody = response.body;
    var statusCode = response.statusCode;
    if (statusCode < 200 || jsonBody == null || statusCode >= 300) {
      return null;
    } else {
      List<User> usrs = List<User>.from(json
          .decode(jsonBody)["results"]
          .map((var contactRaw) => new User.fromJson(contactRaw))
          .toList());

      return usrs;
    }
  }

  static Future update_notif_message0(String id_notif) async {
    var insertt2 = ParseObject('Notification')
      ..objectId = id_notif
      ..set('notif_message', 0);
    var res = await insertt2.save();
  }

  edit_user(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String id = prefs.getString("id");

    var insertt = ParseObject('_User')
      ..objectId = user.id
      ..set('email', user.email);
    ParseResponse a = await insertt.save();

    print(a.error);

    if (a.success == true) {
      return a.results;
    } else {
      return null;
    }
  }

  static Future update_user_images(User user, List<String> images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id").toString();

    var insertt = ParseObject('_User')
      ..objectId = user.id
      ..set('images', images);
    ParseResponse a = await insertt.save();
  }

  static Future update_user_languages(User user, List<String> languages) async {
    var insertt = ParseObject('_User')
      ..objectId = user.id
      ..set('languages', languages);
    ParseResponse a = await insertt.save();
  }

  static Future update_conversation_fn(String id) async {
    var insertt = ParseObject('Conversation')
      ..objectId = id
      ..set("lastTime", DateTime.now().toUtc().millisecondsSinceEpoch)
      ..set("lastMessage", "Nouvelle conversation !")
      ..set("accepted", true);

    ParseResponse res = await insertt.save();
    if (res.success == true) {
      return res.result["objectId"];
    } else {
      return "";
    }
  }

  static Future<Conversation?> get_if_conversation(User me, User him) async {
    Conversation? conversation;
    conversation = await get_if_conversation1(me.id, him.id);
    if (conversation == null) {
      conversation = await create_conversation(me, him);
    }
    return conversation;
  }

  static Future<Conversation?> get_if_conversation1(
      String id_me, String id_him) async {
    QueryBuilder<ParseObject> query;

    QueryBuilder<ParseObject> or1 = QueryBuilder<ParseObject>(
        ParseObject("_User"))
      ..whereEqualTo("user1",
          {"__type": "Pointer", "className": "_User", "objectId": "${id_him}"})
      ..whereEqualTo("user2",
          {"__type": "Pointer", "className": "_User", "objectId": "${id_me}"});

    QueryBuilder<ParseObject> or2 = QueryBuilder<ParseObject>(
        ParseObject("_User"))
      ..includeObject(["user1", "user2"])
      ..whereEqualTo("user1",
          {"__type": "Pointer", "className": "_User", "objectId": "${id_me}"})
      ..whereEqualTo("user2",
          {"__type": "Pointer", "className": "_User", "objectId": "${id_him}"});

    query = QueryBuilder.or(ParseObject("Conversation"), [or1, or2])
      ..setLimit(1)
      ..includeObject([
        "user1",
        "user2",
        "user1.entreprise",
        "user1.entreprise.sector",
        "user2.entreprise",
        "user2.entreprise.sector"
      ])
      ..count();

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success &&
        apiResponse.results != null &&
        apiResponse.count >= 1) {
      return Conversation.fromMap(apiResponse.result[0], id_me);
    } else {
      return null;
    }
  }

  static Future deleteuserconversations(String id_me) async {
    QueryBuilder<ParseObject> query;

    QueryBuilder<ParseObject> or1 =
        QueryBuilder<ParseObject>(ParseObject("_User"))
          ..whereEqualTo("user1", {
            "__type": "Pointer",
            "className": "_User",
            "objectId": "${id_me}"
          });

    QueryBuilder<ParseObject> or2 =
        QueryBuilder<ParseObject>(ParseObject("_User"))
          ..whereEqualTo("user2", {
            "__type": "Pointer",
            "className": "_User",
            "objectId": "${id_me}"
          });

    query = QueryBuilder.or(ParseObject("Conversation"), [or1, or2])
      ..setLimit(200)
      ..count();

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      for (var i in apiResponse.results!) {
        await i.delete();
      }
      return true;
    } else {
      return true;
    }
  }

  static Future get_if_conversation2(String id_me, String id_him) async {
    QueryBuilder<ParseObject> query;

    QueryBuilder<ParseObject> or1 =
        QueryBuilder<ParseObject>(ParseObject("_User"))
          ..whereEqualTo("user1", {
            "__type": "Pointer",
            "className": "_User",
            "objectId": "${id_me}"
          });

    QueryBuilder<ParseObject> or2 =
        QueryBuilder<ParseObject>(ParseObject("_User"))
          ..whereEqualTo("user2", {
            "__type": "Pointer",
            "className": "_User",
            "objectId": "${id_him}"
          });

    query = QueryBuilder.or(ParseObject("Conversation"), [or1, or2])
      ..setLimit(1)
      ..count();

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success &&
        apiResponse.results != null &&
        apiResponse.count >= 1) {
      return apiResponse.result[0]["objectId"];
    } else {
      return "";
    }
  }

  static Future update_conversation_vu(
      String id, id_sender, id_receiver, id_me) async {
    var insertt;
    if (id_me != id_sender)
      insertt = ParseObject('Conversation')
        ..objectId = id
        ..set("vu_sender", true);
    else
      insertt = ParseObject('Conversation')
        ..objectId = id
        ..set("vu_receiver", true);

    ParseResponse res = await insertt.save();
    if (res.success == true) {
      return res.result["objectId"];
    } else {
      return "";
    }
  }

  static Future update_conversation(String id, message,
      {required my_id, required id_sender, required id_receiver}) async {
    var insertt;

    if (my_id != id_sender) {
      insertt = ParseObject('Conversation')
        ..objectId = id
        ..set("lastTime", DateTime.now().toUtc().millisecondsSinceEpoch)
        ..set("receiver", true)
        ..set("vu_sender", false)
        ..set("lastMessage", message);
    } else {
      insertt = ParseObject('Conversation')
        ..objectId = id
        ..set("lastTime", DateTime.now().toUtc().millisecondsSinceEpoch)
        ..set("receiver", true)
        ..set("vu_receiver", false)
        ..set("lastMessage", message);
    }

    ParseResponse res = await insertt.save();
    if (res.success == true) {
      return res.result["objectId"];
    } else {
      return "";
    }
  }

  static Future create_conversation(User user_me, User user_other) async {
    var insertt = ParseObject('Conversation')
      ..set("lastTime", DateTime.now().toUtc().millisecondsSinceEpoch)
      ..set("lastMessage", "Nouvelle conversation ")
      ..set("user1", (ParseObject("_User")..objectId = user_me.id).toPointer())
      ..set("accepted", true)
      ..set("ids", [user_me.id, user_other.id])
      ..set("user2",
          (ParseObject("_User")..objectId = user_other.id).toPointer());

    ParseResponse res = await insertt.save();
    if (res.success == true) {
      return res.result["objectId"];
    } else {
      return "";
    }
  }

  static Future report_user(String id_sender, String id_receiver) async {
    var insertt = ParseObject('Report')
      ..set("sender_key", id_sender)
      ..set("receiver_key", id_receiver)
      ..set("sender", (ParseObject("_User")..objectId = id_sender).toPointer())
      ..set("receiver",
          (ParseObject("_User")..objectId = id_receiver).toPointer());

    ParseResponse res = await insertt.save();
    return res.success;
  }

  static Future active_account(User user) async {
    String id_notif = await active_notif(user);
    var insertt = ParseObject('_User')
      ..objectId = user.id
      ..set("id_notification", id_notif)
      ..set('active', true);
    ParseResponse a = await insertt.save();
  }

  static Future active_notif(User user) async {
    var insertt2 = ParseObject('Notification')..set('user_id', user.id);
    var res = await insertt2.save();
    if (res.success == true) {
      return res.results![0]["objectId"];
    } else
      return "";
  }

  static Future update_notif_message(String id_notif) async {
    var insertt2 = ParseObject('Notification')
      ..objectId = id_notif
      ..setIncrement('notif_message', 1);
    var res = await insertt2.save();
    if (res.success == true) {
      return res.results![0]["objectId"];
    } else
      return "";
  }

  static Future update_token(User user) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    var insertt = ParseObject('_User')
      ..objectId = user.id
      ..set('fcmToken', fcmToken);
    ParseResponse a = await insertt.save();
  }

  static Future<Conversation> getConversation(String id_conversation) async {
    QueryBuilder<ParseObject> query;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id").toString();

    query = QueryBuilder<ParseObject>(ParseObject('Conversation'))
      ..whereEqualTo("objectId", id_conversation)
      ..includeObject([
        'user1',
        'user2',
      ]);

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return Conversation.fromMap(apiResponse.results![0], id);
    } else {
      return Conversation();
    }
  }

  static Future<User?> getUserMe() async {
    QueryBuilder<ParseObject> query;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;

    String id = currentUser!.get('objectId');

    query = QueryBuilder<ParseObject>(ParseObject('_User'))
      ..whereEqualTo("objectId", id)
      ..includeObject(["entreprise", "service", "entreprise.sector"]);

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      print(apiResponse.result);
      return User.fromJson(apiResponse.results![0]);
    } else {
      return null;
    }
  }

  static Future<String> privacy() async {
    QueryBuilder<ParseObject> query;

    query = QueryBuilder<ParseObject>(ParseObject('PrivacyPolicy'));

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results![0]["content"];
    } else {
      return "";
    }
  }

  static Future<String> condition() async {
    QueryBuilder<ParseObject> query;

    query = QueryBuilder<ParseObject>(ParseObject('Cgu'));

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results![0]["content"];
    } else {
      return "";
    }
  }

  static Future<bool> getUserNotif(String id) async {
    QueryBuilder<ParseObject> query;

    query = QueryBuilder<ParseObject>(ParseObject('_User'))
      ..whereEqualTo("objectId", id)
      ..keysToReturn(["activate_notif"]);

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results![0]["activate_notif"];
    } else {
      return false;
    }
  }
  
}
