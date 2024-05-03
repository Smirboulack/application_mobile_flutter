import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/mission_model.dart';
import 'package:sevenapplication/core/services/database/mission_services.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/widgets/cards/mission_card.dart';

class SearchMissionsPage extends StatefulWidget {
  SearchMissionsPage(this.text, {Key? key}) : super(key: key);
  String text;

  @override
  _SearchMissionsPageState createState() => _SearchMissionsPageState();
}

class _SearchMissionsPageState extends State<SearchMissionsPage> {
  List<MissionModel> missionsResults = [];
  ParseUser? currentUser;

  bool load = true;

  getMissions() async {
    currentUser = await ParseUser.currentUser() as ParseUser?;
    List<MissionModel> pr = await Missionservices.get_search(widget.text);
    if (!mounted) return;
    setState(() {
      missionsResults = pr;
      print(missionsResults);
      load = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getMissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.text)),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 40.h),
        Container(
          width: 280.w,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Résultat de recherche : ${widget.text}",
            style: const TextStyle(
              color: ColorsConst.col_app_black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.90,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        Expanded(
            child: load == false
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return MissionCard(missionsResults[index], currentUser);
                    },
                    itemCount: missionsResults.length,
                    shrinkWrap: true,
                  )
                : const Center(
                    child: CupertinoActivityIndicator(),
                  ))
      ]),
    );
  }
}
