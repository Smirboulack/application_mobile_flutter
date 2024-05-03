import 'dart:math';

import 'package:http/http.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/Rating.dart';
import 'package:sevenapplication/core/services/database/database.dart';

class RatingService {
  Future<bool> createRating(String workerId, int ratenumb) async {
    final rate = ratenumb;
    final rating = ParseObject('Rating')
      ..set('Jobber', currentUser.toPointer())
      ..set('Worker', (ParseObject('User')..objectId = workerId).toPointer())
      ..set('Rating', rate);
    try {
      final response = await rating.save();
      if (response.success) {
        print("Rating saved");
        return true;
      } else {
        print("Rating not saved");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> updateRating() async {
    return "";
  }

  Future<String> deleteRating() async {
    return "";
  }

  Future<double> getRating(String raterID) async {
    List<Rating> rates = [];
    QueryBuilder<ParseObject> workerQuerry =
        QueryBuilder<ParseObject>(ParseObject('_User'))
          ..whereEqualTo('objectId', raterID);
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('Rating'))
          ..whereMatchesKeyInQuery('Worker', 'objectId', workerQuerry)
          ..orderByDescending("createdAt");
    final Response = await query.query();
    final ParseResponse apiResponse = await query.count();
    if (Response.success) {
      final List<ParseObject> results = Response.results as List<ParseObject>;
      for (final ParseObject result in results) {
        rates.add(Rating(
          objectId: result.get('objectId'),
          jobber: result.get('Jobber'),
          worker: result.get('Worker'),
          rating: result.get('Rating'),
        ));
      }
      if (apiResponse.count > 0) {
        return rates.length / apiResponse.count;
      } else {
        return 0;
      }
    }
    return 0;
  }

  Future<int> getRatings() async {
    final currentUser = await ParseUser.currentUser();
    QueryBuilder<ParseObject> bossQuery =
        QueryBuilder<ParseObject>(ParseObject('_User'))
          ..whereEqualTo('objectId', currentUser!.get('objectId'));

    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('Rating'))
          ..whereMatchesKeyInQuery('Jobber', 'objectId', bossQuery)
          ..orderByDescending("createdAt");

    final ParseResponse apiResponse = await query.count();

    if (apiResponse.success) {
      return apiResponse.count;
    } else {
      return 0;
    }
  }
}
