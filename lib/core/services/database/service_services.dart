import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/service.dart';

class ServiceServices {

  static Future<Service> getServiceFromID(String serviceID) async {
    QueryBuilder<ParseObject> query;

    query = QueryBuilder<ParseObject>(ParseObject("Service"))
      ..whereEqualTo("objectId", serviceID);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return Service.fromJson(apiResponse.results!.first);
    } else {
      return Service();
    }
  }

  static Future<Service> getServiceFromName(String servicename)async{
    QueryBuilder<ParseObject> query;

    query = QueryBuilder<ParseObject>(ParseObject("Service"))
      ..whereEqualTo("name", servicename);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return Service.fromJson(apiResponse.results!.first);
    } else {
      return Service();
    }
  }
}
