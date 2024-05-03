import 'package:sevenapplication/core/models/mission_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Missionservices {
  static Future<List<MissionModel>> fetchMissionsWithTitles() async {
    QueryBuilder<ParseObject> query;

    final currentUser = await ParseUser.currentUser();

    QueryBuilder<ParseObject> bossQuery =
        QueryBuilder<ParseObject>(ParseObject('_User'))
          ..whereEqualTo('objectId', currentUser!.get("objectId"));

    query = QueryBuilder<ParseObject>(ParseObject("Mission"))
      ..whereMatchesKeyInQuery("user", "objectId", bossQuery)
      ..includeObject(["title", "service", "status", "equipments", "mobility"])
      ..orderByDescending("createdAt");
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results!.map((e) => MissionModel.fromJson(e)).toList();
    } else {
      return List<MissionModel>.from([]);
    }
  }

  static Future<void> deleteAllUserMissions() async {
    List<MissionModel> missions = await fetchMissionsWithTitles();
    for (MissionModel mission in missions) {
      await deleteMission(mission.objectId!);
    }
  }

  static Future<List<MissionModel>> fetchAllMissionsWithTitles(lat, lng) async {
    QueryBuilder<ParseObject> query;

    ///"location": {"\$nearSphere": {"__type": "GeoPoint","latitude": $lat,"longitude":$lng},"\$maxDistanceInKilometers": 70
    query = QueryBuilder<ParseObject>(ParseObject("Mission"))
      ..whereNear("location", ParseGeoPoint(latitude: lat, longitude: lng))
      ..whereWithinKilometers(
          "location", ParseGeoPoint(latitude: lat, longitude: lng), 50)
      ..includeObject(["title", "service", "status", "equipments"]);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results!.map((e) => MissionModel.fromJson(e)).toList();
    } else {
      return List<MissionModel>.from([]);
    }
  }

  static Future<List<MissionModel>> myMissions(id) async {
    QueryBuilder<ParseObject> query;

    ///"location": {"\$nearSphere": {"__type": "GeoPoint","latitude": $lat,"longitude":$lng},"\$maxDistanceInKilometers": 70
    query = QueryBuilder<ParseObject>(ParseObject("Mission"))
      ..includeObject(["title", "service", "status", "equipments", "mobility"]);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results!.map((e) => MissionModel.fromJson(e)).toList();
    } else {
      return List<MissionModel>.from([]);
    }
  }

  static get_search(String text) async {
    QueryBuilder<ParseObject> query;

    query = QueryBuilder<ParseObject>(ParseObject("Mission"))
      ..regEx("titre", text)
      ..orderByDescending("createdAt")
      ..includeObject(["title", "service", "status", "equipments", "mobility"])
      ..setAmountToSkip(0);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results!.map((e) => MissionModel.fromJson(e)).toList();
    } else {
      return List<MissionModel>.from([]);
    }
  }

  static Future<int> countMissionsOwnedByCurrentUser() async {
    final currentUser = await ParseUser.currentUser();

    QueryBuilder<ParseObject> bossQuery =
        QueryBuilder<ParseObject>(ParseObject('_User'))
          ..whereEqualTo('objectId', currentUser!.get('objectId'));

    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('Mission'))
          ..whereMatchesKeyInQuery('user', 'objectId', bossQuery)
          ..orderByDescending("createdAt");

    final ParseResponse apiResponse = await query.count();

    if (apiResponse.success) {
      return apiResponse.count;
    } else {
      return 0;
    }
  }

  static Future<String> MissionOwnerID(String missionID) async {
    String userID = "";
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('Mission'))
          ..whereEqualTo('objectId', missionID);
    final ParseResponse apiResponse = await query.query();
    if (apiResponse.success && apiResponse.results != null) {
      userID =
          apiResponse.results!.map((e) => e['user']['objectId']).toString();
      userID = userID.replaceAll(RegExp(r'[\(\)]'), '');
    }
    return userID;
  }

  static Future<int> countCancelledMissionsForCurrentUser() async {
    final currentUser = await ParseUser.currentUser();

    QueryBuilder<ParseObject> statusQuery =
        QueryBuilder<ParseObject>(ParseObject('Status'))
          ..whereEqualTo('name', 'Annulée');

    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('Mission'))
          ..whereMatchesQuery('status', statusQuery)
          ..whereEqualTo('user', currentUser);

    final ParseResponse apiResponse = await query.count();

    if (apiResponse.success) {
      return apiResponse.count!;
    } else {
      return 0;
    }
  }

  static Future<int> countClosedMissionsForCurrentUser() async {
    final currentUser = await ParseUser.currentUser();

    QueryBuilder<ParseObject> statusQuery =
        QueryBuilder<ParseObject>(ParseObject('Status'))
          ..whereEqualTo('name', 'Clôturée');

    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('Mission'))
          ..whereMatchesQuery('status', statusQuery)
          ..whereEqualTo('user', currentUser);

    final ParseResponse apiResponse = await query.count();

    if (apiResponse.success) {
      return apiResponse.count!;
    } else {
      return 0;
    }
  }

  static Future<void> deleteMission(String missionID) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Mission'))
      ..whereEqualTo('objectId', missionID);

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      final mission = apiResponse.results!.first;

      await mission.delete();
    }
  }
}
