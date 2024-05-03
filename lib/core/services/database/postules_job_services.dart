import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class PostulerJobServices {
  static Future<void> postulerJob(String idJob, String idUser) async {
    final query = ParseObject('PostulerJob')
      ..set<String>('idJob', idJob)
      ..set<String>('idUser', idUser);
    await query.save();
  }
}
