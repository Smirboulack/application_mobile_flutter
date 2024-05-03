import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/mobility.dart';

class MobilityService {
  static  Future<List<Mobility>> fetchMobilityList() async {
    try {
      final ParseResponse response = await ParseObject('Mobility').getAll();
      if (response.success && response.results != null) {
        return response.results!.map((e) => Mobility.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      // Handle any errors that occur during fetching
      print('Error fetching mobility list: $e');
      return [];
    }
  }
}