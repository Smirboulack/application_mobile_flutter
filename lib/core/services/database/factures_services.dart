import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/facture.dart';
import 'package:sevenapplication/core/models/mission_model.dart';

class FactureServices {
  static Future<List<Facture>> getAllFactures() async {
    QueryBuilder<ParseObject> query;
    final currentUser = await ParseUser.currentUser();

    QueryBuilder<ParseObject> bossQuery =
        QueryBuilder<ParseObject>(ParseObject('_User'))
          ..whereEqualTo('objectId', currentUser!.get("objectId"));

    query = QueryBuilder<ParseObject>(ParseObject("Facture"))
      ..whereMatchesKeyInQuery("boss", "objectId", bossQuery)
      ..includeObject([
        'mission.user',
        'mission.title',
        'mission.service',
        'jobber',
        "mission",
        "mission.equipments",
        "mission.service",
        "mission.title"
      ]);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      print(apiResponse.results!.map((e) => Facture.fromJson(e)).toList());
      return apiResponse.results!.map((e) => Facture.fromJson(e)).toList();
    } else {
      return List<Facture>.from([]);
    }
  }

  static Future<List<Facture>> getAllFacturesByMission(
      MissionModel mission) async {
    QueryBuilder<ParseObject> query;
    query = QueryBuilder<ParseObject>(ParseObject("Facture"))
      ..whereEqualTo("mission", mission.objectId)
      ..includeObject([
        'mission.user',
        'mission.title',
        'mission.service',
        'jobber',
        "mission",
        "mission.equipments",
        "mission.service",
        "mission.title"
      ]);
    final ParseResponse apiResponse = await query.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results!.map((e) => Facture.fromJson(e)).toList();
    } else {
      return List<Facture>.from([]);
    }
  }

  static Future<void> deleteFactureByMission(MissionModel mission) async {
    QueryBuilder<ParseObject> query;
    query = QueryBuilder<ParseObject>(ParseObject('Facture'))
      ..whereEqualTo('mission', mission.objectId);

    final ParseResponse apiResponse = await query.query();
    if (apiResponse.success && apiResponse.results != null) {
      List<Facture> facturesToDelete =
          apiResponse.results!.map((e) => Facture.fromJson(e)).toList();

      for (var facture in facturesToDelete) {
        await deleteFacture(facture); // Delete each facture
      }
    }
  }

  static Future<ParseResponse> deleteFacture(Facture facture) async {
    final factureObject = ParseObject('Facture')
      ..set('objectId', facture.objectId);

    return await factureObject.delete();
  }

/* static  Future<List<Facture>> getAllFactures() async {
    List<Facture> factures = [];
    final query = QueryBuilder<ParseObject>(ParseObject('Facture'))
      ..includeObject(['mission.title', 'mission.service', 'jobber']);

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      factures = apiResponse.results!.map((result) {
        return Facture.fromJson(result);
      }).toList();
    } else {
      throw Exception('Impossible de récupérer les factures.');
    }

    return factures;
  }*/
}
