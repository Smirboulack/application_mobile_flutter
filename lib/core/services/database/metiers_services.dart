import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/metier.dart';
import 'package:sevenapplication/core/models/titles.dart';

class ServicesRepository {
  static Future<List<Metier>> fetchServicesWithTitles() async {
    QueryBuilder<ParseObject> query;

    query = QueryBuilder<ParseObject>(ParseObject("Service"))
      ..includeObject(["titles"])
      ..setAmountToSkip(0);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results!.map((e) => Metier.fromJson(e)).toList();
    } else {
      return List<Metier>.from([]);
    }
  }
}

