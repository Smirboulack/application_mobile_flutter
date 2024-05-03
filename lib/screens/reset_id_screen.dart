import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:sevenapplication/core/services/database/database.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/const_app.dart';
import 'package:sevenapplication/widgets/textWidgets/large_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

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

class EmailButtonBloc extends Cubit<bool> {
  EmailButtonBloc() : super(true);
  int actualCountdown = 0;
  static const int totalSeconds = 60;

  void startCountdown() {
    emit(false);
    actualCountdown = totalSeconds;

    Timer.periodic(Duration(seconds: 1), (timer) {
      actualCountdown--;
      if (actualCountdown <= 0) {
        emit(true);
        timer.cancel();
      }
    });
  }

  int getcurrentCountdown() {
    return actualCountdown;
  }
}

class ResetIds extends StatefulWidget {
  const ResetIds({super.key});

  @override
  State<ResetIds> createState() => _ResetIdsState();
}

class _ResetIdsState extends State<ResetIds> {
  bool isClickedEmail = false;
  bool isClickedSms = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenSize.height / 10,
        backgroundColor: Colors.black,
        title: Text(
          'Connexion',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenSize.width / 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            context.push('/connection');
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
          Container(
            child: Column(
              children: [
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Reinitialisation de votre mot de passe',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenSize.width / 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Choisissez votre méthode',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenSize.width / 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
          SizedBox(
            height: screenSize.height / 10,
          ),
          Container(
            child: Center(
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(20),
                    color: isClickedEmail
                        ? Colors.white
                        : Color.fromARGB(255, 0, 0, 0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          isClickedEmail = !isClickedEmail;
                        });
                        Navigator.push(context,
                            SlideFromRightPageRoute(page: EmailMethodPage()));
                      },
                      child: Container(
                        width: screenSize.width / 1.5,
                        height: screenSize.height / 5,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/email2.svg',
                                width: screenSize.width / 1,
                                height: screenSize.width / 4.5,
                                color: isClickedEmail
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              SizedBox(height: screenSize.height / 50),
                              Text(
                                'EMAIL',
                                style: TextStyle(
                                  color: isClickedEmail
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: screenSize.width / 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Material(
                    borderRadius: BorderRadius.circular(20),
                    color: isClickedSms
                        ? Colors.white
                        : Color.fromARGB(255, 160, 160, 160),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          isClickedSms = !isClickedSms;
                        });
                        /* Navigator.push(context,
                            SlideFromRightPageRoute(page: SmsMethodPage())); */
                      },
                      child: Container(
                        width: screenSize.width / 1.5,
                        height: screenSize.height / 5,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/sms.svg',
                                width: screenSize.width / 1,
                                height: screenSize.width / 4.5,
                                color:
                                    isClickedSms ? Colors.black : Colors.white,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'SMS',
                                style: TextStyle(
                                  color: isClickedSms
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: screenSize.width / 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(child: Text('Indisponible')),
                ],
              ),
            ),
          ),
          SizedBox(height: screenSize.height / 10),
        ],
      ),
    );
  }
}

class EmailMethodPage extends StatefulWidget {
  const EmailMethodPage({super.key});

  @override
  State<EmailMethodPage> createState() => _EmailMethodPageState();
}

class _EmailMethodPageState extends State<EmailMethodPage> {
  final _formKeyEmail = GlobalKey<FormBuilderState>();
  final EmailButtonBloc _emailButtonBloc = EmailButtonBloc();
  bool emailSent = false;
  bool emailnotreceived = false;
  int _secondsRemaining = 60;
  late Timer _timer;

