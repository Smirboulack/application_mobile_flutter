import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:iban/iban.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/BankAccount.dart';
import 'package:sevenapplication/core/services/database/bankaccount_services.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/const_app.dart';
import 'package:http/http.dart' as http;

import '../widgets/textWidgets/large_text.dart';

class UserRIB extends StatefulWidget {
  ParseUser? utilisateur;
  UserRIB({Key? key, required this.utilisateur}) : super(key: key);

  @override
  _UserRIBState createState() => _UserRIBState();
}

class _UserRIBState extends State<UserRIB> {
  final _formKey_profil = GlobalKey<FormBuilderState>();
  final Widget loadingWidget = SpinKitFadingCircle(
    color: ColorsConst.col_app,
    size: 200.0,
  );
  bool isloading = true;
  late String _ibanController;
  late String _bicController;
  late BankAccount? bankinfos;

  void initState() {
    super.initState();
    initbanksinfo();
  }

  void initbanksinfo() async {
    await getuserbanks();
    await _startLoading(Container());
  }

  Future<void> getuserbanks() async {
    bankinfos = await BankAccountService.fetchUserBankAccount();
    if (bankinfos?.iban == null) {
      bankinfos = BankAccount(iban: '', bic: '');
      setState(() {
        _ibanController = bankinfos!.iban!;
        _bicController = bankinfos!.bic!;
      });
    } else {
      setState(() {
        _ibanController = bankinfos!.iban!;
        _bicController = bankinfos!.bic!;
      });
    }
  }

  bool isValidSWIFTCode(String swiftCode) {
    final RegExp regex = RegExp(
        r'^[A-Z]{4}[-]{0,1}[A-Z]{2}[-]{0,1}[A-Z0-9]{2}[-]{0,1}[0-9]{0,3}$');
    return regex.hasMatch(swiftCode);
  }

  Future<void> submitHandler() async {
    final bankexists = await BankAccountService.checkIfUserExistsInBank(
        widget.utilisateur!.objectId!);
    if (isValid(_ibanController) && isValidSWIFTCode(_bicController)) {
      var request = http.MultipartRequest('POST', Uri.parse(ConstApp.apiURL));
      request.fields
          .addAll({'iban': _ibanController, 'api_key': ConstApp.ibanAPIKey});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());

        if (bankexists) {
          String userbankObjectID = bankinfos!.objectId!;
          await BankAccountService.updateBankAccount(
              userbankObjectID, _ibanController, _bicController);
          initbanksinfo();
          print(
              'Convert the IBAN into a standard format: ${electronicFormat(_ibanController)}');
          showmodal('Mis à jour des informations bancaire réussi.');
        } else {
          await BankAccountService.createBankAccount(
              _ibanController, _bicController);
          initbanksinfo();
          showmodal('Ajout des informations bancaire réussi.');
        }
      } else {
        showmodal(response.reasonPhrase);
      }
    } else if (!isValid(_ibanController) && !isValidSWIFTCode(_bicController)) {
      showmodal('IBAN et BIC invalide');
    } else if (!isValid(_ibanController)) {
      showmodal('IBAN invalide');
    } else if (!isValidSWIFTCode(_bicController)) {
      showmodal('BIC invalide');
    } else {
      showmodal('Erreur');
    }
  }

  void showmodal(message) {
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
                  message,
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
                    //minimumSize: Size(210, 39),
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

  Future<void> _startLoading(Widget loadingWidget) async {
    setState(() {
      isloading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      isloading = false;
    });
  }

  Future<void> _refresh() async {
    await getuserbanks();
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                loadingWidget,
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            decoration:
                BoxDecoration(color: const Color.fromARGB(255, 255, 255, 255)),
          )
        : Scaffold(
            appBar: AppBar(
                //backgroundColor: ColorsApp.primaryColors,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    if (widget.utilisateur!.get('type') == 'Boss') {
                      context.pushReplacementNamed('HomeEmployer',
                          extra: widget.utilisateur);
                    } else {
                      context.pushReplacementNamed('HomeWorker',
                          extra: widget.utilisateur);
                    }
                  },
                ),
                backgroundColor: Colors.black),
            body: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(
                  height: ScreenUtil().screenHeight * 0.05,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: LargeText(text: "Mes coordonnées bancaires")),
                SizedBox(
                  height: ScreenUtil().screenHeight * 0.05,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Compte de Dépôt',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.utilisateur!.username!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().screenHeight * 0.05,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "IBAN",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.h),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: TextFormField(
                    maxLength: 27,
                    initialValue: _ibanController ?? "",
                    //controller: _ibanController,
                    decoration: InputDecoration(
                      hintText: "Numéro IBAN à 27 caractères",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(27),
                      FormBuilderValidators.maxLength(27),
                    ]),
                    onChanged: (value) {
                      setState(() {
                        _ibanController = value;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "BIC / SWIFT",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.h),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: TextFormField(
                    maxLength: 11,
                    initialValue: _bicController ?? "",
                    decoration: InputDecoration(
                      hintText: "BIC/SWIFT à 8/11 caractères",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(8),
                      FormBuilderValidators.maxLength(11),
                    ]),
                    onChanged: (value) {
                      setState(() {
                        _bicController = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().screenHeight * 0.05,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ElevatedButton(
                    onPressed: () async {
                      await submitHandler();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(ScreenUtil().screenWidth * 0.03),
                      child: Text(
                        "Enregistrer",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        backgroundColor: Color(0xFF8CC63E),
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        )),
                  ),
                ),
              ],
            )));
  }
}
