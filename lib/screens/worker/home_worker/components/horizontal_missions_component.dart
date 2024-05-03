import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/demandes.dart';
import 'package:sevenapplication/core/models/mission_model.dart';
import 'package:sevenapplication/core/services/database/demandes_services.dart';
import 'package:sevenapplication/widgets/cards/mission_card.dart';
import 'package:sevenapplication/widgets/widget_line_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorizontalMissionsList extends StatefulWidget {
  final ParseUser? utilisateur;
  final List<String> options;
  final Future<List<MissionModel>> missions;
  double lat = 0.0;
  double lng = 0.0;

  HorizontalMissionsList(
      {Key? key,
      required this.missions,
      required this.options,
      required this.utilisateur,
      required this.lat,
      required this.lng})
      : super(key: key);

  @override
  State<HorizontalMissionsList> createState() => _HorizontalMissionsListState();
}

class _HorizontalMissionsListState extends State<HorizontalMissionsList> {
  final controller = ScrollController();

  int _currentIndex = 0;
  int _currentMissionIndex = 0;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 34,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemCount: widget.options.length,
            itemBuilder: (_, index) => WidgetLineIndicator(
              isCurrentItem: _currentIndex == index,
              text: widget.options[index],
              index: index,
              onTap: (int i) {
                setState(() {
                  _currentIndex = i;
                  _currentMissionIndex = i;
                });
              },
            ),
          ),
        ),
        SizedBox(
            height: 310.h,
            child: FutureBuilder<List<MissionModel>>(
                future: widget.missions,
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
                    final missionAvenir = missions!
                        .where((element) => element.status!.name == "A venir")
                        .toList();
                    final missionEnCours = missions!
                        .where((element) => element.status!.name == "En cours")
                        .toList();
                    final missionCloturee = missions!
                        .where((element) => element.status!.name == "Clôturée")
                        .toList();

                    if (_currentIndex == 0) {
                      return ListView.builder(
                          controller: controller,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          scrollDirection: Axis.horizontal,
                          itemCount: missions!.length,
                          itemBuilder: (_, index) {
                            Distance distance = Distance();
                            missions[index].distance = distance
                                    .as(
                                        LengthUnit.Kilometer,
                                        LatLng(widget.lat, widget.lng),
                                        LatLng(
                                            missions[index].location!.latitude,
                                            missions[index]
                                                .location!
                                                .longitude))
                                    .toString() +
                                " Kms";

                            return MissionCard(
                                missions[index], widget.utilisateur);
                          });
                    } else if (_currentIndex == 1) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: missionAvenir!
                              .map((mission) =>
                                  MissionCard(mission, widget.utilisateur))
                              .toList(),
                        ),
                      );
                    } else if (_currentIndex == 2) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: missionEnCours!
                              .map((mission) =>
                                  MissionCard(mission, widget.utilisateur))
                              .toList(),
                        ),
                      );
                    } else if (_currentIndex == 3) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: missionCloturee!
                              .map((mission) =>
                                  MissionCard(mission, widget.utilisateur))
                              .toList(),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        controller: controller,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: missions!.length,
                        itemBuilder: (_, index) =>
                            MissionCard(missions[index], widget.utilisateur),
                      );
                    }
                  }
                }))
      ],
    );
  }
}
