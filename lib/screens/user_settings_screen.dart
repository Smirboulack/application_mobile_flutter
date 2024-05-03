import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sevenapplication/screens/employer/home_employer/pages/about_us.dart';
import 'package:sevenapplication/screens/employer/home_employer/pages/conditions.dart';
import 'package:sevenapplication/screens/employer/home_employer/pages/politique.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/widgets/horizontal_options.dart';
import 'package:sevenapplication/widgets/profile_image_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/services/database/mission_services.dart';

class UserSettingsScreen extends StatefulWidget {
  ParseUser? utilisateur;

  UserSettingsScreen({Key? key, required this.utilisateur}) : super(key: key);

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  int totalMissionsCount = 0;
  int cancelledMissionsCount = 0;
  int closedMissionsCount = 0;

  List<Map> drawerItems = [
    {'icon': "assets/icons/user.svg", 'title': 'Profil'},
    {'icon': "assets/icons/followers.svg", 'title': 'Suivez-nous sur :'},
    {'icon': "assets/icons/chat-alt4.svg", 'title': 'Contactez-nous'},
    {'icon': "assets/icons/share.svg", 'title': "Partager l'application"},
    {'icon': "assets/icons/pr.svg", 'title': 'Politique de confidentialité'},
    {'icon': "assets/icons/docs.svg", 'title': 'CGU'},
    {'icon': "assets/icons/infos.svg", 'title': 'À propos de nous'},
    {'icon': "assets/icons/infos.svg", 'title': 'Déconnexion'},
  ];

  Future<void> _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void initState() {
    super.initState();
    fetchCounts(); // Fetch the counts when the widget is initialized
  }

  Future<void> fetchCounts() async {
    totalMissionsCount =
        await Missionservices.countMissionsOwnedByCurrentUser();
    cancelledMissionsCount =
        await Missionservices.countCancelledMissionsForCurrentUser();
    closedMissionsCount =
        await Missionservices.countClosedMissionsForCurrentUser();
    setState(() {}); // Update the state to trigger a UI refresh
  }

  @override
  Widget build(BuildContext context) {
    disconnect() {
      Alert(
          context: context,
          title: "Déconnexion",
          desc: "Voulez-vous vraiment vous déconnecter de l'application ?",
          buttons: [
            DialogButton(
                color: ColorsConst.col_app,
                child: Text(
                  "Confirmer",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () async {
                  Navigator.pop(context);

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  //prefs.clear();
                  prefs.setString("Slides", "yess");
                  final useroo = widget.utilisateur;
                  var re = await useroo!.logout();
                  context.go('/connection');
                })
          ]).show();
    }

    go(url) {
      Navigator.push(context,
          MaterialPageRoute<String>(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(''),
          ),
          body: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        );
      }));
    }

    return SafeArea(
      child: Scrollbar(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ProfileImageView(utilisateur: widget.utilisateur),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.utilisateur!.get('username'),
                              style: TextStyle(
                                color: ColorsConst.col_app_black,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildIcon('assets/icons/cal.svg'),
                                _buildIcon('assets/icons/address.svg'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(
                    thickness: 1,
                    color: ColorsConst.col_app_black.withOpacity(0.3),
                  ),
                  const SizedBox(height: 24),
                  widget.utilisateur!.get('type') == 'Boss'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildAccountText(
                                totalMissionsCount.toString(), 'Missions'),
                            _buildAccountText(
                                closedMissionsCount.toString(), 'Cloturées'),
                            _buildAccountText(
                                cancelledMissionsCount.toString(), 'Annulées'),
                          ],
                        )
                      : const SizedBox(height: 1),
                  const SizedBox(height: 40),
                  Column(
                    children: drawerItems
                        .map((element) => InkWell(
                            onTap: () {
                              if (element["title"] == "Profil") {
                                context.goNamed("ProfilEmployer",
                                    extra: widget.utilisateur);
                              } else if (element["title"] == "Contactez-nous") {
                                _openUrl('mailto:example@sevenjobs.com');
                              } else if (element["title"] ==
                                  "Politique de confidentialité") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Potique(),
                                  ),
                                );
                              } else if (element["title"] == "CGU") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Conditions(),
                                  ),
                                );
                              } else if (element["title"] ==
                                  "Voter l’application") {
                                go("");
                              } else if (element["title"] == "Déconnexion") {
                                disconnect();
                              } else if (element["title"] ==
                                  "À propos de nous") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AboutUs(),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                                padding: EdgeInsets.only(bottom: 28.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 6.w,
                                        ),
                                        SvgPicture.asset(
                                          element['icon'],
                                          color: ColorsConst.col_app,
                                          width: 24.w,
                                        ),
                                        SizedBox(
                                          width: 18.w,
                                        ),
                                        Text(element['title'],
                                            style: TextStyle(
                                                color:
                                                    ColorsConst.col_app_black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.5.sp))
                                      ],
                                    ),
                                    element["title"] == "Suivez-nous sur :"
                                        ? Container(
                                            padding: EdgeInsets.only(
                                                top: 8, bottom: 4),
                                            child: HorizontalOptions())
                                        : Container()

                                    /*  Container(height: 8.h,),
                              Container(
                                margin: EdgeInsets.only(left: 6.w),
                                height: 6,width: 20.w,color: Fonts.col_green,)*/
                                  ],
                                ))))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildAccountText(String number, String text) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: ColorsConst.col_app_black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: ColorsConst.col_app_black,
          ),
        ),
      ],
    );
  }

  Container _buildIcon(String icon) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorsConst.col_app_black.withOpacity(0.3),
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          icon,
          color: ColorsConst.col_app_black,
        ),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 12),
    );
  }
}
