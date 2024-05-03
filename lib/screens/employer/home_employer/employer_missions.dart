import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/demandes.dart';
import 'package:sevenapplication/core/models/mission_model.dart';
import 'package:sevenapplication/core/services/database/demandes_services.dart';
import 'package:sevenapplication/core/services/database/mission_services.dart';
import 'package:sevenapplication/utils/static_data.dart';
import 'package:sevenapplication/widgets/cards/mission_card.dart';
import 'package:sevenapplication/widgets/custom_toggle_button.dart';

class EmployerMissions extends StatefulWidget {
  EmployerMissions({Key? key}) : super(key: key);

  @override
  State<EmployerMissions> createState() => _EmployerMissionsState();
}

class _EmployerMissionsState extends State<EmployerMissions> {
  int _currentIndex = 0;
  List<MissionModel> missions = [];
  late ParseUser utilisateur;
  bool load = true;

  late List<Demand> demList = [];

  Future<void> demanddesinit() async {
    final demands = await DemandeServices.getAllBossDemandes();
    if (!this.mounted) return;
    setState(() {
      demList = demands;
    });
  }

  getMisssions() async {
    List<MissionModel> miss = await Missionservices.fetchMissionsWithTitles();
    if (!this.mounted) return;
    setState(() {
      missions = miss;
      load = false;
    });
  }

  inituser() async {
    ParseUser? user = await ParseUser.currentUser() as ParseUser?;
    if (!this.mounted) return;
    setState(() {
      utilisateur = user!;
    });
  }

  @override
  void initState() {
    super.initState();
    getMisssions();
    inituser();
    demanddesinit();
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
            label: const ["Tous", "À venir", "En cours", "Passées"],
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
        load == true
            ? Center(
                child: CupertinoActivityIndicator(
                animating: true,
              ))
            : missions.isEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                        child: Text(
                      "Vous n'avez pas encore de missions",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  )
                : _currentIndex == 0
                    ? Column(
                        children: missions
                            .map((e) => MissionCard(e, utilisateur))
                            .toList(),
                      )
                    : _currentIndex == 1
                        ? Column(
                            children: missions
                                .where((element) =>
                                    element.status!.name == "A venir")
                                .map((e) => MissionCard(e, utilisateur))
                                .toList(),
                          )
                        : _currentIndex == 2
                            ? Column(
                                children: missions
                                    .where((element) =>
                                        element.status!.name == "En cours")
                                    .map((e) => MissionCard(e, utilisateur))
                                    .toList(),
                              )
                            : Column(
                                children: missions
                                    .where((element) =>
                                        element.status!.name == "Clôturée")
                                    .map((e) => MissionCard(e, utilisateur))
                                    .toList(),
                              ),
        SizedBox(height: 16),
      ],
    );
  }
}
