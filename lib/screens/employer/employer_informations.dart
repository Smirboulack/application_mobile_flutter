import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/entreprise.dart';
import 'package:sevenapplication/core/models/sector.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/core/services/database/database.dart';
import 'package:sevenapplication/core/services/email_services.dart';
import 'package:sevenapplication/core/services/siret_services.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/email_texts.dart';
import 'package:sevenapplication/widgets/footer_widget.dart';
import 'package:sevenapplication/widgets/header_widget.dart';
import 'package:sevenapplication/widgets/textWidgets/large_text.dart';

import '../../widgets/inputWidget/app_textfield.dart';

class SlideFromLeftPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideFromLeftPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

class SlideFromRightPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideFromRightPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

class EmployerInformation extends StatefulWidget {
  const EmployerInformation({super.key});

  @override
  State<EmployerInformation> createState() => _EmployerInformationState();
}

class _EmployerInformationState extends State<EmployerInformation> {
  final _formKey = GlobalKey<FormBuilderState>();
  final phoneNumber_Controller = TextEditingController();
  late final String regexcaracspe;
  late final String regexspace;

  late bool pseudohaserror;
  late bool pseudohasspace;
  late bool pseudohasspecialcarac;
  late bool pseudo3length;
  late bool pseudois20carac;
  late bool emailhaserror;
  late bool passwordhaserror;
  late bool passwordconfirmhaserror;
  late bool _passwordVisible;
  late bool showentrepriseformular;
  int passwordlength = 0;
  late bool _passwordhasspecialcarac;
  late bool _passwordhasnumber;
  late bool _passwordhasmaj;
  late bool _passwordhasmin;
  late bool phoneNumberhaserror;
  late bool isValidable;
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
  final siret_Controller = TextEditingController();
  late int phonenumber_length;

  void initState() {
    pseudohaserror = false;
    pseudohasspace = false;
    pseudohasspecialcarac = false;
    pseudo3length = true;
    pseudois20carac = false;
    emailhaserror = true;
    passwordhaserror = false;
    passwordconfirmhaserror = false;
    _passwordVisible = false;
    showentrepriseformular = false;
    _passwordhasspecialcarac = false;
    _passwordhasnumber = false;
    _passwordhasmaj = false;
    _passwordhasmin = false;
    regexcaracspe = r'[-!@#$%^&*(),.?":{}|<>]';
    regexspace = r'[ ]';
    phonenumber_length = 0;
    phoneNumberhaserror = true;
    isValidable = false;
    super.initState();
  }

  Future<void> handleRegister(screenSize) async {
    bool erreur = false;
    final String username = _formKey.currentState?.fields['username']?.value;
    final String email = _formKey.currentState?.fields['email']?.value;
    final String phoneNumber = _formKey.currentState?.fields['phone']?.value;
    final String password = _formKey.currentState?.fields['password']?.value;
    final String confirmPassword =
        _formKey.currentState?.fields['confirm_password']?.value;

    //Verifications des informations saisies
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
      erreur = true;
      return;
    }

    //Vérifier si le nom d'utilisateur est valide
    /*   if (pseudohaserror) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Veuillez saisir un nom d\'utilisateur valide (3 à 15 caractères, sans caractères spéciaux ni d\'espaces)'),
          backgroundColor: Colors.red,
        ),
      );
      erreur = true;
      return;
    }*/

