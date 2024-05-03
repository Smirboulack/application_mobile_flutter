import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sevenapplication/core/models/equipment.dart';
import 'package:sevenapplication/core/models/metier.dart';
import 'package:sevenapplication/core/models/mobility.dart';
import 'package:sevenapplication/core/models/service.dart';
import 'package:sevenapplication/core/models/status.dart';
import 'package:sevenapplication/core/models/titles.dart';
import 'package:sevenapplication/core/services/database/bankaccount_services.dart';
import 'package:sevenapplication/core/services/database/database.dart';
import 'package:sevenapplication/core/services/equipments_Services.dart';
import 'package:sevenapplication/core/services/mobility_services.dart';
import 'package:sevenapplication/screens/employer/home_employer/components/metiers_list.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/popups.dart';
import 'package:sevenapplication/utils/styles.dart';
import 'package:sevenapplication/widgets/checkboxWidget/custom_checkbox.dart';
import 'package:sevenapplication/widgets/textWidgets/large_text.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddMissionFirstPage extends StatefulWidget {
  const AddMissionFirstPage({Key? key}) : super(key: key);

  @override
  _AddMissionFirstPageState createState() => _AddMissionFirstPageState();
}

class _AddMissionFirstPageState extends State<AddMissionFirstPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final _addressController;
  final currentLength = TextEditingController();
  @override
  late bool isIconSelected;
  late bool titreannoncehaserror;
  late bool adressehaserror;
  late bool isLoading;
  late bool ispauseselected;
  late bool isdaterangeselected;
  late bool warnningdatemessage;
  late bool travailsamedi;
  late bool travaildimanche;

  late TimeOfDay heuredebutselected;
  late TimeOfDay heurefinselected;
  late TimeOfDay pauseselect;

  late double totalprice;
  static const smichoraire = 11.52;
  late double _latitude;
  late double _longitude;
  late double distanceInMeters;
  late double distKilometer;

  late int nbjourstravail;
  late int nbheurestotal;
  late int nbworker;
  int maxLength = 1500;
  Metier? metierselect;
  TitleMetier? titleMetierselect;
  ParseGeoPoint? localisation;

  late String message;
  late String metierName;
  late List<String> selectedEquipmentIds;
  late List<String> selectedMobilityIds;
  late List<Mobility> mobilityList = [];
  late List<dynamic> _suggestions = [];
  late List<Equipment> equipmentList = [];
  late DateTimeRange jourstravauxrange;

  Future<void> fetchMobilityList() async {
    final List<Mobility> fetchedMobilityList =
        await MobilityService.fetchMobilityList();
    setState(() {
      mobilityList = fetchedMobilityList;
    });
  }

  Future<void> fetchEquipmentList() async {
    final List<Equipment> fetchedEquipmentList =
        await EquipenetsServices.fetchEquipmentList();
    setState(() {
      equipmentList = fetchedEquipmentList;
    });
  }

  Future<void> _fetchAddressSuggestions(String query) async {
    final url = Uri.parse('https://api-adresse.data.gouv.fr/search/?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _suggestions = data['features'];
      });
    } else {
      throw Exception('Failed to fetch address suggestions');
    }
  }

  Future<void> _fetchAddressCoordinates(String address) async {
    final url =
        Uri.parse('https://api-adresse.data.gouv.fr/search/?q=$address');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final coordinates = data['features'][0]['geometry']['coordinates'];
      final properties = data['features'][0]['properties'];
      setState(() {
        _latitude = coordinates[1];
        _longitude = coordinates[0];
        localisation =
            ParseGeoPoint(latitude: _latitude, longitude: _longitude);
      });
      final postalCode = properties['postcode'];
    } else {
      throw Exception('Failed to fetch address coordinates');
    }
  }

  void ViderFormulaire() {
    setState(() {
      _formKey.currentState?.reset();
      _formKey.currentState?.fields['jourstravauxrange']?.didChange(null);
      _formKey.currentState?.fields['pausetravaux']?.didChange(null);
      _formKey.currentState?.fields['missionDescription']?.didChange(null);
      heuredebutselected = TimeOfDay(hour: 6, minute: 0);
      heurefinselected = TimeOfDay(hour: 10, minute: 0);
      currentLength.text = '';
      isIconSelected = !isIconSelected;
      _addressController.clear();
      adressehaserror = true;
      titreannoncehaserror = true;
      metierName = "";
      metierselect = null;
      titleMetierselect = null;
      _latitude = 0;
      _longitude = 0;
      nbjourstravail = 0;
      distanceInMeters = 0.0;
      distKilometer = 0.0;
      nbheurestotal = 1;
      ispauseselected = false;
      isdaterangeselected = false;
      travaildimanche = false;
      travailsamedi = false;
      totalprice = 0.0;
      selectedEquipmentIds = [];
      selectedMobilityIds = [];
      message = isIconSelected ? "Annuler l'ajout" : "Commencer l'ajout";
    });
  }

  void annulerAjoutDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Annuler l'ajout"),
              content:
                  Text("Voulez-vous vraiment annuler l'ajout de la mission ?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Non"),
                ),
                TextButton(
                  onPressed: () {
                    ViderFormulaire();
                    Navigator.pop(context);
                  },
                  child: Text("Oui"),
                ),
              ],
            ));
  }

  Future<void> calculnbjourstotal() async {
    DateTime start = jourstravauxrange.start;
    DateTime end = jourstravauxrange.end;

    if (start.isAfter(end)) {
      DateTime temp = start;
      start = end;
      end = temp;
    }

    List<DateTime> validDates = [];

    for (DateTime date = start;
        date.isBefore(end) || date.isAtSameMomentAs(end);
        date = date.add(Duration(days: 1))) {
      if (travailsamedi) {
        if (date.weekday == DateTime.saturday) {
          validDates.add(date);
        }
      }

      if (travaildimanche) {
        if (date.weekday == DateTime.sunday) {
          validDates.add(date);
        }
      }

      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday) {
        validDates.add(date);
      }
    }

    setState(() {
      nbjourstravail = validDates.length;
    });

    print('Le nombre de jours est $nbjourstravail');
  }

  Future<void> calculnbheurestotal() async {
    DateTime now = DateTime.now();
    DateTime startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      heuredebutselected.hour,
      heuredebutselected.minute,
    );

    DateTime endDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      heurefinselected.hour,
      heurefinselected.minute,
    );

    // Check if the end time is before the start time (work crosses midnight)
    if (endDateTime.isBefore(startDateTime)) {
      // Increment the end date by one day
      endDateTime = endDateTime.add(Duration(days: 1));
    }

    Duration duration = endDateTime.difference(startDateTime);

    if (pauseselect != null) {
      Duration durationpause =
          Duration(hours: pauseselect.hour, minutes: pauseselect.minute);
      duration = duration - durationpause;
    }

    int totalHours = duration.inHours;
    int totalMinutes = duration.inMinutes.remainder(60);

    setState(() {
      nbheurestotal = totalHours * nbjourstravail;
    });

    if (nbheurestotal == 0) {
      nbheurestotal = 1;
    }
  }

  Future<void> calculprixtotal() async {
    await calculnbjourstotal();
    await calculnbheurestotal();

    final prixmetierselected = titleMetierselect!.price;
    setState(() {
      totalprice = (prixmetierselected! * nbheurestotal) * nbworker;
    });

    if (heurefinselected.minute != 0) {
      int nbminutes = heurefinselected.minute;
      double prixminute = (prixmetierselected! / 60) * nbminutes;
      setState(() {
        totalprice = totalprice + prixminute;
      });
    }

    print('Le prix total est de $totalprice');
    print('prix du metier selectionné ${titleMetierselect!.price}');
  }

  Future<void> handleSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    final value = _formKey.currentState?.value;

    //Recuperation des toutes les valeurs du formulaire
    final titreannonce = value?['title'];
    final titlemetier = titleMetierselect;
    final Metier? metier = metierselect;
    final Service? service = await getServiceByNames(metier!.name);
    final adresse = _addressController.text;
    final dureedate = value?['date_range'];
    final datedebut = dureedate.start;
    final datefin = dureedate.end;
    final pausetravaux = value?['pausetravaux'].toString();

    print('la date de debut est $datedebut');
    print('la date de fin est $datefin');

    final Status? status = await getStatusByName('New');

    final nbworkerfinal = value?['nbworker'];
    final equipement = selectedEquipmentIds;
    final transport = value?['transport'];

    final missionDescription = value?['missionDescription'];
    //recupération de l'identifiant de l'utilisateur connecté
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;

    bool ajoutok = await createMission(
      currentUser,
      titreannonce,
      titlemetier!.objectId,
      metier.objectId,
      datedebut,
      datefin,
      adresse,
      status!.objectId,
      equipement,
      transport,
      nbheurestotal.toString(),
      nbworkerfinal,
      pausetravaux,
      missionDescription,
      localisation,
      totalprice,
    );

    if (ajoutok) {
      _formKey.currentState?.reset();
      ViderFormulaire();
      message = isIconSelected ? "Annuler l'ajout" : "Commencer l'ajout";
      CustomPopups.showmodal1(context);
    }
  }

  bool warningDateMessage() {
    if (nbjourstravail == 0 &&
        isdaterangeselected &&
        (jourstravauxrange.start.day == jourstravauxrange.end.day ||
            jourstravauxrange.end.difference(jourstravauxrange.start).inDays +
                    1 ==
                2)) {
      return true;
    }
    return false;
  }

  Future<void> weekendstates() async {
    if (jourstravauxrange.end.difference(jourstravauxrange.start).inDays + 1 ==
        1) {
      if (jourstravauxrange.start.weekday == 6) {
        setState(() {
          travailsamedi = true;
          travaildimanche = false;
        });
      } else if (jourstravauxrange.start.weekday == 7) {
        setState(() {
          travaildimanche = true;
          travailsamedi = false;
        });
      } else {
        setState(() {
          travaildimanche = false;
          travailsamedi = false;
        });
      }
    } else {
      print('hello');
      setState(() {
        travaildimanche = true;
        travailsamedi = true;
      });
    }
  }

  void initState() {
    isIconSelected = false;
    titreannoncehaserror = true;
    adressehaserror = true;
    isLoading = false;
    metierselect;
    travailsamedi = false;
    travaildimanche = false;
    ispauseselected = false;
    isdaterangeselected = false;
    warnningdatemessage = false;
    heuredebutselected = TimeOfDay(hour: 6, minute: 0);
    heurefinselected = TimeOfDay(hour: 10, minute: 0);
    pauseselect = TimeOfDay(hour: 0, minute: 0);
    jourstravauxrange =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());
    nbheurestotal = 1;
    nbjourstravail = 1;
    message = "Commencer l'ajout";
    metierName = "";
    _latitude = 0;
    _longitude = 0;
    distanceInMeters = 0.0;
    distKilometer = 0.0;
    totalprice = 0.0;
    nbworker = 1;
    currentLength.text = '';
    selectedEquipmentIds = [];
    selectedMobilityIds = [];
    mobilityList = [];
    _suggestions = [];
    equipmentList = [];
    localisation = ParseGeoPoint(latitude: _latitude, longitude: _longitude);
    _addressController = TextEditingController();
    fetchEquipmentList();
    fetchMobilityList();
    super.initState();
  }

  Future<bool> checkuserbankaccount() async {
    /* ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser!.get('rib') == null) {
      return false;
    } else {
      return true;
    } */

    final bankinfos = await BankAccountService.fetchUserBankAccount();
    if (bankinfos?.iban == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    /* final dayName = DateFormat('EEEE', 'en_EN').format(jourstravauxrange.start);
    final difference = jourstravauxrange.end.difference(jourstravauxrange.start);
    final numberOfDays = difference.inDays + 1;
    print(numberOfDays);
    print('working days  : ${jourstravauxrange.end.difference(jourstravauxrange.start).inDays}'); */
    return SafeArea(
        child: FormBuilder(
            key: _formKey,
            // enabled: false,
            onChanged: () {
              _formKey.currentState!.save();
            },
            child: Container(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorsConst.borderColor),
                      color: ColorsConst.background_c,
                      //color: ColorsConst.col_app,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/rocket.svg",
                                color: ColorsConst.col_app,
                                width: 56,
                              ),
                              Expanded(child: Container()),
                              Container(
                                child: LargeText(
                                  text: "Ajouter une mission".toUpperCase(),
                                  textSize: 16,
                                ),
                              ),
                              Container(
                                width: 30,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  if (isIconSelected) {
                                    annulerAjoutDialog();
                                  } else {
                                    bool useraccountcheck =
                                        await checkuserbankaccount();

                                    ParseUser? user =
                                        await ParseUser.currentUser();
                                    if (user!.get('entreprise') == null) {
                                      Alert(
                                          context: context,
                                          title: "Entreprise manquante",
                                          desc:
                                              "Vous devez ajouter une entreprise pour pouvoir ajouter une mission",
                                          image: SvgPicture.asset(
                                            'assets/icons/company.svg',
                                            color: Colors.black,
                                          ),
                                          buttons: [
                                            DialogButton(
                                                color: ColorsConst.col_app,
                                                child: Text(
                                                  "Ajouter",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                                onPressed: () async {
                                                  context.pushReplacementNamed(
                                                    'EmployerEntreprise',
                                                    extra: user,
                                                  );
                                                  Navigator.pop(context);
                                                })
                                          ]).show();
                                      //return;
                                    } else if (useraccountcheck == true) {
                                      setState(() {
                                        isIconSelected = !isIconSelected;
                                      });
                                    } else {
                                      Alert(
                                          context: context,
                                          title: "RIB manquant",
                                          desc:
                                              "Vous devez ajouter un rib pour pouvoir ajouter une mission",
                                          image: SvgPicture.asset(
                                            'assets/icons/coins.svg',
                                            color: Colors.black,
                                          ),
                                          buttons: [
                                            DialogButton(
                                                color: ColorsConst.col_app,
                                                child: Text(
                                                  "Ajouter",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                                onPressed: () async {
                                                  ParseUser? user =
                                                      await ParseUser
                                                          .currentUser();
                                                  if (user != null) {
                                                    context.goNamed('BankUser',
                                                        extra: user);
                                                  }
                                                  Navigator.pop(context);
                                                })
                                          ]).show();
                                      //return;
                                    }
                                  }

                                  //annulerAjout();
                                },
                                icon: !isIconSelected
                                    ? SvgPicture.asset(
                                        "assets/icons/Plus.svg",
                                        color: ColorsConst.col_app,
                                        width: 30,
                                      )
                                    : SvgPicture.asset(
                                        "assets/icons/minus.svg",
                                        color: ColorsConst.col_app,
                                        width: 30,
                                      ),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                message,
                                style: TextStyle(
                                    color: ColorsConst.col_app,
                                    fontSize: 20,
                                    fontFamily: "InterBold"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: isIconSelected,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Center(
                            child: LargeText(
                              text: "Annonce".toUpperCase(),
                              textSize: 17,
                            ),
                          ),
                          SizedBox(height: 20),
                          FormBuilderTextField(
                            name: "title",
                            // autovalidateMode: AutovalidateMode.always,
                            decoration: InputDecoration(
                              labelText: 'Titre *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelStyle: TextStyle(
                                fontSize: screenSize.width * 0.04,
                                color: Colors.black,
                              ),
                              icon: Icon(Icons.fiber_new, color: Colors.black),
                            ),
                            onChanged: (val) {
                              setState(() {
                                titreannoncehaserror = !(_formKey
                                        .currentState?.fields['title']
                                        ?.validate() ??
                                    false);
                              });
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(1),
                            ]),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 20),
                          Column(
                            children: [
                              TextField(
                                controller: _addressController,
                                onChanged: (value) {
                                  _fetchAddressSuggestions(value);
                                  setState(() {
                                    _latitude = 0.0;
                                    _longitude = 0.0;
                                    distKilometer = 0.0;
                                    distanceInMeters = 0.0;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Adresse *',
                                  labelStyle: TextStyle(
                                    //fontSize: screenSize.width * 0.04,
                                    color: Colors.black,
                                  ),
                                  hintStyle: TextStyle(
                                    fontSize: screenSize.width * 0.035,
                                  ),
                                  icon: Icon(Icons.location_on),
                                  iconColor: Colors.black,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: _suggestions.length,
                                itemBuilder: (context, index) {
                                  final suggestion = _suggestions[index]
                                      ['properties']['label'];

                                  return ListTile(
                                    title: Text(suggestion),
                                    onTap: () {
                                      _addressController.text = suggestion;
                                      setState(() {
                                        _suggestions = [];
                                      });
                                      _fetchAddressCoordinates(suggestion);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          Visibility(
                              visible:
                                  (_latitude != 0.0 || _longitude != 0.0) &&
                                      !titreannoncehaserror,
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Center(
                                    child: LargeText(
                                      text: "Durées".toUpperCase(),
                                      textSize: 17,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  FormBuilderDateRangePicker(
                                    name: 'date_range',
                                    format: DateFormat('dd-MM-yyyy'),
                                    enableInteractiveSelection: true,
                                    initialEntryMode:
                                        DatePickerEntryMode.calendar,
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime.now().add(Duration(days: 365)),
                                    decoration: InputDecoration(
                                      labelText: 'Date de début / fin *',
                                      labelStyle: TextStyle(
                                        fontSize: screenSize.width * 0.04,
                                        color: Colors.black,
                                      ),
                                      icon: Icon(Icons.calendar_month_outlined),
                                      iconColor: Colors.black,
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () async {
                                          _formKey.currentState!
                                              .fields['date_range']
                                              ?.didChange(null);
                                          setState(() {
                                            isdaterangeselected = false;
                                            travailsamedi = false;
                                            travaildimanche = false;
                                            nbjourstravail = 1;
                                            jourstravauxrange = DateTimeRange(
                                                start: DateTime.now(),
                                                end: DateTime.now());
                                          });
                                          await calculprixtotal();
                                        },
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              bottomRight:
                                                  Radius.circular(20.0),
                                              bottomLeft:
                                                  Radius.circular(20.0))),
                                    ),
                                    onChanged: (val) async {
                                      if (val != null) {
                                        DateTimeRange selectedDateRange = val;
                                        setState(() {
                                          isdaterangeselected = true;
                                          jourstravauxrange = val;
                                        });
                                        await calculprixtotal();
                                      } else {
                                        isdaterangeselected = false;
                                        await calculprixtotal();
                                      }
                                    },
                                    locale: const Locale.fromSubtags(
                                        languageCode: 'fr'),
                                  ),
                                  Visibility(
                                      visible: isdaterangeselected,
                                      child: Text(
                                          'jour(s) ouvré(s): $nbjourstravail')),
                                  Visibility(
                                    visible: warningDateMessage() &&
                                        isdaterangeselected,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          "L'intervalle de dates correspond à des jours de week-end , souhaitez-vous continuer ?",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                await weekendstates();
                                                await calculprixtotal();
                                              },
                                              style: TextButton.styleFrom(
                                                primary: ColorsConst.col_app,
                                                backgroundColor:
                                                    ColorsConst.background_c,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              child: Text('Oui'),
                                            ),
                                            SizedBox(width: 10),
                                            TextButton(
                                              onPressed: () async {
                                                annulerAjoutDialog();
                                              },
                                              style: TextButton.styleFrom(
                                                primary: ColorsConst.col_app,
                                                backgroundColor:
                                                    ColorsConst.background_c,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              child: Text('Non'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: !warningDateMessage() &&
                                        isdaterangeselected,
                                    child: Row(
                                      children: [
                                        CustomCheckbox(
                                            value: travailsamedi,
                                            onChanged: (value) async {
                                              setState(() {
                                                travailsamedi = value;
                                              });
                                              await calculprixtotal();
                                            }),
                                        SizedBox(
                                            width: ScreenUtil().setWidth(5)),
                                        Text('Travail le samedi'),
                                        CustomCheckbox(
                                            value: travaildimanche,
                                            onChanged: (value) async {
                                              setState(() {
                                                travaildimanche = value;
                                              });
                                              await calculprixtotal();
                                            }),
                                        SizedBox(
                                            width: ScreenUtil().setWidth(5)),
                                        Text('Travail le dimanche'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Visibility(
                                    visible: isdaterangeselected &&
                                        nbjourstravail > 0,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                                "Début : ${heuredebutselected.format(context)}H"),
                                            Text(
                                                "Fin : ${heurefinselected.format(context)} H"),
                                          ],
                                        ),
                                        TimeRangePicker(
                                          use24HourFormat: true,
                                          hideButtons: true,
                                          hideTimes: true,
                                          start: heuredebutselected,
                                          end: heurefinselected,
                                          selectedColor: Colors.amber,
                                          fromText: 'De',
                                          toText: 'à',
                                          ticksColor: Colors.black,
                                          ticks: 12,
                                          ticksOffset: 2,
                                          handlerRadius: 10,
                                          ticksLength: 8,
                                          rotateLabels: false,
                                          labelOffset: 20,
                                          labels: [
                                            "24 h",
                                            "3 h",
                                            "6 h",
                                            "9 h",
                                            "12 h",
                                            "15 h",
                                            "18 h",
                                            "21 h"
                                          ].asMap().entries.map((e) {
                                            return ClockLabel.fromIndex(
                                                idx: e.key,
                                                length: 8,
                                                text: e.value);
                                          }).toList(),
                                          clockRotation: 180.0,
                                          minDuration: Duration(hours: 1),
                                          maxDuration: Duration(hours: 13),
                                          labelStyle: TextStyle(
                                            fontSize: screenSize.width * 0.04,
                                            color: Colors.black,
                                          ),
                                          interval: Duration(minutes: 5),
                                          timeTextStyle: TextStyle(
                                            fontSize: screenSize.width * 0.04,
                                            color: Colors.black,
                                          ),
                                          activeTimeTextStyle: TextStyle(
                                            fontSize: screenSize.width * 0.04,
                                            color: Colors.white,
                                          ),
                                          backgroundWidget: Column(children: [
                                            Text(
                                              'Horaire journalier',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              'assets/icons/working.svg',
                                              width: ScreenUtil().setWidth(100),
                                              height:
                                                  ScreenUtil().setHeight(100),
                                              color: Colors.grey[300],
                                            ),
                                          ]),
                                          onStartChange: (val) async {
                                            setState(() {
                                              heuredebutselected = val;
                                            });
                                            await calculprixtotal();
                                          },
                                          onEndChange: (val) async {
                                            setState(() {
                                              heurefinselected = val;
                                            });
                                            await calculprixtotal();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Visibility(
                                    visible: isdaterangeselected &&
                                        nbjourstravail > 0,
                                    child: FormBuilderDateTimePicker(
                                        name: 'pausetravaux',
                                        initialTime:
                                            TimeOfDay(hour: 0, minute: 30),
                                        initialEntryMode:
                                            DatePickerEntryMode.inputOnly,
                                        inputType: InputType.time,
                                        format: DateFormat("HH:mm"),
                                        timePickerInitialEntryMode:
                                            TimePickerEntryMode.input,
                                        decoration: InputDecoration(
                                          labelText: 'Durée de la pause *',
                                          labelStyle: TextStyle(
                                            fontSize: screenSize.width * 0.04,
                                            color: Colors.black,
                                          ),
                                          icon: SvgPicture.asset(
                                            "assets/icons/break_time.svg",
                                            color: Colors.black,
                                            width: 24,
                                            height: 24,
                                            fit: BoxFit.cover,
                                          ),
                                          iconColor: Colors.black,
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(20.0),
                                                  bottomRight:
                                                      Radius.circular(20.0),
                                                  bottomLeft:
                                                      Radius.circular(20.0))),
                                        ),
                                        onChanged: (val) async {
                                          if (val != null) {
                                            setState(() {
                                              pauseselect =
                                                  TimeOfDay.fromDateTime(val);
                                              ispauseselected = true;
                                            });
                                            await calculprixtotal();
                                          } else {
                                            setState(() {
                                              ispauseselected = false;
                                            });
                                            await calculprixtotal();
                                          }
                                        }),
                                  )
                                ],
                              )),
                          Visibility(
                              visible: ispauseselected &&
                                  isdaterangeselected &&
                                  nbjourstravail > 0,
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Center(
                                    child: LargeText(
                                      text: "Information sur le poste"
                                          .toUpperCase(),
                                      textSize: 17,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                      child: Row(
                                    children: [
                                      Icon(Icons.work_outline_outlined),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: InkWell(
                                            onTap: () async {
                                              List<dynamic>? res =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MetiesList(),
                                                ),
                                              );

                                              if (res != null) {
                                                setState(() {
                                                  metierName = res.first.name +
                                                      " > " +
                                                      res[1].name;

                                                  metierselect = res.first;
                                                  titleMetierselect = res[1];
                                                });
                                              }
                                              await calculprixtotal();
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: ColorsConst
                                                        .borderColor),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20.0),
                                                    bottomRight:
                                                        Radius.circular(20.0),
                                                    bottomLeft:
                                                        Radius.circular(20.0)),
                                              ),
                                              child: Text(metierName == ""
                                                  ? "Choisir metier"
                                                  : metierName),
                                            )),
                                      ),
                                    ],
                                  )),
                                  SizedBox(height: 20),
                                  FormBuilderTextField(
                                    name: 'nbworker',
                                    maxLength: 2,
                                    decoration: InputDecoration(
                                        labelText: 'Nombre de Jobber(s) *',
                                        labelStyle: TextStyle(
                                          fontSize: screenSize.width * 0.04,
                                          color: Colors.black,
                                        ),
                                        helperText:
                                            'Valeur numérique uniquement',
                                        icon: Icon(Icons.people),
                                        iconColor: Colors.black,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                    onChanged: (val) async {
                                      setState(() {
                                        nbworker = int.parse(val!);
                                      });
                                      await calculprixtotal();
                                    },
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.numeric(),
                                      FormBuilderValidators.min(1),
                                      FormBuilderValidators.required(),
                                    ]),
                                    initialValue: nbworker.toString(),
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  FormBuilderFilterChip<String>(
                                    decoration: const InputDecoration(
                                      labelText:
                                          'Equipements et tenues à prévoir',
                                      labelStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    name: 'equipement',
                                    selectedColor: ColorsConst.col_app,
                                    checkmarkColor: Colors.black,
                                    options: equipmentList.map((equipment) {
                                      return FormBuilderChipOption(
                                        value: equipment.objectId,
                                        // Use the objectId as the value
                                        child: Text(equipment.name),
                                        // Display the equipment name
                                        avatar: CircleAvatar(
                                          child: Text(equipment.abrv),
                                          backgroundColor: Colors.white,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (List<String>? selectedValues) {
                                      if (selectedValues != null) {
                                        setState(() {
                                          selectedEquipmentIds = selectedValues;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  FormBuilderField<List<String>>(
                                    name: 'transport',
                                    initialValue: [],
                                    builder:
                                        (FormFieldState<List<String>> field) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                          labelText: 'Mobilité',
                                          labelStyle: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6),
                                              bottomLeft: Radius.circular(6),
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            for (final mobility in mobilityList)
                                              ListTile(
                                                title: Text(mobility.name),
                                                leading: Checkbox(
                                                  value: field.value?.contains(
                                                      mobility.objectId),
                                                  onChanged: (value) {
                                                    if (value == true) {
                                                      field.didChange([
                                                        ...?field.value,
                                                        mobility.objectId
                                                      ]);
                                                    } else {
                                                      field.didChange([
                                                        ...?field.value
                                                      ]..remove(
                                                          mobility.objectId));
                                                    }
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(6),
                                                      bottomRight:
                                                          Radius.circular(6),
                                                      bottomLeft:
                                                          Radius.circular(6),
                                                    ),
                                                  ),
                                                  activeColor:
                                                      Color(0xFF8CC63E),
                                                  checkColor: Colors.black,
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                    decoration: StylesApp.decoration,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Description de la mission : ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 12),
                                        FormBuilderTextField(
                                          name: 'missionDescription',
                                          controller: currentLength,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText:
                                                'Ecrivez ici toutes les informations utiles à la mission',
                                          ),
                                          onChanged: (val) {
                                            setState(() {});
                                          },
                                          maxLines: 5,
                                        ),
                                        // Widget pour afficher le nombre de caractères saisis
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            '${_formKey.currentState?.fields['missionDescription']?.value?.length ?? 0}/$maxLength',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Center(
                                    child: LargeText(
                                      text: "Récapitulatif".toUpperCase(),
                                      textSize: 17,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorsConst.borderColor),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0),
                                          bottomLeft: Radius.circular(20.0)),
                                    ),
                                    child: Column(children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            Icon(Icons.calendar_today),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                'Métier : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Text(
                                              titleMetierselect == null
                                                  ? ""
                                                  : '${titleMetierselect!.name}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            Icon(Icons.people),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                'Jobber(s): ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Text(
                                              "$nbworker",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            Icon(Icons.calendar_today),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                'Total heure(s) : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Text(
                                              '$nbheurestotal h',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            Icon(Icons.euro),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                'Total à payer : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Text(
                                              '${NumberFormat.currency(locale: 'fr_FR', symbol: '').format(totalprice)} €',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]),
                                  ),
                                  SizedBox(height: 20),
                                  Visibility(
                                    visible: titleMetierselect == null,
                                    child: Text(
                                      "Veuillez choisir un métier",
                                      style: TextStyle(
                                          //fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ),
                                  Visibility(
                                    visible: nbworker == 0,
                                    child: Text(
                                      "Le nombre de Jobber(s) doit être de 1 au minimum",
                                      style: TextStyle(
                                          //fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ),
                                  Visibility(
                                      visible: currentLength.text.length == 0 ||
                                          currentLength.text.length > maxLength,
                                      child: Text(
                                          currentLength.text.length == 0
                                              ? "Veuillez entrer une brève description de la mission"
                                              : currentLength.text.length >
                                                      maxLength
                                                  ? "Vous avez dépassé le nombre de caractères autorisés"
                                                  : "",
                                          style: TextStyle(
                                              //fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red))),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            annulerAjoutDialog();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            backgroundColor:
                                                Colors.grey.shade700,
                                          ),
                                          // color: Theme.of(context).colorScheme.secondary,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              'Annuler',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: currentLength
                                                          .text.length !=
                                                      0 &&
                                                  currentLength.text.length <
                                                      maxLength &&
                                                  titleMetierselect != null &&
                                                  nbworker > 0 &&
                                                  totalprice != 0.0
                                              ? () {
                                                  if (_formKey.currentState
                                                          ?.saveAndValidate() ??
                                                      false) {
                                                    handleSubmit();
                                                  } else {
                                                    debugPrint(_formKey
                                                        .currentState?.value
                                                        .toString());
                                                    debugPrint(
                                                        'validation failed');
                                                  }
                                                }
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            backgroundColor:
                                                ColorsConst.col_app,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: const Text(
                                              'Créer mission',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 50),
                                ],
                              )),
                        ],
                      ))
                ],
              ),
            )));
  }
}
