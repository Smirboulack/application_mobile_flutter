import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sevenapplication/core/models/demandes.dart';
import 'package:sevenapplication/core/models/mission_model.dart';
import 'package:sevenapplication/core/services/database/mission_services.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/static_data.dart';
import 'package:sevenapplication/widgets/cards/mission_card.dart';
import 'package:sevenapplication/widgets/custom_toggle_button.dart';

class AllOffers extends StatefulWidget {
  ParseUser? utilisateur;

  AllOffers({Key? key, required this.utilisateur}) : super(key: key);

  @override
  State<AllOffers> createState() => _AllOffersState();
}

class _AllOffersState extends State<AllOffers> {
  int _currentIndex = 0;
  int nboffres = 0;
  Position? _currentPosition;
  double lat = 0.0, lng = 0.0;
  String text_location = "";
  bool service_gps = false;
  bool show_button = false;
  var dialogOpen;
  bool show = false;

  Future<void> _initCurrentLocation() async {
    Position? currentPosition;
    try {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
          .then((Position position) {
        currentPosition = position;

        if (!this.mounted) return;

        //  setState(() => currentPosition = position);
        setState(() {
          lat = currentPosition!.latitude;
          lng = currentPosition!.longitude;
        });

        ///  getstades(lat, lng);

        setState(() {
          show = false;
        });

        //  d("position = $currentPosition");
      });
    } on PlatformException catch (e) {
      currentPosition = null;
    }

    if (!mounted) return;

    setState(() => _currentPosition = currentPosition);
  }

  Future _checkGeolocationPermission() async {
    bool service = await Geolocator.isLocationServiceEnabled();

    if (service == false) {
      setState(() {
        service_gps = false;
        text_location =
            "Pour voir les missions prés de vous, veuillez autoriser l’accès à votre GPS !";
      });
    } else {
      setState(() {
        service_gps = true;
      });

      var geolocationStatus = await Geolocator.checkPermission();

      print(geolocationStatus);
      if (geolocationStatus == LocationPermission.denied) {
        setState(() {
          show_button = true;
        });

        await Geolocator.requestPermission();
      } else if (geolocationStatus == LocationPermission.denied) {
        await [Permission.locationAlways, Permission.locationWhenInUse]
            .request();
      } // else if (geolocationStatus == LocationPermission.always) {
      _initCurrentLocation();
      // }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkGeolocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          const SizedBox(height: 24),
          CustomToggleButton(
            onTap: (int v) {
              _currentIndex = v;
              setState(() {});
            },
            label: const ["Tous", "Enregistrées", "Annulées"],
            isFirst: _currentIndex,
          ),
          if (_currentIndex == 0) _appliedList(),
          if (_currentIndex == 1) _appliedList(),
          if (_currentIndex == 2) _appliedList(),
        ],
      ),
    );
  }

  Widget _notAppliedList() {
    return Column(
      children: [
        const SizedBox(height: 100),
        //   Image.asset(Kimages.noInterviewImage),
        const SizedBox(height: 24),
        const Text(
          "No Schedule",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 24),
        const Text("There is no job interviews set yet",
            style: TextStyle(fontSize: 14))
      ],
    );
  }

  Column _appliedList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        lat == 0.0
            ? Container()
            : FutureBuilder<List<MissionModel>>(
                future: Missionservices.fetchAllMissionsWithTitles(lat, lng),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          'Une erreur s\'est produite lors du chargement des missions.'),
                    );
                  } else {
                    final missions = snapshot.data;
                    final missionsSaved = missions!
                        .where(
                            (element) => element.status!.name == "Enregistrée")
                        .toList();
                    final missionsCanceled = missions!
                        .where((element) => element.status!.name == "Annulée")
                        .toList();

                    if (_currentIndex == 0) {
                      return missions!.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 38.0),
                                child: Text(
                                  "Aucune mission trouvée autour de vous !",
                                  style: TextStyle(
                                      color: ColorsConst.col_app,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: missions!.length,
                              itemBuilder: (context, index) {
                                return MissionCard(
                                    missions[index], widget.utilisateur);
                              },
                            );
                    } else if (_currentIndex == 1) {
                      return missions!.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 38.0),
                                child: Text(
                                  "Aucune mission trouvée autour de vous !",
                                  style: TextStyle(
                                      color: ColorsConst.col_app,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: missionsSaved.length,
                              itemBuilder: (context, index) {
                                return MissionCard(
                                    missionsSaved[index], widget.utilisateur);
                              },
                            );
                    } else if (_currentIndex == 2) {
                      return missions!.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 38.0),
                                child: Text(
                                  "Aucune mission trouvée autour de vous !",
                                  style: TextStyle(
                                      color: ColorsConst.col_app,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : missions!.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 38.0),
                                    child: Text(
                                      "Aucune mission trouvée autour de vous !",
                                      style: TextStyle(
                                          color: ColorsConst.col_app,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: missionsCanceled.length,
                                  itemBuilder: (context, index) {
                                    return MissionCard(missionsCanceled[index],
                                        widget.utilisateur);
                                  },
                                );
                    } else {
                      return Container();
                    }
                  }
                },
              ),
        SizedBox(height: 16),
      ],
    );
  }
}
