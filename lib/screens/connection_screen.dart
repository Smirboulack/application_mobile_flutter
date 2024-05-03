import 'dart:async';

import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/services/database/database.dart';
import 'package:sevenapplication/core/services/email_services.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/email_texts.dart';
import 'package:sevenapplication/widgets/buttonWidget/primary_button.dart';
import 'package:sevenapplication/widgets/inputWidget/app_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  int connectionattempt = 0;
  bool showPassword = false;
  bool emailhaserror = false;
  bool passwordhaserror = false;
  bool _isPressed = false;
  bool _isLoading = false;
  final FocusNode _focuspassword = FocusNode();
  final FocusNode _focusemail = FocusNode();
  final _passcontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final Widget loadingWidget = const SpinKitFadingCircle(
    color: ColorsConst.col_app,
    size: 200.0,
  );
  late bool _rememberMe;

  @override
  void initState() {
    super.initState();
    _rememberMe = false;
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _formKey.currentState?.patchValue({
          'email': prefs.getString('email') ?? '',
          'password': prefs.getString('password') ?? '',
        });
      }
    });
  }

  void _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', _rememberMe);
    if (_rememberMe) {
      /* prefs.setString('username', _usernameController.text);
      prefs.setString('password', _passwordController.text); */
      prefs.setString('email', _formKey.currentState?.value['email']);
      prefs.setString('password', _formKey.currentState?.value['password']);
    } else {
      prefs.remove('username');
      prefs.remove('password');
    }
  }

  void deletesavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');
  }

  Future<void> handleLogin() async {
    String errormsg = "Aucun compte ne correspond à ces identifiants";
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    final value = _formKey.currentState?.value;
    String emailController = value?['email'];
    String passwordController = value?['password'];
    //Verifications des informations saisies
    if (emailController.isEmpty || passwordController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Vérifier si l'adresse e-mail est valide
    final email = emailController.toLowerCase();
    if (!(email.endsWith('@gmail.com') ||
        email.endsWith('@outlook.com') ||
        email.endsWith('outlook.fr') ||
        email.endsWith('hotmail.fr') ||
        email.endsWith('hotmail.com') ||
        email.endsWith('@yahoo.com') ||
        email.endsWith('@myyahoo.com') ||
        email.endsWith('@inbox.com') ||
        email.endsWith('@icloud.com') ||
        email.endsWith('@mail.com') ||
        email.endsWith('@gmx.com') ||
        email.endsWith('@zoho.com') ||
        email.endsWith('@yandex.com') ||
        email.endsWith('@office365.com') ||
        email.endsWith('@google.com') ||
        email.endsWith('@protonmail.com') ||
        email.endsWith('@aol.com') ||
        email.endsWith('sevensales.fr') ||
        email.endsWith('sevenjobs.fr') ||
        email.endsWith('@tutanota.com'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Column(
            children: [
              Text('Veuillez saisir une adresse e-mail valide'),
              Text('Exemple : @gmail.com, @outlook.com, @yahoo.com ...'),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool emailExist = await checkUserEmail(emailController);
    print("affichage de emailExist : $emailExist");
    if (!emailExist) {
      errormsg = "Aucun compte ne correspond à cet email";
    } else {
      bool passwordExist =
          await checkUserPassword(emailController, passwordController);
      if (!passwordExist) {
        errormsg = "Mot de passe incorrect";
      }
    }

    bool connection = await loginUser(emailController, passwordController);

    if (connection) {
      ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
      _saveCredentials();
      await _startLoading(2, loadingWidget);
      switch (currentUser!.get('type')) {
        case "Jober":
          context.pushReplacementNamed("HomeWorker", extra: currentUser);
          break;
        case "Boss":
          context.pushReplacementNamed("HomeEmployer", extra: currentUser);
          break;
      }
      context.showSuccessBar(
        position: FlashPosition.top,
        content: const Text('Connexion réussie !'),
        duration: const Duration(seconds: 2),
      );
    } else {
      connectionattempt++;
      if (connectionattempt >= 3) {
        await _startLoading(5, loadingWidget);
      }
      showModalFlash(
        barrierBlur: 16,
        builder: (context, controller) => FlashBar(
          controller: controller,
          behavior: FlashBehavior.floating,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            side: BorderSide(
              color: emailExist ? Colors.orange : Colors.red,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          margin: const EdgeInsets.all(32.0),
          clipBehavior: Clip.antiAlias,
          indicatorColor: emailExist ? Colors.orange : Colors.red,
          icon: Icon(
            Icons.info_outline,
            color: emailExist ? Colors.orange : Colors.red,
          ),
          title: const Text('Erreur de connexion'),
          content: Text(errormsg),
        ),
        context: context,
      );
    }
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: _isLoading
          ? Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loadingWidget,
                  SizedBox(height: screenSize.height * 0.05),
                  const Text(
                    'Connexion en cours ...',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    color: ColorsConst.colhint3,
                    width: MediaQuery.of(context).size.width,
                    height: 40.h,
                  ),
                  Container(
                      color: ColorsConst.colhint3,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                            padding: EdgeInsets.all(16.w),
                            child: Image.asset(
                              "assets/images/logo_round.png",
                              width: 76.w,
                            )),
                      )),
                  //HeaderWidget(),
                  const SizedBox(height: 24),
                  FormBuilder(
                    key: _formKey,
                    // enabled: false,
                    onChanged: () {
                      _formKey.currentState!.save();
                    },
                    //autovalidateMode: AutovalidateMode.disabled,
                    //skipDisabled: true,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Connexion",
                              style: TextStyle(
                                fontSize: screenSize.width * 0.09,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.05),
                          TextFieldWidget(
                            "Email",
                            _focusemail,
                            _emailcontroller,
                            TextInputType.emailAddress,
                            FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email(),
                            ]),
                            suffixIcon: "assets/icons/emailn.svg",
                            nameF: "email",
                            onChanged: (val) {
                              setState(() {
                                emailhaserror = !(_formKey
                                        .currentState?.fields['email']
                                        ?.validate() ??
                                    false);
                              });
                            },
                          ),
                          SizedBox(height: 16.h),
                          TextFieldWidget(
                              "Mot de passe",
                              _focuspassword,
                              _passcontroller,
                              TextInputType.text,
                              FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(8),
                              ]),
                              suffixIcon: "assets/icons/pass.svg",
                              obscure: !showPassword,
                              prefixWidget: IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: showPassword
                                      ? ColorsConst.col_app
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                              ),
                              nameF: "password", onChanged: (val) {
                            setState(() {
                              passwordhaserror = !(_formKey
                                      .currentState?.fields['password']
                                      ?.validate() ??
                                  false);
                            });
                          }),
                          SizedBox(height: screenSize.height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                side: const BorderSide(
                                    width: 1.5, color: Colors.black),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(6),
                                    bottomLeft: Radius.circular(6),
                                  ),
                                ),
                                activeColor: const Color(0xFF8CC63E),
                                checkColor: Colors.black,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                              ),
                              Text('Se souvenir de moi',
                                  style: TextStyle(
                                      fontSize: screenSize.width * 0.035,
                                      color: const Color.fromARGB(
                                          255, 44, 44, 44))),
                            ],
                          ),
                          SizedBox(height: screenSize.height * 0.05),
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    context.go('/reset_id');
                                  },
                                  child: Text(
                                    "Mot de passe oublié ?",
                                    style: TextStyle(
                                        color: ColorsConst.colhint2,
                                        fontSize: screenSize.width * 0.035),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.04),
                          Container(
                              width: 320.w,
                              child: PrimaryButton(
                                onTap: () {
                                  if (_formKey.currentState
                                          ?.saveAndValidate() ??
                                      false) {
                                    handleLogin();
                                  } else {
                                    debugPrint(_formKey.currentState?.value
                                        .toString());
                                    debugPrint('validation failed');
                                  }
                                  setState(() {
                                    _isPressed = !_isPressed;
                                  });

                                  Timer(const Duration(seconds: 1), () {
                                    setState(() {
                                      _isPressed = !_isPressed;
                                    });
                                  });
                                },
                                icon: "",
                                disabledColor: ColorsConst.borderColor,
                                fonsize: 19.0,
                                prefix: Container(),
                                color: ColorsConst.col_app,
                                isLoading: false,
                                text: "Se connecter",
                                textStyle: TextStyle(fontFamily: "InterBold"),
                              )),
                          Container(
                            height: 16.h,
                          ),
                          TextButton(
                            onPressed: () {
                              context.go('/register');
                            },
                            child: Text(
                              "Pas de compte ? S'inscrire",
                              style: TextStyle(
                                  color: ColorsConst.col_app_f,
                                  //color: ColorsConst.col_app,
                                  fontSize: 18.sp),
                            ),
                          ),

                          /*  ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.saveAndValidate() ??
                                  false) {
                                handleLogin();
                              } else {
                                debugPrint(
                                    _formKey.currentState?.value.toString());
                                debugPrint('validation failed');
                              }
                              setState(() {
                                _isPressed = !_isPressed;
                              });

                              Timer(const Duration(seconds: 1), () {
                                setState(() {
                                  _isPressed = !_isPressed;
                                });
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              fixedSize:
                                  Size.fromWidth(screenSize.width * 0.45),
                              backgroundColor: _isPressed
                                  ? const Color.fromARGB(255, 120, 153, 77)
                                  : ColorsConst.col_app,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(screenSize.width * 0.02),
                              child: Text(
                                'Se connecter',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenSize.width * 0.045,
                                ),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
