import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:sevenapplication/core/models/sector.dart';

class SectorService {
   static Future<List<Sector>> fetchSectors() async {
    try {
      final queryBuilder = QueryBuilder(ParseObject('Sector'));
      final response = await queryBuilder.query();

      if (response.success && response.results != null) {
        final sectors = response.results!.map((result) {
          return Sector.fromJson(result);
        }).toList();

        return sectors;
      }
    } catch (e) {
      print('Error fetching sectors: $e');
    }

    return [];
  }
}