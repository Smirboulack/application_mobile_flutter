import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as clientHttp;
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/core/services/user_services.dart';

class CloudMessaging {
  static sendCustomNotif(String token, String message, String type, String id,
      User user) async {

    bool notif = await UserDataRepository.getUserNotif(user.id);

    if (notif == true) {
      var res = await clientHttp.post(
          Uri.parse(
              "/sendNotificationToSpecificUser"),
          body: {"keys": token, "message": message, "type": type, "id": id});
      // return res.body;

    }
  }

  sendTotopic(String type, String title, String content) async {
    var res = await clientHttp.post(
        Uri.parse(
            "/sendNotificationToSpecificUser"),
        body: {"title": title, "content": content, "type": type});
  }
}
