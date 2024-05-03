import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/equipment.dart';

class EquipenetsServices {
  // Function to fetch the equipment list from Parse SDK
  static
  Future<List<Equipment>> fetchEquipmentList() async {
    try {
      final ParseResponse response = await ParseObject('Equipment').getAll();
      if (response.success && response.results != null) {
        return response.results!.map((e) => Equipment.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      // Handle any errors that occur during fetching
      print('Error fetching equipment list: $e');
      return [];
    }
  }
}
