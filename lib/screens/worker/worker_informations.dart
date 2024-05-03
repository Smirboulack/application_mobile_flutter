// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/entreprise.dart';
import 'package:sevenapplication/core/models/service.dart';
import 'package:sevenapplication/core/services/database/database.dart';
import 'package:sevenapplication/core/services/email_services.dart';
import 'package:sevenapplication/core/services/siret_services.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/const_app.dart';
import 'package:sevenapplication/utils/email_texts.dart';
import 'package:sevenapplication/widgets/checkboxWidget/custom_checkbox.dart';
import 'package:sevenapplication/widgets/footer_widget.dart';
import 'package:sevenapplication/widgets/header_widget.dart';
import 'package:sevenapplication/widgets/textWidgets/large_text.dart';

import '../../widgets/inputWidget/app_textfield.dart';

class WorkerInformation extends StatefulWidget {
  const WorkerInformation({super.key});

  @override
  State<WorkerInformation> createState() => _WorkerInformationState();
}

class _WorkerInformationState extends State<WorkerInformation> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final String regexcaracspe;
  late final String regexspace;
  late String selectedSecteurActivite;
  late bool isButtonClickable;
  late bool pseudohaserror;
  late bool pseudohasspace;
  late bool pseudohasspecialcarac;
  late bool pseudo3length;
  late bool pseudois20carac;
  late bool emailhaserror;
  late bool phoneNumberhaserror;
  late bool passwordhaserror;
  late bool passwordconfirmhaserror;
  late bool _passwordVisible;
  late bool _passwordhasspecialcarac;
  late bool _passwordhasnumber;
  late bool _passwordhasmaj;
  late bool _passwordhasmin;
  late bool isValidable;
  late bool _isLoading;
  late bool _isSpecialiteselect;
  late bool autoentreprise;
  late bool siretLoading;
  late bool _isSiretValid;
  late bool _isSiretInvalid;
  late int passwordlength;
  late TextEditingController siret_Controller;
  late int siret_length;
  late int phonenumber_length;
  List<String>? listsectors;
  String selectedspecialite = '';
  final _addressController = TextEditingController();
  late List<dynamic> _suggestions = [];
  double _latitude = 0.0;
  double _longitude = 0.0;
  List<String>? specialitesnames = [];
  ParseGeoPoint? localisation;
  final FocusNode _focususername = FocusNode();
  final _usernamecontroller = TextEditingController();
  final FocusNode _focusemail = FocusNode();
  final _emailcontroller = TextEditingController();
  final FocusNode _focusphone = FocusNode();
  final _phonecontroller = TextEditingController();
  final FocusNode _focuspassword = FocusNode();
  final _passcontroller = TextEditingController();
  final FocusNode _focusconfirmpassword = FocusNode();
  final _passconfirmcontroller = TextEditingController();
  final FocusNode _focusadress = FocusNode();
  final Widget loadingWidget =
      SpinKitFadingCircle(color: ColorsConst.col_app, size: 200.0);

  Future<void> initSpecialites() async {
    specialitesnames = await getAllServiceNames();
    setState(() {
      specialitesnames = specialitesnames;
    });
  }

  Future<void> _startLoading(dynamic duration, Widget loadingWidget) async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: duration));
    setState(() {
      _isLoading = false;
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

        print(localisation);
      });
      final postalCode = properties['postcode'];
    } else {
      throw Exception('Failed to fetch address coordinates');
    }
  }

  void initState() {
    initSpecialites();
    pseudohaserror = false;
    pseudohasspace = false;
    pseudohasspecialcarac = false;
    pseudo3length = true;
    pseudois20carac = false;
    emailhaserror = true;
    phoneNumberhaserror = true;
    phonenumber_length = 0;
    passwordhaserror = false;
    passwordconfirmhaserror = false;
    _passwordVisible = false;
    passwordlength = 0;
    _passwordhasspecialcarac = false;
    _passwordhasnumber = false;
    _passwordhasmaj = false;
    _passwordhasmin = false;
    _isLoading = false;
    autoentreprise = false;
    _isSpecialiteselect = false;
    isValidable = false;
    isButtonClickable = false;
    siretLoading = false;
    _isSiretValid = false;
    _isSiretInvalid = false;
    siret_Controller = TextEditingController();
    siret_length = 0;
    regexcaracspe = r'[-!@#$%^&*(),.?":{}|<>]';
    regexspace = r'[ ]';
    listsectors = [];
    selectedSecteurActivite = '';

    super.initState();
  }

  void showNonDismissibleModal(screenSize) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Désactiver la fermeture en cliquant en dehors du dialog
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: screenSize.width * 0.8,
            height: screenSize.height * 0.4,
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(screenSize.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/smiley.svg",
                    width: screenSize.width * 0.1,
                    height: screenSize.height * 0.1,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Text(
                    'Votre compte a été créé avec succès !',
                    style: TextStyle(
                      color: Color(0xFF5C5C5C),
                      fontSize: screenSize.width * 0.05,
                      fontFamily: 'Istok Web',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenSize.height * 0.05),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      primary: Color(0xFF8CC63E),
                      onPrimary: Colors.white,
                      textStyle: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      fixedSize: Size.fromWidth(screenSize.width * 0.5),
                    ),
                    onPressed: () {
                      // Se connecter
                      context.go('/connection');
                    },
                    child: Padding(
                      padding: EdgeInsets.all(screenSize.width * 0.02),
                      child: Text("Se connecter"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> handleRegister(screenSize) async {
    final String username = _formKey.currentState?.fields['username']?.value;
    final String email = _formKey.currentState?.fields['email']?.value;
    final String phoneNumber = _formKey.currentState?.fields['phone']?.value;
    final String password = _formKey.currentState?.fields['password']?.value;
    final String confirmPassword =
        _formKey.currentState?.fields['confirm_password']?.value;
    final Service? service = selectedspecialite != ''
        ? await getServiceByNames(selectedspecialite)
        : null;
    final Service? service2 = service;
    /*
    if (service != null) {
      final Service? service2 = Service(
        objectId: service!.objectId,
        name: service.name,
        titles: service.titles,
        /* createdAt: service.createdAt,
      updatedAt: service.updatedAt, */
      );
    } else {
      final Service? service2 = null;
    }
*/
    if (username.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (emailhaserror) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez saisir une adresse e-mail valide'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (passwordhaserror) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Veuillez saisir un mot de passe valide (8 caractères, 1 chiffre, 1 caractère spécial, 1 majuscule, 1 minuscule , différent de l'exemple)"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String response = '';

    if (autoentreprise) {
      await createEntreprise(
          username, null, '', siret_Controller.text, phoneNumber, username);
      Entreprise autoEntreprise =
          await getEntrepriseBySiret(siret_Controller.text);

      response = await createAutoEntrepreneurJobber(
          username,
          email,
          phoneNumber,
          password,
          'Jober',
          null,
          service2,
          autoEntreprise.objectId,
          localisation!);
    } else {
      response = await createJobber(username, email, phoneNumber, password,
          'Jober', null, service2, localisation!);
    }

    if (response == '') {
      await _startLoading(2, loadingWidget);
      showNonDismissibleModal(screenSize);
    } else if (response == "Account already exists for this username.") {
      setState(() {
        pseudohaserror = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Ce nom d\'utilisateur existe déjà ! Veuillez en choisir un autre.'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (response == "Account already exists for this email address.") {
      setState(() {
        emailhaserror = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Cette adresse e-mail existe déjà ! Veuillez en choisir une autre.'),
        backgroundColor: Colors.red,
      ));
    } else if (response == "Account already exists for this phone number.") {
      setState(() {
        phoneNumberhaserror = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Ce numéro de téléphone existe déjà ! Veuillez en choisir un autre.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Une erreur est survenue ! Veuillez réessayer.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenSize.height * 0.11,
        backgroundColor: const Color.fromARGB(172, 238, 238, 238),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Center(
          child: Container(
            padding: EdgeInsets.only(top: 10.h, bottom: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/jobs3.png',
                  width: 50.w,
                ),
                Container(
                  width: 6.w,
                ),
                Text(
                  'SEVEN JOBS',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.05,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loadingWidget,
                    SizedBox(height: screenSize.height * 0.05),
                    Text(
                      'Inscription en cours ...',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    //HeaderWidget(),
                    SizedBox(height: screenSize.height * 0.05),
                    Image.asset(
                      "assets/images/Jober.png",
                      width: screenSize.width / 3.5,
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    LargeText(
                      text: "Jobber",
                      textSize: screenSize.width * 0.05,
                      textWeight: FontWeight.bold,
                    ),
                    SizedBox(height: screenSize.height * 0.05),
                    Padding(
                      padding: EdgeInsets.all(screenSize.width * 0.05),
                      child: LargeText(
                        text: 'Je crée mon compte',
                        textSize: screenSize.width * 0.05,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.05),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.05),
                      child: Column(
                        children: [
                          TextFieldWidget(
                            "Nom d'utilisateur *",
                            _focususername,
                            _usernamecontroller,
                            TextInputType.name,
                            FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            suffixIcon: "assets/icons/user.svg",
                            nameF: "username",
                            onChanged: (value) {
                              if (value!.length < 3 ||
                                  value.length > 20 ||
                                  value.contains(RegExp(regexcaracspe)) ||
                                  value.contains(RegExp(regexspace))) {
                                setState(() {
                                  pseudohaserror = true;
                                  if (value.length < 3) {
                                    pseudo3length = true;
                                  } else {
                                    pseudo3length = false;
                                  }
                                  if (value.contains(RegExp(regexcaracspe))) {
                                    pseudohasspecialcarac = true;
                                  } else {
                                    pseudohasspecialcarac = false;
                                  }
                                  if (value.contains(RegExp(regexspace))) {
                                    pseudohasspace = true;
                                  } else {
                                    pseudohasspace = false;
                                  }
                                });
                              } else {
                                setState(() {
                                  pseudohaserror = false;
                                  pseudo3length = false;
                                  pseudois20carac = false;
                                  pseudohasspecialcarac = false;
                                  pseudohasspace = false;
                                });
                              }
                            },
                          ),
                          //SizedBox(height: screenSize.height * 0.01),
                          Visibility(
                              visible: pseudohaserror,
                              child: Column(
                                children: [
                                  SizedBox(height: screenSize.height * 0.01),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        pseudo3length
                                            ? Icons.error
                                            : Icons.check_circle,
                                        size: screenSize.width * 0.04,
                                        color: pseudo3length
                                            ? Colors.red
                                            : ColorsConst.col_app,
                                      ),
                                      SizedBox(width: screenSize.width * 0.01),
                                      Text(
                                        'Au moins 3 caractères',
                                        style: TextStyle(
                                          color: pseudo3length
                                              ? Colors.red
                                              : ColorsConst.col_app,
                                          fontSize: screenSize.width * 0.03,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        pseudohasspecialcarac || pseudohasspace
                                            ? Icons.error
                                            : Icons.check_circle,
                                        size: screenSize.width * 0.04,
                                        color: pseudohasspecialcarac ||
                                                pseudohasspace
                                            ? Colors.red
                                            : ColorsConst.col_app,
                                      ),
                                      SizedBox(width: screenSize.width * 0.01),
                                      Text(
                                        'Sans caractères spéciaux ni d\'espaces',
                                        style: TextStyle(
                                          color: pseudohasspecialcarac ||
                                                  pseudohasspace
                                              ? Colors.red
                                              : ColorsConst.col_app,
                                          fontSize: screenSize.width * 0.03,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.05),
                      child: TextFieldWidget(
                        "Email *",
                        _focusemail,
                        _emailcontroller,
                        TextInputType.emailAddress,
                        FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ]),
                        suffixIcon: "assets/icons/emailn.svg",
                        nameF: "email",
                        onChanged: (value) {
                          if (!(value!.endsWith('@gmail.com') ||
                              value.endsWith('@outlook.com') ||
                              value.endsWith('outlook.fr') ||
                              value.endsWith('hotmail.fr') ||
                              value.endsWith('hotmail.com') ||
                              value.endsWith('@yahoo.com') ||
                              value.endsWith('@myyahoo.com') ||
                              value.endsWith('@inbox.com') ||
                              value.endsWith('@icloud.com') ||
                              value.endsWith('@mail.com') ||
                              value.endsWith('@gmx.com') ||
                              value.endsWith('@zoho.com') ||
                              value.endsWith('@yandex.com') ||
                              value.endsWith('@office365.com') ||
                              value.endsWith('@google.com') ||
                              value.endsWith('@protonmail.com') ||
                              value.endsWith('@aol.com') ||
                              value.endsWith('sevenjobs.fr') ||
                              value.endsWith('sevensales.fr') ||
                              value.endsWith('@tutanota.com'))) {
                            setState(() {
                              emailhaserror = true;
                            });
                          } else {
                            setState(() {
                              emailhaserror = false;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.05),
                      child: TextFieldWidget(
                        "Numéro mobile *",
                        _focusphone,
                        _phonecontroller,
                        TextInputType.phone,
                        FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ]),
                        suffixIcon: "assets/icons/call.svg",
                        nameF: "phone",
                        onChanged: (value) {
                          phonenumber_length = value!.length;
                          if (value!.length != 10) {
                            setState(() {
                              phoneNumberhaserror = true;
                            });
                          } else if (value[0] != '0') {
                            setState(() {
                              phoneNumberhaserror = true;
                            });
                          } else if (value[1] != '6' && value[1] != '7') {
                            setState(() {
                              phoneNumberhaserror = true;
                            });
                          } else if (value.contains(' ') ||
                              value.contains('-') ||
                              value.contains('.') ||
                              value.contains(',')) {
                            setState(() {
                              phoneNumberhaserror = true;
                            });
                          } else {
                            setState(() {
                              phoneNumberhaserror = false;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomCheckbox(
                            value: _isSpecialiteselect,
                            onChanged: (value) async {
                              setState(() {
                                _isSpecialiteselect = value;
                              });
                            },
                          ),
                          SizedBox(width: screenSize.width * 0.01),
                          Text(
                            "Je choisis ma spécialité",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: screenSize.width * 0.03,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !_isSpecialiteselect,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: Text(
                            'En choisissant votre spécialité, vous serrez plus succeptible de recevoir des offres de missions vous correspondant.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: screenSize.width * 0.03,
                            ),
                          )),
                    ),
                    Visibility(
                      visible: _isSpecialiteselect,
                      child: Column(
                        children: [
                          SizedBox(height: screenSize.height * 0.02),
                          Container(
                            width: screenSize.width * 0.9,
                            padding: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.025),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.black),
                            ),
                            child: FormBuilderDropdown(
                              name: 'specialite',
                              decoration: InputDecoration(
                                labelText: 'Specialité *',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                icon: Icon(Icons.fingerprint),
                                iconColor: Colors.black,
                                border: InputBorder.none,
                              ),
                              icon: Icon(Icons.arrow_downward),
                              onChanged: (value) {
                                setState(() {
                                  selectedspecialite = value!;
                                });
                              },
                              items: specialitesnames!
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                        ],
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomCheckbox(
                            value: autoentreprise,
                            onChanged: (value) async {
                              listsectors = await getSectorsNames();
                              setState(() {
                                autoentreprise = value;
                                siret_Controller.clear();
                                siret_length = 0;
                              });
                            },
                          ),
                          SizedBox(width: screenSize.width * 0.01),
                          Text(
                            "Je suis auto-entrepreneur",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: screenSize.width * 0.03,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: autoentreprise,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.05),
                        child: Column(
                          children: [
                            FormBuilderTextField(
                              name: "siret",
                              keyboardType: TextInputType.number,
                              controller: siret_Controller,
                              maxLength: 14,
                              decoration: InputDecoration(
                                  prefixIcon: Container(
                                    padding: EdgeInsets.only(
                                      top: 12.w,
                                      bottom: 12.w,
                                    ),
                                    child: Icon(
                                      Icons.assured_workload_outlined,
                                      color: ColorsConst.col_app,
                                      size: 26.w,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  contentPadding: EdgeInsets.all(16.0.w),
                                  fillColor: ColorsConst.backTextfieldColor2,
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.r)),
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: ColorsConst.backTextfieldColor2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.r)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: ColorsConst.backTextfieldColor2),
                                  ),
                                  hintText: "Numéro Siret",
                                  hintStyle: TextStyle(
                                    fontSize: 14.0,
                                    color: ColorsConst.colhint2,
                                  ),
                                  suffix: siret_length == 14 && !siretLoading
                                      ? TextButton(
                                          onPressed: () async {
                                            setState(() {
                                              siretLoading = true;
                                              _isSiretValid = false;
                                              _isSiretInvalid = false;
                                            });
                                            await Siret_Services
                                                .generateAccessToken();
                                            await Future.delayed(
                                                Duration(seconds: 2));
                                            bool verify = await Siret_Services
                                                .verifySiret(
                                                    siret_Controller.text);
                                            if (verify) {
                                              setState(() {
                                                siretLoading = false;
                                                _isSiretInvalid = false;
                                                _isSiretValid = true;
                                              });
                                            } else {
                                              setState(() {
                                                siretLoading = false;
                                                _isSiretValid = false;
                                                _isSiretInvalid = true;
                                              });
                                            }
                                          },
                                          style: TextButton.styleFrom(
                                            primary: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 0, 0, 0),
                                          ),
                                          child: Text('Vérifier',
                                              style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                              )),
                                        )
                                      : siretLoading
                                          ? CupertinoActivityIndicator(
                                              animating: true,
                                            )
                                          : null),
                              onChanged: (value) {
                                setState(() {
                                  siret_length = value!.length;
                                  siretLoading = false;
                                  _isSiretValid = false;
                                  _isSiretInvalid = false;
                                });
                              },
                            ),
                            Visibility(
                              visible: _isSiretValid || _isSiretInvalid,
                              child: _isSiretValid
                                  ? Text('Entreprise trouvée !',
                                      style: TextStyle(
                                          color: ColorsConst.col_app,
                                          fontSize: screenSize.width * 0.03))
                                  : Text('Entreprise non trouvée !',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: screenSize.width * 0.03)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.05),
                      child: TextFieldWidget(
                        "Mot de passe *",
                        _focuspassword,
                        _passcontroller,
                        TextInputType.text,
                        FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(8),
                        ]),
                        suffixIcon: "assets/icons/pass.svg",
                        obscure: !_passwordVisible,
                        prefixWidget: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: _passwordVisible
                                ? ColorsConst.col_app
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        nameF: "password",
                        onChanged: (value) {
                          passwordlength = value!.length;
                          _passwordhasmaj = value.contains(RegExp(r'[A-Z]'));
                          _passwordhasmin = value.contains(RegExp(r'[a-z]'));
                          _passwordhasnumber = value.contains(RegExp(r'[0-9]'));
                          _passwordhasspecialcarac =
                              value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
                          if (value!.length < 8 ||
                              !value.contains(RegExp(r'[0-9]')) ||
                              !value.contains(RegExp(r'[A-Z]')) ||
                              !value.contains(RegExp(r'[a-z]')) ||
                              !value.contains(
                                  RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ||
                              value == "ZZ98sq2!") {
                            setState(() {
                              passwordhaserror = true;
                            });
                          } else {
                            setState(() {
                              passwordhaserror = false;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    Visibility(
                      visible: passwordhaserror,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _passwordhasspecialcarac
                                        ? Icons.check_circle
                                        : Icons.info,
                                    color: _passwordhasspecialcarac
                                        ? ColorsConst.col_app
                                        : Colors.red,
                                  ),
                                  SizedBox(width: screenSize.width * 0.01),
                                  Text(
                                    "1 Caractère spécial !@#\$%^&*(.) ",
                                    style: TextStyle(
                                      color: _passwordhasspecialcarac
                                          ? ColorsConst.col_app
                                          : Colors.red,
                                      fontSize: screenSize.width * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    passwordlength >= 8
                                        ? Icons.check_circle
                                        : Icons.info,
                                    color: passwordlength >= 8
                                        ? ColorsConst.col_app
                                        : Colors.red,
                                  ),
                                  SizedBox(width: screenSize.width * 0.01),
                                  Text(
                                    "8 Caractères",
                                    style: TextStyle(
                                      color: passwordlength >= 8
                                          ? ColorsConst.col_app
                                          : Colors.red,
                                      fontSize: screenSize.width * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    _passwordhasmaj
                                        ? Icons.check_circle
                                        : Icons.info,
                                    color: _passwordhasmaj
                                        ? ColorsConst.col_app
                                        : Colors.red,
                                  ),
                                  SizedBox(width: screenSize.width * 0.01),
                                  Text(
                                    "1 Majuscule",
                                    style: TextStyle(
                                      color: _passwordhasmaj
                                          ? ColorsConst.col_app
                                          : Colors.red,
                                      fontSize: screenSize.width * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    _passwordhasmin
                                        ? Icons.check_circle
                                        : Icons.info,
                                    color: _passwordhasmin
                                        ? ColorsConst.col_app
                                        : Colors.red,
                                  ),
                                  SizedBox(width: screenSize.width * 0.01),
                                  Text(
                                    "1 Minuscule",
                                    style: TextStyle(
                                      color: _passwordhasmin
                                          ? ColorsConst.col_app
                                          : Colors.red,
                                      fontSize: screenSize.width * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    _passwordhasnumber
                                        ? Icons.check_circle
                                        : Icons.info,
                                    color: _passwordhasnumber
                                        ? ColorsConst.col_app
                                        : Colors.red,
                                  ),
                                  SizedBox(width: screenSize.width * 0.01),
                                  Text(
                                    "1 Chiffre",
                                    style: TextStyle(
                                      color: _passwordhasnumber
                                          ? ColorsConst.col_app
                                          : Colors.red,
                                      fontSize: screenSize.width * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.05),
                      child: TextFieldWidget(
                        "Confirmez le mot de passe *",
                        _focusconfirmpassword,
                        _passconfirmcontroller,
                        TextInputType.text,
                        (value) =>
                            _formKey.currentState?.fields['password']?.value !=
                                    value
                                ? 'Ne correspond pas au mot de passe'
                                : null,
                        suffixIcon: "assets/icons/pass.svg",
                        obscure: !_passwordVisible,
                        prefixWidget: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: _passwordVisible
                                ? ColorsConst.col_app
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        nameF: "confirm_password",
                        onChanged: (value) {
                          if (value !=
                              _formKey
                                  .currentState?.fields['password']?.value) {
                            setState(() {
                              passwordconfirmhaserror = true;
                              isValidable = false;
                            });
                          } else {
                            setState(() {
                              passwordconfirmhaserror = false;
                              isValidable = true;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: TextFieldWidget(
                            "Addresse",
                            _focusadress,
                            _addressController,
                            TextInputType.streetAddress,
                            FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            suffixIcon: "assets/icons/address.svg",
                            nameF: "address",
                            onChanged: (value) {
                              _fetchAddressSuggestions(value);
                              setState(() {
                                _latitude = 0.0;
                                _longitude = 0.0;
                              });
                            },
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _suggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion =
                                _suggestions[index]['properties']['label'];

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
                    SizedBox(height: screenSize.height * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              fixedSize:
                                  Size.fromWidth(screenSize.width * 0.35),
                              backgroundColor: Colors.blueGrey[800],
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              )),
                          onPressed: () {
                            context.go('/register');
                          },
                          child: Text('Retour'),
                        ),
                        SizedBox(width: screenSize.width * 0.15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              fixedSize:
                                  Size.fromWidth(screenSize.width * 0.35),
                              backgroundColor: ColorsConst.col_app,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              )),
                          onPressed: isValidable &&
                                  (siret_length == 14 || !autoentreprise)
                              ? () {
                                  if (_formKey.currentState
                                          ?.saveAndValidate() ??
                                      false) {
                                    handleRegister(screenSize);
                                  } else {
                                    debugPrint(_formKey.currentState?.value
                                        .toString());
                                    debugPrint('validation failed');
                                  }
                                }
                              : null,
                          child: Text('Inscription'),
                        ),
                      ],
                    ),
                    SizedBox(height: screenSize.height * 0.05),
                    FooterWidget(),
                  ],
                ),
              ),
            ),
    );
  }
}
