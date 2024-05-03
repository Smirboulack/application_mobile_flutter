import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:sevenapplication/core/models/mission_model.dart';
import 'package:sevenapplication/core/services/database/rating_services.dart';
import 'package:sevenapplication/screens/worker/home_worker/components/Equipement_card.dart';
import 'package:sevenapplication/screens/worker/home_worker/components/Mobility_card.dart';
import '../../../core/services/geolocalisation/geolocalisation_services.dart';
import '../../../utils/colors_app.dart';
import '../../../widgets/cards/mission_card.dart';
import '../../contract/pdfpreview.dart';

class mission_details extends StatefulWidget {
  mission_details({required this.mission});
  final MissionModel mission;

  static String lorem =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi. Proin porttitor, orci nec nonummy molestie, enim est eleifend mi, non fermentum diam nisl sit amet erat. Duis semper. Duis arcu massa, scelerisque vitae, consequat in, pretium a, enim. Pellentesque congue. Ut in risus volutpat libero pharetra tempor. Cras vestibulum bibendum augue. Praesent egestas leo in pede. Praesent blandit odio eu enim. Pellentesque sed dui ut augue blandit sodales. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aliquam nibh. Mauris ac mauris sed pede pellentesque fermentum. Maecenas adipiscing ante non diam sodales hendrerit.";

  @override
  State<mission_details> createState() => _mission_detailsState();
}

class _mission_detailsState extends State<mission_details> {
  late ScrollController controller;
  ParseUser? utilisateur;
  bool isworker = false;
  late bool isLoading;
  late double distanceInMeters = 0.0;
  late double distKilometer = 0.0;
  late double ratenumb = 0;
  ParseGeoPoint? localisation;
  double calcul_Salaire() {
    double salaire =
        double.parse(widget.mission.heuresTravaux!.substring(0, 2)) *
                widget.mission.title!.price! +
            double.parse(widget.mission.heuresTravaux!.substring(3, 5)) *
                (widget.mission.title!.price! + 0.0) /
                60;

    return salaire;
  }

  Future<void> userType() async {
    utilisateur = await ParseUser.currentUser() as ParseUser;
    //return utilisateur!.get('type') == 'Jober';
    setState(() {
      isworker = utilisateur!.get('type') == 'Jober';
    });
  }

  Future<void> getjobberrating() async {
    ratenumb =
        await RatingService().getRating(widget.mission.boss!.id) as double;
  }

  Future<void> getdistance() async {
    Map<String, double> userlocation = await getUserLocation();
    //await getLocationAccurarate();
    List<double> distances = await calculateDistance(
        userlocation['userlat']!,
        userlocation['userlong']!,
        widget.mission.location!.latitude,
        widget.mission.location!.longitude);

    setState(() {
      distanceInMeters = distances[0];
      distKilometer = distances[1];
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    getdistance();
    userType();
    getjobberrating();
  }

  @override
  void dispose() {
    controller = ScrollController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Détails de la mission",
                style: TextStyle(
                  color: ColorsConst.col_app_black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 8.0, top: 6, bottom: 6, right: 8),
              ),
            ],
          ),
          backgroundColor: ColorsConst.col_app,
          leading: Padding(
            padding:
                const EdgeInsets.only(left: 8.0, top: 6, bottom: 6, right: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: ColorsConst.col_app_f.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_outlined,
                  ),
                ),
              ),
            ),
          )),
      body: SingleChildScrollView(
        controller: controller,
        padding: EdgeInsets.only(top: 30.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "${widget.mission.title!.name}",
                      style: const TextStyle(
                        color: ColorsConst.col_app_black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "(${widget.mission.service!.name!})",
                      style: const TextStyle(
                        color: ColorsConst.col_app_black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      rectText("Salaire", "${widget.mission.totalprice}€"),
                      rectText(
                          "Heures/jour", "${widget.mission.heuresTravaux} "),
                      rectText("Place dispo", "${(widget.mission.nbWorker)}"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      rectText(
                          "Date debut",
                          widget.mission.startDate!
                              .toString()
                              .substring(0, 10)),
                      rectText("Date fin",
                          widget.mission.endDate!.toString().substring(0, 10)),
                      rectText("Pause travaux",
                          "${(widget.mission.pauseTravaux!.substring(14, 16))}min"),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10.w, top: 10.h, bottom: 10.h),
              child: Column(
                children: [
                  Align(
                    heightFactor: 3.h,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ReadMoreText(widget.mission.description!,
                      trimCollapsedText: "afficher plus",
                      trimExpandedText: "afficher moins",
                      style: TextStyle(fontSize: 18.sp)),
                  Align(
                    heightFactor: 3.h,
                    alignment: Alignment.centerLeft,
                    child: Text("Equipement",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10.w, 0),
                    decoration: BoxDecoration(
                      color: ColorsConst.col_app_f.withOpacity(0.2),

                      borderRadius: BorderRadius.circular(
                          15), // Set the borderRadius to half of the width or height for a perfect circle
                    ),
                    height: 200.h, // You can adjust this height as needed
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.mission.equipments!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Equipement_card(
                            equipement: widget.mission.equipments![index]);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    heightFactor: 3.h,
                    child: Text("mobilité :",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10.w, 0),
                    decoration: BoxDecoration(
                      color: ColorsConst.col_app_f.withOpacity(0.2),

                      borderRadius: BorderRadius.circular(
                          15), // Set the borderRadius to half of the width or height for a perfect circle
                    ),
                    height: 200.h, // You can adjust this height as needed
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.mission.mobilities!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Mobility_card(
                            mobility: widget.mission.mobilities![index]);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    heightFactor: 3.h,
                    child: Text("Address :",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.mission.address!,
                        style: TextStyle(fontSize: 20.sp)),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.mission.location!.toString(),
                        style: TextStyle(fontSize: 20.sp)),
                  ),
                  SizedBox(height: 20.h),
                  Column(
                    children: [
                      Text(
                        'Distance (Km) : ${distKilometer.toStringAsFixed(2)} km',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Distance (M) : ${distanceInMeters.toStringAsFixed(2)} m',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 70.h)
          ],
        ),
      ),
      bottomNavigationBar: isworker
          ? AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: controller.position.userScrollDirection ==
                          ScrollDirection.reverse
                      ? 0
                      : 50.h,
                  child: child,
                );
              },
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PdfPreviewPage(mission: widget.mission)));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                label: const Text("Postuler"),
                icon: const Icon(Icons.check),
                backgroundColor: ColorsConst.col_app,
              ),
            )
          : null,
    );
  }

  Widget rectText(String text1, String text2) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, top: 10.h),
      width: 110.w,
      height: 70.h,
      decoration: BoxDecoration(
        color: ColorsConst.col_app_f.withOpacity(0.2),

        borderRadius: BorderRadius.circular(
            15), // Set the borderRadius to half of the width or height for a perfect circle
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text1, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(text2),
          ],
        ),
      ),
    );
  }
}
