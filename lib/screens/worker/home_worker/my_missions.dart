import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/demandes.dart';
import 'package:sevenapplication/core/models/mission_model.dart';
import 'package:sevenapplication/core/services/database/mission_services.dart';
import 'package:sevenapplication/utils/static_data.dart';
import 'package:sevenapplication/widgets/cards/mission_card.dart';
import 'package:sevenapplication/widgets/custom_toggle_button.dart';

class MyMissions extends StatefulWidget {
  ParseUser? utilisateur;
 MyMissions({Key? key, required this.utilisateur}) : super(key: key);

  @override
  State<MyMissions> createState() => _MyMissionsState();
}

class _MyMissionsState extends State<MyMissions> {
  int _currentIndex = 0;
  int nboffres = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("----------------------------");
    print(widget.utilisateur!.get('location'));
    print(widget.utilisateur!.get('objectId'));
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
            label: const ["Tous", "A venir", "En cours", "Clôturées"],
            isFirst: _currentIndex,
          ),
          if (_currentIndex == 0) _appliedList(),
          if (_currentIndex == 1) _appliedList(),
          if (_currentIndex == 2) _appliedList(),
          if (_currentIndex == 3) _appliedList(),
        ],
      ),
    );
  }

  Column _appliedList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        /* Column(
          children: missionsList.map((e) => MissionCard(e)).toList(),
        ), */
      /*  Text(
          "${nboffres} Offres",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),*/
        SizedBox(height: 16),
        FutureBuilder<List<MissionModel>>(
          future: Missionservices.myMissions(""),
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
               nboffres = missions!.length;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: missions!.length,
                  itemBuilder: (context, index) {
                    return MissionCard(missions[index] , widget.utilisateur);
                  },
                );
              } else if (_currentIndex == 1) {
                nboffres = missionAvenir.length;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: missionAvenir.length,
                  itemBuilder: (context, index) {
                    return MissionCard(missionAvenir[index] , widget.utilisateur);
                  },
                );
              } else if (_currentIndex == 2) {
                nboffres = missionEnCours.length;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: missionEnCours.length,
                  itemBuilder: (context, index) {
                    return MissionCard(missionEnCours[index] , widget.utilisateur);
                  },
                );
              } else if (_currentIndex == 3) {
                nboffres = missionCloturee.length;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: missionCloturee.length,
                  itemBuilder: (context, index) {
                    return MissionCard(missionCloturee[index] , widget.utilisateur);
                  },
                );
              } else {
                nboffres = 0;
                return const Center(
                  child: Text('Aucune mission'),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
