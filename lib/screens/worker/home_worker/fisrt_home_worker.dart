import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localization/colored_print/print_color.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sevenapplication/core/models/demandes.dart';
import 'package:sevenapplication/core/models/mission_model.dart';
import 'package:sevenapplication/core/services/database/mission_services.dart';
import 'package:sevenapplication/screens/worker/home_worker/components/horizontal_list_offers.dart';
import 'package:sevenapplication/screens/worker/home_worker/components/horizontal_missions_component.dart';
import 'package:sevenapplication/screens/worker/home_worker/components/new_missions_list.dart';
import 'package:sevenapplication/screens/worker/home_worker/search_page.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/images.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sevenapplication/utils/static_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sevenapplication/utils/styles.dart';

class HomeFirstWorker extends StatefulWidget {
  ParseUser? utilisateur;

  HomeFirstWorker({Key? key, required this.utilisateur}) : super(key: key);

  @override
  State<HomeFirstWorker> createState() => _HomeFirstWorkerState();
}

class _HomeFirstWorkerState extends State<HomeFirstWorker> {
  final TextEditingController textEditingController = TextEditingController();

  int _currentIndex = 0;
  int nboffres = 0;
  Position? _currentPosition;
  double lat = 0.0, lng = 0.0;
  String text_location = "";
  bool service_gps = false;
  bool show_button = false;
  var dialogOpen;
  bool show = true;

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
        print(lat);
        print(lng);

        ///  getstades(lat, lng);

        setState(() {
          show = false;
        });

        //  d("position = $currentPosition");
      });
    } on PlatformException catch (e) {
      currentPosition = null;
      setState(() {
        show = false;
      });
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
    setState(() {
      _checkGeolocationPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          SizedBox(height: 24.h),
          _getPaddingChild(
            child: Text(
              'Bonjour ${widget.utilisateur!.get('username')} ! \nTrouver des missions sur Seven JOBS',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(height: 16.h),
          HorizontalOffersList(item: tagList),
          SizedBox(height: 16.h),
          Container(height: 50.h, child: _buildSearchField(context)),
          SizedBox(height: 40.h),
          show == true
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
                          : HorizontalMissionsList(
                              utilisateur: widget.utilisateur,
                              options: missionsListOptions,
                              missions: Future.value(missionsList2),
                              lat: lat,
                              lng: lng,
                            );
                    }
                  },
                ),
          SizedBox(height: 20.h),
          NewMissions(utilisateur: widget.utilisateur),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildSearchField(context) {
    return _getPaddingChild(
      child: TextFormField(
        controller: textEditingController,
        style: const TextStyle(color: ColorsConst.col_app),
        onEditingComplete: () {
          /* context.pushNamed("searchMissions",
              extra: textEditingController.text);*/

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SearchMissionsPage(textEditingController.text)));
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorsConst.col_app_f.withOpacity(0.2)),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorsConst.col_app_f.withOpacity(0.2)),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorsConst.borderColor),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          fillColor: ColorsConst.background_c,
          contentPadding: EdgeInsets.only(left: 12.w, right: 12.w),
          filled: true,
          hintText: "Chercher des missions …",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIconConstraints:
              const BoxConstraints(maxHeight: 40, maxWidth: 40),
          suffixIconColor: ColorsConst.col_app_f,
          suffixIcon: GestureDetector(
            onTap: () => () {
              context.goNamed("searchMissions",
                  extra: textEditingController.text);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              child: SvgPicture.asset(
                AppImages.filter,
                height: 18,
                width: 18,
                color: ColorsConst.col_app_black,
              ),
            ),
          ),
          hintStyle: StylesApp.textStyleM,
        ),
      ),
    );
  }

  Widget _getPaddingChild({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }
}
