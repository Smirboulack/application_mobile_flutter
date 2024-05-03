import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/demandes.dart';

class DemandeServices {
  static Future<void> createDemande(
      String idJobber, String idMission, String idBoss) async {
    final query = ParseObject('Demande')
      ..set('jobber', (ParseObject("_User")..objectId = idJobber).toPointer())
      ..set(
          'mission', (ParseObject("Mission")..objectId = idMission).toPointer())
      ..set('boss', (ParseObject("_User")..objectId = idBoss).toPointer());
    await query.save();

    try {
      final response = await query.save();
      if (response.success) {
        print('Demande created successfully!');
      } else {
        print('Error creating Demande: ${response.error!.message}');
      }
    } catch (e) {
      print('Error creating Demande: $e');
    }
  }

  static Future<void> deleteDemande(String missionID, String joberID) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Demande'))
      ..whereEqualTo(
          'mission', (ParseObject("Mission")..objectId = missionID).toPointer())
      ..whereEqualTo(
          'jobber', (ParseObject("_User")..objectId = joberID).toPointer());
    final response = await query.query();
    if (response.success && response.results != null) {
      final ParseObject object = response.results![0];
      await object.delete();
    }
  }

  static Future<void> deleteAllDemandsForMission(String missionID) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Demande'))
      ..whereEqualTo('mission',
          (ParseObject("Mission")..objectId = missionID).toPointer());
    final response = await query.query();
    if (response.success && response.results != null) {
      final List objectsToDelete = response.results!;
      for (final ParseObject object in objectsToDelete) {
        await object.delete();
      }
    }
  }

  static Future<List<Demand>> getAllBossDemandes() async {
    QueryBuilder<ParseObject> query;
    final currentUser = await ParseUser.currentUser();

    QueryBuilder<ParseObject> bossQuery =
        QueryBuilder<ParseObject>(ParseObject('_User'))
          ..whereEqualTo('objectId', currentUser!.get("objectId"));

    query = QueryBuilder<ParseObject>(ParseObject("Demande"))
      ..whereMatchesKeyInQuery("boss", "objectId", bossQuery)
      ..includeObject([
        'mission.user',
        'mission.title',
        'mission.service',
        'jobber',
        "mission.user.entreprise",
        "mission.user.entreprise.sector",
        "mission.user.services",
        "mission",
        "mission.equipments",
        "mission.service",
        "mission.title"
      ]);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      print(apiResponse.results!.map((e) => Demand.fromJson(e)).toList());
      return apiResponse.results!.map((e) => Demand.fromJson(e)).toList();
    } else {
      return List<Demand>.from([]);
    }
  }

  static Future<List<Demand>> getAllJoberDemandes() async {
    QueryBuilder<ParseObject> query;
    final currentUser = await ParseUser.currentUser();

    QueryBuilder<ParseObject> bossQuery =
        QueryBuilder<ParseObject>(ParseObject('_User'))
          ..whereEqualTo('objectId', currentUser!.get("objectId"));

    query = QueryBuilder<ParseObject>(ParseObject("Demande"))
      ..whereMatchesKeyInQuery("jobber", "objectId", bossQuery)
      ..includeObject([
        'mission.user',
        'mission.title',
        'mission.service',
        'jobber',
        "mission.user.entreprise",
        "mission.user.entreprise.sector",
        "mission.user.services",
        "mission",
        "mission.equipments",
        "mission.service",
        "mission.title"
      ]);
    final ParseResponse apiResponse = await query.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results!.map((e) => Demand.fromJson(e)).toList();
    } else {
      return List<Demand>.from([]);
    }
  }
}
