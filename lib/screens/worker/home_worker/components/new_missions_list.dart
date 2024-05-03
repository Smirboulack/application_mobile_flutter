import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sevenapplication/core/models/demandes.dart';
import 'package:sevenapplication/core/models/mission_model.dart';
import 'package:sevenapplication/core/services/database/mission_services.dart';
import 'package:sevenapplication/screens/worker/home_worker/components/horizontal_missions_component.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/static_data.dart';
import 'package:sevenapplication/widgets/cards/mission_card.dart';
import 'package:sevenapplication/widgets/cards/offer_card.dart';

class NewMissions extends StatefulWidget {
  ParseUser? utilisateur;

  NewMissions({Key? key, required this.utilisateur}) : super(key: key);

  @override
  State<NewMissions> createState() => _NewMissionsState();
}

class _NewMissionsState extends State<NewMissions> {
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nouvelles proposition pour vous ",
            style: TextStyle(
                fontSize: 20, height: 1.5, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          //MissionCard(missionsList[1]),

          /* MissionCard(missionsList[1]),
          MissionCard(missionsList[2]), */
          lat == 0.0
              ? Container()
              : FutureBuilder<List<MissionModel>>(
                  future: Missionservices.fetchAllMissionsWithTitles(lat, lng),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            'Une erreur s\'est produite lors du chargement des missions.'),
                      );
                    } else {
                      final missionsList2 = snapshot.data;
                      return missionsList2!.isEmpty
                          ? Center(
                              child: Text(
                                "Aucune mission trouvée autour de vous !",
                                style: TextStyle(
                                    color: ColorsConst.col_app,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: missionsList2!.length,
                              itemBuilder: (context, index) {
                                Distance distance = new Distance();
                                missionsList2[index].distance = distance
                                        .as(
                                            LengthUnit.Kilometer,
                                            LatLng(lat, lng),
                                            LatLng(
                                                missionsList2[index]
                                                    .location!
                                                    .latitude,
                                                missionsList2[index]
                                                    .location!
                                                    .longitude))
                                        .toString() +
                                    " Kms";
                                return MissionCard(
                                    missionsList2[index], widget.utilisateur);
                              },
                            );
                    }
                  },
                ),
        ],
      ),
    );
  }
}
