import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Settings_Services {
  get_politiques() async {
    QueryBuilder<ParseObject> query;

    query = QueryBuilder<ParseObject>(ParseObject("politique/"))
      ..setAmountToSkip(0);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results!.first;
    } else {
      return null;
    }
  }

  get_conditions() async {
    QueryBuilder<ParseObject> query;

    query = QueryBuilder<ParseObject>(ParseObject("condition/"))
      ..setAmountToSkip(0);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results!.first;
    } else {
      return null;
    }
  }

  get_about() async {
    QueryBuilder<ParseObject> query;

    query = QueryBuilder<ParseObject>(ParseObject("history/"))
      ..setAmountToSkip(0);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results!.first;
    } else {
      return null;
    }
  }
}
