import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/screens/employer/home_employer/add_mission/add_mission_firstpage.dart';
import 'package:sevenapplication/screens/employer/home_employer/employer_drawersettings.dart';
import 'package:sevenapplication/screens/employer/home_employer/employer_factures.dart';
import 'package:sevenapplication/screens/employer/home_employer/employer_missions.dart';
import 'package:sevenapplication/screens/user_settings_screen.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/const_app.dart';
import 'package:sevenapplication/utils/images.dart';
import 'package:sevenapplication/widgets/custom_navbar.dart';

class HomePageEmployer extends StatefulWidget {
  ParseUser? utilisateur;
  HomePageEmployer({Key? key, required this.utilisateur}) : super(key: key);

  @override
  State<HomePageEmployer> createState() => _HomePageEmployerState();
}

class _HomePageEmployerState extends State<HomePageEmployer> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  List<Widget> screens = [];

  void initState() {
    screens = [
      AddMissionFirstPage(),
      EmployerMissions(),
      EmployerFactures(utilisateur: widget.utilisateur),
      UserSettingsScreen(utilisateur: widget.utilisateur),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: EmployerSettingsScreen(
        utilisateur: widget.utilisateur,
      ),
      key: _key,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /* Image.asset("assets/images/jobs.png", width: 36.w), */
              Text(
                ConstApp.appName,
                style: TextStyle(
                  color: ColorsConst.col_app_black,
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 6, bottom: 6, right: 8),
                child: GestureDetector(
                    onTap: () {},
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: ColorsConst.col_app_f.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Center(
                              child: SvgPicture.asset(
                            AppImages.user,
                            color: ColorsConst.col_app_black,
                          )),
                        )))),
          ],
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding:
                const EdgeInsets.only(left: 8.0, top: 6, bottom: 6, right: 8),
            child: GestureDetector(
              onTap: () {
                _key.currentState!.openDrawer();
              },
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: ColorsConst.col_app_f.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                    child: SvgPicture.asset(
                  AppImages.menu,
                  color: ColorsConst.col_app_black,
                )),
              ),
            ),
          )),
      body: screens[_currentIndex],
      bottomNavigationBar: CustomNavBar(
        items: [
          {"name": "Ajouter mission", "icon": AppImages.plus},
          {"name": "Missions", "icon": AppImages.missions},
          {"name": "Factures", "icon": AppImages.offer},
          {"name": "Paramètres", "icon": AppImages.params}
        ],
        height: 62.h,
        currentIndex: _currentIndex,
        onItemSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