    if (emailhaserror) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez saisir une adresse e-mail valide'),
          backgroundColor: Colors.red,
        ),
      );
      erreur = true;
      return;
    }

    //Verifier la conformité du mot de passe
    if (passwordhaserror) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Veuillez saisir un mot de passe valide (8 caractères, 1 chiffre, 1 caractère spécial, 1 majuscule, 1 minuscule , différent de l'exemple)"),
          backgroundColor: Colors.red,
        ),
      );
      erreur = true;
      return;
    }

    await checkUserEmail(email).then((value) {
      if (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Cette adresse e-mail est déjà associé à un compte ! Veuillez en choisir une autre.'),
            backgroundColor: Colors.red,
          ),
        );
        erreur = true;
        setState(() {
          emailhaserror = true;
        });
        return;
      }
    });

    await checkUserUsername(username).then((value) {
      if (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Ce nom d\'utilisateur est déjà associé à un compte ! Veuillez en choisir un autre.'),
            backgroundColor: Colors.red,
          ),
        );
        erreur = true;
        setState(() {
          pseudohaserror = true;
        });
        return;
      }
    });

    if (!erreur) {
      final User? utilisateur = User(
        id: '0',
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        type: 'Boss',
      );
      final String mdp = password;
      List<String>? listsectors = await getSectorsNames();
      Navigator.push(
          context,
          SlideFromRightPageRoute(
              page: EmployerEntrepriseInscription(
            sectors: listsectors,
            user: utilisateur,
            mdp: mdp,
          )));
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
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: <Widget>[
              //HeaderWidget(),
              SizedBox(height: screenSize.height * 0.05),
              Image.asset(
                "assets/images/Boss.png",
                width: screenSize.width / 3.5,
              ),
              SizedBox(height: screenSize.height * 0.01),
              LargeText(
                text: "Boss",
                textSize: screenSize.width * 0.05,
                textWeight: FontWeight.bold,
              ),
              SizedBox(height: screenSize.height * 0.05),
              Padding(
                padding: EdgeInsets.all(screenSize.width * 0.05),
                child: LargeText(
                  text: 'Je crée mon compte professionnel',
                  textSize: screenSize.width * 0.05,
                ),
              ),
              SizedBox(height: screenSize.height * 0.05),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                child: Column(
                  children: [
                    TextFieldWidget(
                      "Nom d'utilisateur *",
                      _focususername,
                      _usernamecontroller,
                      TextInputType.name,
                      FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(8),
                        FormBuilderValidators.maxLength(20),
                      ]),
                      suffixIcon: "assets/icons/user.svg",
                      nameF: "username",
                      onChanged: (value) {
                        if (value!.length <= 0 ||
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
                    Visibility(
                        visible: pseudohaserror,
                        child: Column(
                          children: [
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
                                  color: pseudohasspecialcarac || pseudohasspace
                                      ? Colors.red
                                      : ColorsConst.col_app,
                                ),
                                SizedBox(width: screenSize.width * 0.01),
                                Text(
                                  'Sans caractères spéciaux ni d\'espaces',
                                  style: TextStyle(
                                    color:
                                        pseudohasspecialcarac || pseudohasspace
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
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
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
                        value.endsWith('sevensales.fr') ||
                        value.endsWith('sevenjobs.fr') ||
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
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
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
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                child: TextFieldWidget(
                  "Mot de passe *",
                  _focuspassword,
                  _passcontroller,
                  TextInputType.emailAddress,
                  FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(8),
                  ]),
                  suffixIcon: "assets/icons/pass.svg",
                  obscure: !_passwordVisible,
                  prefixWidget: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color:
                          _passwordVisible ? ColorsConst.col_app : Colors.grey,
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
                        !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ||
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
                              _passwordhasmaj ? Icons.check_circle : Icons.info,
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
                              _passwordhasmin ? Icons.check_circle : Icons.info,
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
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                child: TextFieldWidget(
                  "Confirmez le mot de passe *",
                  _focusconfirmpassword,
                  _passconfirmcontroller,
                  TextInputType.text,
                  (value) =>
                      _formKey.currentState?.fields['password']?.value != value
                          ? 'Ne correspond pas au mot de passe'
                          : null,
                  suffixIcon: "assets/icons/pass.svg",
                  obscure: !_passwordVisible,
                  prefixWidget: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color:
                          _passwordVisible ? ColorsConst.col_app : Colors.grey,
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
                        _formKey.currentState?.fields['password']?.value) {
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
              SizedBox(height: screenSize.height * 0.05),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        fixedSize: Size.fromWidth(screenSize.width * 0.35),
                        backgroundColor: Colors.blueGrey[800],
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        )),
                    onPressed: () {
                      context.go('/register');
                    },
                    child: const Text('Retour'),
                  ),
                  SizedBox(width: screenSize.width * 0.15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        fixedSize: Size.fromWidth(screenSize.width * 0.35),
                        backgroundColor: ColorsConst.col_app,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        )),
                    onPressed: isValidable
                        ? () {
                            if (_formKey.currentState?.saveAndValidate() ??
                                false) {
                              handleRegister(screenSize);
                            } else {
                              debugPrint(
                                  _formKey.currentState?.value.toString());
                              debugPrint('validation failed');
                            }
                          }
                        : null,
                    child: const Text('Continuer'),
                  ),
                ],
              )),
              SizedBox(height: screenSize.height * 0.05),
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class EmployerEntrepriseInscription extends StatefulWidget {
  List<String>? sectors;
  final User? user;
  final String mdp;
  EmployerEntrepriseInscription(
      {super.key, this.sectors, this.user, required this.mdp});

  @override
  State<EmployerEntrepriseInscription> createState() =>
      _EmployerEntrepriseInscriptionState();
}

class _EmployerEntrepriseInscriptionState
    extends State<EmployerEntrepriseInscription> {
  final _formKey_entreprise = GlobalKey<FormBuilderState>();

  late final TextEditingController _addressController;

  bool _isLoading = false;
  bool phonevisible = false;
  bool isExpanded = false;
  late bool siretLoading;
  late bool _isSiretValid;
  late bool _isSiretInvalid;
  late bool phoneNumberhaserror;
  late int phonenumber_length;
  late int siret_length;
  List<dynamic> _suggestions = [];
  late String selectedSecteurActivite;
  final FocusNode _focusentrname = FocusNode();
  final _entrnamecontroller = TextEditingController();
  final FocusNode _focusadress = FocusNode();
  final FocusNode _focusinterlocuteur = FocusNode();
  final _interlocuteurcontroller = TextEditingController();
  final FocusNode _focusphone = FocusNode();
  final _phonecontroller = TextEditingController();
  final siret_Controller = TextEditingController();
  late double _latitude;
  late double _longitude;
  final Widget loadingWidget = SpinKitFadingCircle(
    color: ColorsConst.col_app,
    size: 200.0,
  );

  Future<void> _startLoading(dynamic duration, Widget loadingWidget) async {
    // Mettez ici votre logique de rafraîchissement des données
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;

    setState(() {
      _isLoading = false;
      //isButtonClickable = false;
      phonevisible = false;
      isExpanded = false;
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
      });
      final postalCode = properties['postcode'];
    } else {
      throw Exception('Failed to fetch address coordinates');
    }
  }

  void initState() {
    _addressController = TextEditingController();
    _latitude = 0.0;
    _longitude = 0.0;
    siret_length = 0;
    selectedSecteurActivite = '';
    phoneNumberhaserror = false;
    phonenumber_length = 0;
    _isLoading = false;
    siretLoading = false;
    _isSiretValid = false;
    _isSiretInvalid = false;
    super.initState();
  }

  void showmodal() {
    final ScreenSize = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: ScreenSize.width * 0.8,
            padding: EdgeInsets.all(16.0), // Ajuster les marges intérieures
            decoration: BoxDecoration(
              color: Colors.white, // Utiliser une couleur de fond claire
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/smiley.svg",
                  height: 80, // Ajuster la taille de l'icône
                  width: 80,
                ),
                SizedBox(height: 20),
                Text(
                  'Vos modifications ont été prises en compte!',
                  style: TextStyle(
                    color: Colors
                        .grey[700], // Utiliser une couleur de texte plus sombre
                    fontSize: 18,
                    fontFamily: 'Istok Web',
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(210, 39),
                    primary: ColorsConst.col_app,
                    onPrimary: Colors.white,
                    textStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showNonDismissibleModal() {
    final screenSize = MediaQuery.of(context).size;
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

  Future<void> submitHandler() async {
    String texterror = '';
    String phonenumbercontroller = _formKey_entreprise
        .currentState!.fields['phone']!.value
        .toString()
        .replaceAll(' ', '');

    String siret =
        _formKey_entreprise.currentState!.fields['siret']!.value.toString();

    if (_addressController.text == '') {
      texterror = 'Veuillez renseigner une adresse valide';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            children: [
              Text(texterror),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (phonenumbercontroller == '') {
      texterror = 'Veuillez renseigner un numéro de téléphone valide';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            children: [
              Text(texterror),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (siret.length != 14) {
      texterror = 'Veuillez renseigner un numéro de siret valide';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            children: [
              Text(texterror),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    String name = _formKey_entreprise
        .currentState!.fields['entreprisename']!.value
        .toString();
    String secteuractivite;
    selectedSecteurActivite == "Autre (préciser)"
        ? secteuractivite = _formKey_entreprise
            .currentState!.fields['autresecteuractivite']!.value
            .toString()
        : secteuractivite = selectedSecteurActivite;
    String address = _addressController.text;

    String interlocuteur =
        _formKey_entreprise.currentState!.fields['Intercoluteur']!.value;
    String phoneContact = phonenumbercontroller;

    await createUserBoss(widget.user?.username, widget.user?.email,
        widget.user?.phoneNumber, widget.mdp, widget.user?.type, null);
    await loginUser(widget.user!.email, widget.mdp);
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    String secteurId = await getIdSectorByName(secteuractivite);
    Sector secteur = Sector(name: secteuractivite, objectId: secteurId);
    String entrepriseId = await createEntreprise(
        name, secteur, address, siret, phoneContact, interlocuteur);
    Entreprise entreprise = Entreprise(
        name: name,
        address: address,
        siret: siret,
        interlocutor: interlocuteur,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        contact: phoneContact,
        objectId: entrepriseId,
        sector: secteur);
    await updateUser(
        currentUser?.get('username'),
        currentUser?.get('email'),
        currentUser?.get('password'),
        currentUser?.get('phoneNumber'),
        currentUser?.get('type'),
        entreprise);
    EmailService.sendHtmlEmail(
        recipient: currentUser?.get('email'),
        subject: "Bienvenue dans la communauté SevenJobs !",
        htmlBody: emails_register(currentUser?.get('username')));

    await _startLoading(2, loadingWidget);
    showNonDismissibleModal();
    await logoutUser();
  }

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
            ? Container(
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
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255)),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    //HeaderWidget(),
                    SizedBox(height: screenSize.height * 0.01),
                    FormBuilder(
                        key: _formKey_entreprise,
                        child: Column(
                          children: [
                            SizedBox(height: screenSize.height * 0.05),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05),
                              child: LargeText(
                                text:
                                    'Je complète les informations sur mon entreprise',
                                textSize: screenSize.width * 0.05,
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: screenSize.width * 0.05)),
                                LargeText(
                                    text: 'Entreprise',
                                    textColor: ColorsConst.col_app,
                                    textWeight: FontWeight.bold,
                                    textSize: screenSize.width * 0.05),
                              ],
                            ),
                            SizedBox(height: screenSize.height * 0.05),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05),
                              child: TextFieldWidget(
                                "Nom entreprise",
                                _focusentrname,
                                _entrnamecontroller,
                                TextInputType.name,
                                FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.minLength(1),
                                ]),
                                suffixIcon: "assets/icons/company.svg",
                                nameF: "entreprisename",
                                onChanged: (value) {
                                  setState(() {
                                    //isButtonClickable = true;
                                  });
                                  if (value == '') {
                                    setState(() {
                                      //isButtonClickable = false;
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.01),
                            Column(
                              children: [
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
                                    name: 'secteuractivite',
                                    initialValue: '',
                                    decoration: InputDecoration(
                                      labelText: 'Secteur d’activité',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                      icon: Icon(Icons.factory_outlined),
                                      iconColor: Colors.black,
                                      border: InputBorder.none,
                                    ),
                                    icon: Icon(Icons.arrow_downward),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedSecteurActivite = value!;
                                        //isButtonClickable = true;
                                      });
                                      if (value == '') {
                                        setState(() {
                                          //isButtonClickable = false;
                                        });
                                      }
                                    },
                                    items: widget.sectors!
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.01),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenSize.width * 0.05),
                                    width: screenSize.width * 0.9,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 224, 237, 255),
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Text(selectedSecteurActivite))
                              ],
                            ),
                            SizedBox(height: screenSize.height * 0.01),
                            Visibility(
                              visible:
                                  selectedSecteurActivite == 'Autre (préciser)',
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.05),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    //onPrimary: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: Size(screenSize.width * 0.9,
                                        screenSize.height * 0.01),
                                    textStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  child: FormBuilderTextField(
                                    name: 'autresecteuractivite',
                                    initialValue: '',
                                    decoration: InputDecoration(
                                      labelText: "Reprécisez le secteur",
                                      icon: Icon(Icons.factory),
                                      iconColor: Colors.black,
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                        color: ColorsConst.col_app,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {},
                                        color: Colors.black,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        //isButtonClickable = true;
                                      });
                                    },
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.01),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05),
                              child: Column(
                                children: [
                                  TextFieldWidget(
                                    "Adresse de l\'entreprise",
                                    _focusadress,
                                    _addressController,
                                    TextInputType.emailAddress,
                                    FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
                                    suffixIcon: "assets/icons/address.svg",
                                    nameF: "address",
                                    onChanged: (value) {
                                      _fetchAddressSuggestions(value);
                                      setState(() {
                                        //isButtonClickable = true;
                                      });
                                      if (value == '') {
                                        setState(() {
                                          //isButtonClickable = false;
                                        });
                                      }
                                    },
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
                            ),
                            SizedBox(height: screenSize.height * 0.01),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05),
                              child: TextFieldWidget(
                                "Intercoluteur",
                                _focusinterlocuteur,
                                _interlocuteurcontroller,
                                TextInputType.text,
                                FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                suffixIcon: "assets/icons/user.svg",
                                nameF: "Intercoluteur",
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.01),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05),
                              child: TextFieldWidget(
                                "Téléphone entreprise *",
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
                                  print(value!.length);
                                  phonenumber_length = value!.length;
                                  if (value!.length != 10) {
                                    setState(() {
                                      phoneNumberhaserror = true;
                                    });
                                  } else if (value[0] != '0') {
                                    setState(() {
                                      phoneNumberhaserror = true;
                                    });
                                  } else if (value[1] != '1' &&
                                      value[1] != '2' &&
                                      value[1] != '3' &&
                                      value[1] != '4' &&
                                      value[1] != '5' &&
                                      value[1] != '6' &&
                                      value[1] != '7') {
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
                            SizedBox(height: screenSize.height * 0.01),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05),
                              child: Column(
                                children: [
                                  FormBuilderTextField(
                                    name: 'siret',
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
                                        fillColor:
                                            ColorsConst.backTextfieldColor2,
                                        filled: true,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.r)),
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: ColorsConst
                                                  .backTextfieldColor2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.r)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: ColorsConst
                                                  .backTextfieldColor2),
                                        ),
                                        hintText: "Numéro Siret",
                                        hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: ColorsConst.colhint2,
                                        ),
                                        suffix: siret_length == 14 &&
                                                !siretLoading
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
                                                  bool verify =
                                                      await Siret_Services
                                                          .verifySiret(
                                                              siret_Controller
                                                                  .text);
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
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 0, 0, 0),
                                                ),
                                                child: Text('Vérifier',
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
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
                                                fontSize:
                                                    screenSize.width * 0.03))
                                        : Text('Entreprise non trouvée !',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize:
                                                    screenSize.width * 0.03)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.05),
                            Container(
                              padding: EdgeInsets.all(screenSize.width * 0.05),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                          backgroundColor: Colors.blueGrey[800],
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.push(
                                              context,
                                              SlideFromLeftPageRoute(
                                                  page:
                                                      const EmployerInformation()));
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Retour'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: screenSize.width * 0.05),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                          backgroundColor: siret_length == 14
                                              ? ColorsConst.col_app
                                              : Colors.grey,
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        onPressed: siret_length == 14
                                            ? () async {
                                                if (_formKey_entreprise
                                                    .currentState!
                                                    .saveAndValidate()) {
                                                  await submitHandler();
                                                } else {
                                                  print('error');
                                                }
                                              }
                                            : null,
                                        child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('Finaliser')),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    //FIN PARTIE ENTREPRISE
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, screenSize.height * 0.05, 0, 0),
                      child: const FooterWidget(),
                    ),
                  ], //FIN CHILDREN PRINCIPAL
                ), //FIN COLUMN PRINCIPAL
              ));
  }
}
