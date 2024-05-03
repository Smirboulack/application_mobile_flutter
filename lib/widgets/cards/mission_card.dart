import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sevenapplication/core/models/demandes.dart';
import 'package:sevenapplication/core/models/mission_model.dart';
import 'package:sevenapplication/core/services/database/database.dart';
import 'package:sevenapplication/core/services/database/demandes_services.dart';
import 'package:sevenapplication/core/services/database/mission_services.dart';
import 'package:sevenapplication/screens/employer/home_employer/demandes/demand_list_page.dart';
import 'package:sevenapplication/screens/worker/home_worker/fisrt_home_worker.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/styles.dart';
import 'package:sevenapplication/widgets/buttonWidget/custom_button.dart';
import '../../core/services/database/factures_services.dart';
import '../../screens/worker/home_worker/mission_details.dart';

class MissionCard extends StatefulWidget {
  MissionModel mission;
  ParseUser? utilisateur;
  MissionCard(this.mission, this.utilisateur, {Key? key}) : super(key: key);

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> {
  String message = '';
  List<Demand> demList = [];

  void initState() {
    init();
    super.initState();
  }

  Future<void> WorkerEnvoyerDemande() async {
    String bossID =
        await Missionservices.MissionOwnerID(widget.mission.objectId!);
    await DemandeServices.createDemande(
        widget.utilisateur!.get('objectId'), widget.mission.objectId!, bossID);
    setState(() {
      message = 'Envoyée';
    });
    await init();
    confirmationaction('Votre demande a été envoyée avec succès', '0');
  }

  Future<void> WorkerAnnulerDemande(item) async {
    Alert(
        context: context,
        title: "Annuler la candidature",
        desc:
            "Voulez-vous vraiment laisser tomber votre candidature pour cette mission ?",
        buttons: [
          DialogButton(
              color: ColorsConst.col_app,
              child: Text(
                "Confirmer",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                await DemandeServices.deleteDemande(
                    item.objectId!, widget.utilisateur!.get('objectId'));
                setState(() {
                  message = 'Postuler';
                });
                await init();
                Navigator.pop(context);
                confirmationaction(
                    'Votre candidature pour ${item.objectId!} a été annulée avec succès',
                    '1');
              }),
        ]).show();
  }

  Future<void> BossSupprimerMission(item) async {
    Alert(
        context: context,
        title: "Supprimer la mission",
        desc:
            "Voulez-vous vraiment supprimer cette mission ?\nCette action est irréversible",
        buttons: [
          DialogButton(
              color: ColorsConst.col_app,
              child: Text(
                "Confirmer",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                print("étape 2");
                await Missionservices.deleteMission(item.objectId!);
                await DemandeServices.deleteAllDemandsForMission(
                    item.objectId!);
                await FactureServices.deleteFactureByMission(widget.mission);
                await init();
                print("étape 4");
                Navigator.pop(context);
                confirmationaction(
                    'La mission ${item.objectId!} a été supprimée avec succès',
                    '1');
              }),
        ]).show();
  }

  Future<void> cloturermission() async {
    Alert(
        context: context,
        title: "Cloturer la mission",
        desc: "Voulez-vous vraiment cloturer cette mission ?",
        buttons: [
          DialogButton(
              color: ColorsConst.col_app,
              child: Text(
                "Confirmer",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                await SetMissionclotured(widget.mission.objectId);
                await init();
                Navigator.pop(context);
                avis(
                    'La mission ${widget.mission.objectId} a été cloturée avec succès',
                    '1');
              }),
        ]).show();
  }

  Future<void> init() async {
    await majDemandes();
    initMessage(widget.mission);
  }

  Future<void> majDemandes() async {
    final demands = await DemandeServices.getAllJoberDemandes();
    if (!this.mounted) return;
    setState(() {
      demList = demands;
    });
  }

  Future<void> initMessage(MissionModel? item) async {
    if (demList.length != 0) {
      if (widget.utilisateur!.get('type') == 'Jober') {
        for (int i = 0; i < demList.length; i++) {
          if (demList[i].mission.objectId == item!.objectId) {
            setState(() {
              message = 'Envoyée';
            });
            break;
          } else {
            setState(() {
              message = 'Postuler';
            });
          }
        }
      } else {
        setState(() {
          message = 'Demandes';
        });
      }
    } else {
      if (widget.utilisateur!.get('type') == 'Jober') {
        setState(() {
          message = 'Postuler';
        });
      } else {
        setState(() {
          message = 'Demandes';
        });
      }
    }
  }

  Future<void> avis(String msg, dynamic type) async {
    showModalFlash(
      barrierBlur: type == '1' ? 16 : 0,
      barrierDismissible: true,
      builder: (context, controller) => FlashBar(
        controller: controller,
        behavior: type == '1' ? FlashBehavior.floating : FlashBehavior.fixed,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color:
                type == '1' ? ColorsConst.col_app_black : ColorsConst.col_app,
            width: 2.0,
            style: type == '1' ? BorderStyle.solid : BorderStyle.none,
          ),
        ),
        margin: const EdgeInsets.all(32.0),
        clipBehavior: Clip.antiAlias,
        indicatorColor:
            type == '1' ? ColorsConst.col_app_black : ColorsConst.col_app,
        icon: Icon(
          Icons.info_outline,
          color: type == '1' ? ColorsConst.col_app_black : ColorsConst.col_app,
        ),
        title: type == '1' ? Text("Donner un avis de Jobber") : Text("Info"),
        content: RatingBar.builder(
          initialRating: 3,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
            confirmationaction(
                'La mission ${widget.mission.objectId} a été cloturée avec succès',
                '2');
          },
        ),
      ),
      context: context,
    );
  }

  Future<void> confirmationaction(String msg, dynamic type) async {
    showModalFlash(
      barrierBlur: type == '1' ? 16 : 0,
      barrierDismissible: true,
      builder: (context, controller) => FlashBar(
        controller: controller,
        behavior: type == '1' ? FlashBehavior.floating : FlashBehavior.fixed,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color:
                type == '1' ? ColorsConst.col_app_black : ColorsConst.col_app,
            width: 2.0,
            style: type == '1' ? BorderStyle.solid : BorderStyle.none,
          ),
        ),
        margin: const EdgeInsets.all(32.0),
        clipBehavior: Clip.antiAlias,
        indicatorColor:
            type == '1' ? ColorsConst.col_app_black : ColorsConst.col_app,
        icon: Icon(
          Icons.info_outline,
          color: type == '1' ? ColorsConst.col_app_black : ColorsConst.col_app,
        ),
        title: type == '1' ? Text("Suppression de la demande") : Text("Info"),
        content: Text(msg),
      ),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _cartheader(MissionModel item) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              style: TextStyle(
                  color: ColorsConst.col_app,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5.sp),
              text: item.totalprice.toString(),
              children: [
                TextSpan(
                  text: " €",
                  style: TextStyle(
                      fontSize: 15.5.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorsConst.col_app),
                ),
              ],
            ),
          )
        ],
      );
    }

    Widget _missionCartitem(MissionModel item) {
      //initstate();
      return InkWell(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            margin: EdgeInsets.only(bottom: 10, left: 12, right: 12),
            decoration: StylesApp.decoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                item.titre != ""
                    ? Text(
                        item.titre!,
                        style: StylesApp.textStyleM,
                      )
                    : Container(),
                SizedBox(
                  height: 6.h,
                ),
                Container(
                    child: Text(
                  item.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: StylesApp.textStyleM,
                )),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/job.svg",
                      width: 18.w,
                      color: ColorsConst.col_app_black,
                    ),
                    Container(
                      width: 8.w,
                    ),
                    Text(
                      item.title!.name!,
                      style: StylesApp.textStyleM,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/address.svg",
                      width: 18.w,
                      color: ColorsConst.col_app_black,
                    ),
                    Container(
                      width: 8.w,
                    ),
                    Text(
                      item.address! + "   " + item.distance!.toString(),
                      style: StylesApp.textStyleM,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Divider(
                    color: ColorsConst.col_app_black.withOpacity(0.3),
                    height: 2.5),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/time.svg",
                      width: 18.w,
                      color: ColorsConst.col_app_black,
                    ),
                    Container(
                      width: 8.w,
                    ),
                    Text(
                      "Temps de travail : " + item.heuresTravaux!,
                      style: StylesApp.textStyleM,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/cal.svg",
                      width: 18.w,
                      color: ColorsConst.col_app_black,
                    ),
                    Container(
                      width: 8.w,
                    ),
                    Text(
                      item.startDate!.day.toString() +
                          "/" +
                          item.startDate!.month.toString() +
                          "/" +
                          item.startDate!.year.toString(),
                      style: StylesApp.textStyleM,
                    ),
                    Container(
                      width: 5.h,
                    ),
                    SvgPicture.asset("assets/icons/arr.svg"),
                    Container(
                      width: 5.h,
                    ),
                    Text(
                      item.endDate!.day.toString() +
                          "/" +
                          item.endDate!.month.toString() +
                          "/" +
                          item.endDate!.year.toString(),
                      style: StylesApp.textStyleM,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _cartheader(item as MissionModel),
                        Container(
                          width: 20.w,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              /*Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => mission_details(
                                        mission: item,
                                      )));*/
                              cloturermission();
                            },
                            child: const Icon(Icons.bookmark_border_outlined,
                                color: Colors.black),
                          ),
                        ),
                        Container(width: 16),
                        Visibility(
                          visible: message == "Demandes",
                          child: IconButton(
                            onPressed: () async {
                              print("étape 1");
                              await BossSupprimerMission(item);
                            },
                            icon: Icon(
                              Icons.highlight_off,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: message == "Envoyée",
                          child: IconButton(
                            onPressed: () async {
                              await WorkerAnnulerDemande(item);
                            },
                            icon: Icon(
                              Icons.highlight_off,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                            width: 110.w,
                            child: ElevatedButton(
                              onPressed: message != "Envoyée"
                                  ? () async {
                                      if (widget.utilisateur!.get('type') ==
                                          'Jober') {
                                        await WorkerEnvoyerDemande();
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserListPage()),
                                        );
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                primary: ColorsConst.col_app,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                message,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 12,
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => mission_details(
                      mission: widget.mission,
                    )));
          });
    }

    return _missionCartitem(widget.mission);
  }
}