  Future<void> submitHandlerResetByMail() async {
    final String email = _formKeyEmail.currentState!.value['email'];
    print(email);
    await resetPassword(_formKeyEmail.currentState!.value['email']);
    setState(() {
      emailSent = true;
    });
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_secondsRemaining == 0) {
        _timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenSize.height / 10,
        backgroundColor: Colors.black,
        title: Text(
          'Choix de la méthode',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenSize.width / 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.push(context, SlideFromLeftPageRoute(page: ResetIds()));
          },
        ),
      ),
      body: !emailSent
          ? SingleChildScrollView(
              child: FormBuilder(
                  key: _formKeyEmail,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: screenSize.height / 20),
                      Container(
                          child: SvgPicture.asset(
                        'assets/icons/email2.svg',
                        width: screenSize.width / 2,
                        height: screenSize.width / 2,
                      )),
                      SizedBox(height: screenSize.height / 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: FormBuilderTextField(
                          name: 'email',
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 156, 156, 156),
                              fontSize: screenSize.width / 25,
                              fontFamily: ConstApp.fontfamily,
                            ),
                            icon: Icon(
                              Icons.email,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              size: screenSize.width / 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email(),
                          ]),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          /* if (_formKeyEmail.currentState!.saveAndValidate()) {
                          print(_formKeyEmail.currentState!.value);
                          submitHandlerResetByMail();
                        } else {
                          print('validation failed');
                        } */
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  width: screenSize.width * 0.8,
                                  padding: EdgeInsets.all(
                                      16.0), // Ajuster les marges intérieures
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .white, // Utiliser une couleur de fond claire
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/emojisad.svg",
                                        height:
                                            80, // Ajuster la taille de l'icône
                                        width: 80,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Le service de reinitialisation de mot de passe est momentanément indisponible. Veuillez réessayer plus tard.',
                                        style: TextStyle(
                                          color: Colors.grey[
                                              700], // Utiliser une couleur de texte plus sombre
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          minimumSize: Size(210, 39),
                                          primary: const Color.fromARGB(
                                              255, 0, 0, 0),
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
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            backgroundColor: Colors.blue,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Valider',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenSize.width / 30,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height / 10),
                    ],
                  )),
            )
          : SingleChildScrollView(
              child: Column(children: [
                Center(
                  child: Container(
                      margin: EdgeInsets.only(top: screenSize.height / 10),
                      child: SvgPicture.asset(
                        'assets/icons/email3.svg',
                        width: screenSize.width / 1.5,
                        height: screenSize.width / 1.5,
                        color: ColorsConst.col_app,
                      )),
                ),
                SizedBox(height: screenSize.height / 30),
                Center(
                    child: Container(
                  margin: EdgeInsets.only(
                      left: screenSize.width / 10,
                      right: screenSize.width / 10),
                  child: Text(
                    'Un email contenant un lien vers la reinitialisation de votre mot de passe vous a été envoyé à l\'adresse : ${_formKeyEmail.currentState!.value['email']}',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 95, 95, 95),
                      fontSize: screenSize.width / 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: ConstApp.fontfamily,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
                SizedBox(height: screenSize.height / 30),
                Visibility(
                  visible: !emailnotreceived,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        emailnotreceived = true;
                      });
                    },
                    child: Text(
                      'Je n\'ai pas reçu l\'email ...',
                      style: TextStyle(
                        color: Color.fromARGB(255, 253, 101, 0),
                        fontSize: screenSize.width / 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: ConstApp.fontfamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Visibility(
                    visible: emailnotreceived,
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                              margin:
                                  EdgeInsets.only(top: screenSize.height / 25),
                              child: BlocBuilder<EmailButtonBloc, bool>(
                                bloc: _emailButtonBloc,
                                builder: (context, isEnabled) {
                                  return ElevatedButton(
                                    onPressed: isEnabled
                                        ? () {
                                            _emailButtonBloc.startCountdown();
                                            startTimer();
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        fixedSize: Size.fromWidth(200),
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        'Renvoyer l\'email',
                                        style: TextStyle(
                                          color: Colors.white,
                                          //fontSize: screenSize.width / 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: ConstApp.fontfamily,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )),
                        ),
                        Center(
                            child: Container(
                          child: BlocBuilder<EmailButtonBloc, bool>(
                            bloc: _emailButtonBloc,
                            builder: (context, isEnabled) {
                              return Column(
                                children: [
                                  Text(
                                    isEnabled ? '' : 'Email Renvoyé',
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 95, 95, 95),
                                      fontSize: screenSize.width / 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: ConstApp.fontfamily,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    isEnabled
                                        ? ''
                                        : 'Prochain envoi possible dans $_secondsRemaining secondes',
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 95, 95, 95),
                                      fontSize: screenSize.width / 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: ConstApp.fontfamily,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              );
                            },
                          ),
                        )),
                      ],
                    )),
                SizedBox(height: screenSize.height / 10),
                Center(
                    child: Container(
                  child: TextButton(
                    onPressed: () {
                      context.go('/connection');
                    },
                    child: Text(
                      'Retour à la connexion',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: screenSize.width / 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: ConstApp.fontfamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ))
              ]),
            ),
    );
  }
}

class SmsMethodPage extends StatefulWidget {
  const SmsMethodPage({super.key});

  @override
  State<SmsMethodPage> createState() => _SmsMethodPageState();
}

class _SmsMethodPageState extends State<SmsMethodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: LargeText(text: 'SMS'),
          ),
        ],
      ),
    );
  }
}
