import 'package:flutter/foundation.dart';
import 'package:sevenapplication/core/models/sector.dart';
import 'package:sevenapplication/core/services/sectors_services.dart';


class SectorViewModel with ChangeNotifier {
  List<Sector> sectors = [];
  bool isLoading = false;
  final SectorService _sectorService = SectorService();

  Future<void> fetchSectors() async {
    isLoading = true;
    notifyListeners();

    sectors = await SectorService.fetchSectors();

    isLoading = false;
    notifyListeners();
  }
}