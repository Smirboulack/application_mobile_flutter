import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/services/database/bankaccount_services.dart';
import 'package:sevenapplication/core/services/database/database.dart';
import 'package:sevenapplication/core/services/database/mission_services.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/widgets/header_widget.dart';
import 'package:sevenapplication/widgets/textWidgets/large_text.dart';

class EmployerProfil extends StatefulWidget {
  ParseUser? utilisateur;
  EmployerProfil({Key? key, required this.utilisateur}) : super(key: key);

  @override
  _EmployerProfilState createState() => _EmployerProfilState();
}

class _EmployerProfilState extends State<EmployerProfil> {
  final _formKey_profil = GlobalKey<FormBuilderState>();
  late bool phonevisible;
  late bool _passwordVisible;
  late bool _passwordcaracVisible;
  late bool passwordhaserror;
  late bool passwordconfirmhaserror;
  late bool _isLoading;
  late bool isButtonClickable;
  late bool pseudohaserror;
  late bool pseudo3length;
  late bool pseudohasspecialcarac;
  late bool pseudohasspace;
  late bool _passwordhasmaj;
  late bool _passwordhasmin;
  late bool _passwordhasnumber;
  late bool _passwordhasspecialcarac;
  late bool phoneholder;
  late bool emailhaserror;
  late String regexcaracspe;
  late String regexspace;
  late bool phoneNumberhaserror;
  late int phonenumber_length;
  XFile? imageactu;
  XFile? imagepreview;
  int passwordlength = 0;

  @override
  void initState() {
    super.initState();
    phonevisible = false;
    _passwordVisible = false;
    _passwordcaracVisible = false;
    passwordhaserror = false;
    passwordconfirmhaserror = false;
    _isLoading = false;
    isButtonClickable = false;
    pseudohaserror = false;
    pseudo3length = false;
    pseudohasspecialcarac = false;
    pseudohasspace = false;
    int passwordlength = 0;
    _passwordhasmaj = false;
    _passwordhasmin = false;
    _passwordhasnumber = false;
    _passwordhasspecialcarac = false;
    emailhaserror = false;
    phoneholder = true;
    regexcaracspe = r'[!@#$%^&*(),.?":{}|<>]';
    regexspace = r'\s';
    imageactu = widget.utilisateur!.get('Avatar') != null
        ? XFile(widget.utilisateur!.get('Avatar')!.url)
        : null;
    imagepreview = null;
    phoneNumberhaserror = false;
    phonenumber_length = widget.utilisateur!.get('phoneNumber')!.length;
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
            padding:
                const EdgeInsets.all(16.0), // Ajuster les marges intérieures
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: ColorsConst.col_app,
                    minimumSize: const Size(210, 39),
                    textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Ok"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void confirmSuppr() {
    final ScreenSize = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/trash.svg",
                  height: 80,
                  width: 80,
                  color: Colors
                      .red, // Changer la couleur de l'icône pour correspondre à la suppression
                ),
                const SizedBox(height: 20),
                Text(
                  'Êtes-vous sûr de vouloir supprimer votre compte ?',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18,
                    fontFamily: 'Istok Web',
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.red,
                        minimumSize: const Size(100, 39),
                        textStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        deleteaccount();
                      },
                      child: const Text("Supprimer"),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.grey[400],
                        minimumSize: const Size(100, 39),
                        textStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Annuler"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showmodalSuppr() {
    final ScreenSize = MediaQuery.of(context).size;
    showDialog(
      context: context,
      barrierDismissible:
          false, // Désactiver la fermeture en cliquant en dehors du dialog
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8.0, // Ajouter une ombre pour un effet de profondeur
          backgroundColor:
              Colors.transparent, // Permet de personnaliser la couleur de fond
          child: Container(
            width: ScreenSize.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.blueGrey[
                  800], // Utiliser une couleur plus foncée pour le fond
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(ScreenSize.width * 0.05),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Réduire l'espace vertical
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/trash.svg",
                    color: Colors.white,
                    height: 50, // Ajuster la taille de l'icône
                    width: 50,
                  ),
                  SizedBox(height: ScreenSize.height * 0.03),
                  const Text(
                    'Votre compte a été supprimée!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Istok Web',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _refreshPage() async {
    // Mettez ici votre logique de rafraîchissement des données
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    ParseUser? currentUserUpdated = await ParseUser.currentUser() as ParseUser?;
    widget.utilisateur = currentUserUpdated;
    showmodal();
    setState(() {
      _isLoading = false;
      phonevisible = false;
      _passwordVisible = false;
      _passwordcaracVisible = false;
      passwordhaserror = false;
      passwordconfirmhaserror = false;
      _isLoading = false;
      isButtonClickable = false;
      pseudohaserror = false;
      pseudo3length = false;
      pseudohasspecialcarac = false;
      pseudohasspace = false;
      passwordlength = 0;
      _passwordhasmaj = false;
      _passwordhasmin = false;
      _passwordhasnumber = false;
      _passwordhasspecialcarac = false;
      phoneholder = true;
    });
  }

  Future<void> submitProfilHandler() async {
    String nomuser = _formKey_profil.currentState!.fields['username']!.value;
    String phonenumero = _formKey_profil.currentState!.fields['phone']!.value;
    String emailuser = _formKey_profil.currentState!.fields['email']!.value;
    String? passworduser;
    if (passwordlength != 0) {
      passworduser = _formKey_profil.currentState!.fields['password']?.value;
    } else {
      passworduser = null;
    }

    if (phoneNumberhaserror) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur : Votre numéro de téléphone est invalide.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (pseudohaserror) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur : Votre pseudo est invalide.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (passwordhaserror) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur : Votre mot de passe est invalide.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (emailhaserror) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur : Votre email est invalide.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    await updateBoss(nomuser, passworduser, emailuser, phonenumero);
    _refreshPage();
  }

  Future<void> deleteaccount() async {
    try {
      await BankAccountService.deleteBankAccount(widget.utilisateur!.objectId!);
      await Missionservices.deleteAllUserMissions();
      await deleteUser(widget.utilisateur!);
      await logoutUser();
      showmodalSuppr();
      await Future.delayed(const Duration(seconds: 2));
      context.go('/');
    } catch (e) {
      print('Erreur lors de la suppression :  $e');
    }
  }

  Future<void> CheckUserInfoChanges(change) async {
    if (change == 1) {
      final pseudo = _formKey_profil.currentState!.fields['username']!.value;
      if (pseudo == widget.utilisateur!.username) {
        setState(() {
          isButtonClickable = false;
        });
      }
    } else if (change == 2) {
      final email = _formKey_profil.currentState!.fields['email']!.value;
      if (email == widget.utilisateur!.emailAddress) {
        setState(() {
          isButtonClickable = false;
        });
      }
    } else if (change == 3) {
      final phone = _formKey_profil.currentState!.fields['phone']!.value;
      if (phone == widget.utilisateur!.get('phoneNumber')) {
        setState(() {
          isButtonClickable = false;
        });
      }
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          //imageactu = image;
          imagepreview = image;
        });
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          //pickedFile = image;
          //imageactu = image;
          imagepreview = image;
        });
      }
      //await addUserAvatar(imageactu!);
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    //print("type de imageavatar : ${imageavatar.runtimeType}");
    //print(imageactu);
    return Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: ColorsConst.col_app,
                ),
              )
            : RefreshIndicator(
                onRefresh: _refreshPage,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const HeaderWidget(),
                      FormBuilder(
                        key: _formKey_profil,
                        child: Column(
                          children: [
                            SizedBox(height: screenSize.height * 0.05),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ColorsConst.col_app,
                                    width: 10,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 102, 102, 102),
                                      blurRadius: 2,
                                      offset: Offset(4, 5),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: screenSize.width / 5,
                                  backgroundColor: Colors.white,
                                  child: imageactu != null
                                      ? CircleAvatar(
                                          radius: screenSize.width / 5,
                                          backgroundImage: NetworkImage(widget
                                              .utilisateur!
                                              .get('Avatar')
                                              .url),
                                        )
                                      : imagepreview != null
                                          ? CircleAvatar(
                                              radius: screenSize.width / 5,
                                              backgroundImage: FileImage(
                                                  File(imagepreview!.path)),
                                            )
                                          : SvgPicture.asset(
                                              "assets/icons/profil_holder.svg",
                                              width: screenSize.width * 0.1,
                                              height: screenSize.height * 0.5),
                                  /* SvgPicture.asset(
                                              "assets/icons/profil_holder.svg",
                                              width: screenSize.width * 0.1,
                                              height: screenSize.height * 0.5) */

                                  /* CircleAvatar(
                                          radius: screenSize.width / 5,
                                          backgroundImage: NetworkImage(widget
                                              .utilisateur!
                                              .get('Avatar')
                                              .url),
                                        ), */
                                ),
                              ),
                            ),
                            Visibility(
                              visible:
                                  imageactu != null && imagepreview == null,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await deleteUserAvatar();
                                  setState(() {
                                    imageactu = null;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fixedSize: Size(screenSize.width * 0.1,
                                      screenSize.width * 0.1),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/cross.svg',
                                    width: screenSize.width * 0.05,
                                    height: screenSize.width * 0.05,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: imagepreview != null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await addUserAvatar(imagepreview!);
                                      setState(() {
                                        imageactu = imagepreview;
                                        imagepreview = null;
                                      });
                                      _refreshPage();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fixedSize: Size(screenSize.width * 0.1,
                                          screenSize.width * 0.1),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/check.svg',
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        imagepreview = null;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fixedSize: Size(screenSize.width * 0.1,
                                          screenSize.width * 0.1),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/cross.svg',
                                        width: screenSize.width * 0.05,
                                        height: screenSize.width * 0.05,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenSize.height * 0.01),
                                ],
                              ),
                            ),
                            Visibility(
                              visible:
                                  imageactu == null && imagepreview == null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: screenSize.height * 0.01),
                                  Ink(
                                    decoration: const ShapeDecoration(
                                      color: Colors
                                          .white, // Change the color to your desired background color
                                      shape: CircleBorder(),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        pickImageC();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            12.0), // Adjust the padding as needed
                                        child: SvgPicture.asset(
                                          'assets/icons/Cameraa.svg',
                                          width: screenSize.width * 0.1,
                                          height: screenSize.width * 0.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenSize.width * 0.05),
                                  Ink(
                                    decoration: const ShapeDecoration(
                                      color: Colors
                                          .white, // Change the color to your desired background color
                                      shape: CircleBorder(),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        pickImage();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            12.0), // Adjust the padding as needed
                                        child: SvgPicture.asset(
                                          'assets/icons/choosepicture.svg',
                                          width: screenSize.width * 0.1,
                                          height: screenSize.width * 0.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenSize.height * 0.05),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05),
                              child: LargeText(
                                text: 'Profil',
                                textSize: screenSize.width * 0.05,
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.05),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05),
                              child: Column(children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    //onPrimary: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: const Size(210, 39),
                                    textStyle: const TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  child: FormBuilderTextField(
                                    name: 'username',
                                    maxLength: 15,
                                    initialValue: widget.utilisateur!.username,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.person),
                                      border: InputBorder.none,
                                      iconColor: Colors.black,
                                      labelText: "Nom d'utilisateur *",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                    ),
                                    onChanged: (value) async {
                                      setState(() {
                                        isButtonClickable = true;
                                      });
                                      if (value!.length < 3 ||
                                          value.length > 20 ||
                                          value.contains(
                                              RegExp(regexcaracspe)) ||
                                          value.contains(RegExp(regexspace))) {
                                        setState(() {
                                          pseudohaserror = true;
                                          if (value.length < 3) {
                                            pseudo3length = true;
                                          } else {
                                            pseudo3length = false;
                                          }
                                          if (value.contains(
                                              RegExp(regexcaracspe))) {
                                            pseudohasspecialcarac = true;
                                          } else {
                                            pseudohasspecialcarac = false;
                                          }
                                          if (value
                                              .contains(RegExp(regexspace))) {
                                            pseudohasspace = true;
                                          } else {
                                            pseudohasspace = false;
                                          }
                                        });
                                      } else {
                                        CheckUserInfoChanges(1);
                                        setState(() {
                                          pseudohaserror = false;
                                          pseudo3length = false;
                                          pseudohasspecialcarac = false;
                                          pseudohasspace = false;
                                        });
                                      }
                                    },
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                      FormBuilderValidators.minLength(3),
                                      FormBuilderValidators.maxLength(15),
                                    ]),
                                    keyboardType: TextInputType.text,
                                  ),
                                ),
                                Visibility(
                                    visible: pseudohaserror,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height: screenSize.height * 0.01),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                            SizedBox(
                                                width: screenSize.width * 0.01),
                                            Text(
                                              'Au moins 3 caractères',
                                              style: TextStyle(
                                                color: pseudo3length
                                                    ? Colors.red
                                                    : ColorsConst.col_app,
                                                fontSize:
                                                    screenSize.width * 0.03,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              pseudohasspecialcarac ||
                                                      pseudohasspace
                                                  ? Icons.error
                                                  : Icons.check_circle,
                                              size: screenSize.width * 0.04,
                                              color: pseudohasspecialcarac ||
                                                      pseudohasspace
                                                  ? Colors.red
                                                  : ColorsConst.col_app,
                                            ),
                                            SizedBox(
                                                width: screenSize.width * 0.01),
                                            Text(
                                              'Sans caractères spéciaux ni d\'espaces',
                                              style: TextStyle(
                                                color: pseudohasspecialcarac ||
                                                        pseudohasspace
                                                    ? Colors.red
                                                    : ColorsConst.col_app,
                                                fontSize:
                                                    screenSize.width * 0.03,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                SizedBox(height: screenSize.height * 0.01),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    //onPrimary: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: const Size(210, 39),
                                    textStyle: const TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  child: FormBuilderTextField(
                                    name: 'email',
                                    initialValue:
                                        widget.utilisateur!.emailAddress,
                                    decoration: const InputDecoration(
                                      labelText: "Email *",
                                      icon: Icon(Icons.email),
                                      iconColor: Colors.black,
                                      border: InputBorder.none,
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                    ),
                                    onChanged: (value) async {
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
                                          isButtonClickable = false;
                                        });
                                      } else {
                                        setState(() {
                                          emailhaserror = false;
                                          isButtonClickable = false;
                                        });
                                      }
                                      setState(() {
                                        isButtonClickable = true;
                                      });
                                      await CheckUserInfoChanges(2);
                                    },
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.email(),
                                      FormBuilderValidators.required(),
                                    ]),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.02),
                                Container(
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        //onPrimary: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        minimumSize: const Size(210, 39),
                                        textStyle: const TextStyle(
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      child: FormBuilderTextField(
                                          name: 'phone',
                                          maxLength: 10,
                                          keyboardType: TextInputType.phone,
                                          initialValue: widget.utilisateur!
                                                  .get('phoneNumber') ??
                                              '',
                                          decoration: const InputDecoration(
                                            icon: Icon(Icons.phone),
                                            iconColor: Colors.black,
                                            border: InputBorder.none,
                                            labelText: "Numéro de téléphone *",
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          onChanged: (value) async {
                                            isButtonClickable = true;

                                            phonenumber_length = value!.length;
                                            if (value.length != 10) {
                                              setState(() {
                                                phoneNumberhaserror = true;
                                              });
                                            } else if (value[0] != '0') {
                                              setState(() {
                                                phoneNumberhaserror = true;
                                              });
                                            } else if (value[1] != '6' &&
                                                value[1] != '7') {
                                              setState(() {
                                                phoneNumberhaserror = true;
                                              });
                                            } else {
                                              setState(() {
                                                phoneNumberhaserror = false;
                                              });
                                              await CheckUserInfoChanges(3);
                                            }
                                          },
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(),
                                            FormBuilderValidators.numeric(),
                                            FormBuilderValidators.minLength(10),
                                            FormBuilderValidators.maxLength(10),
                                          ]))),
                                ),
                                SizedBox(height: screenSize.height * 0.02),
                                Visibility(
                                    visible:
                                        !_passwordVisible || _passwordVisible,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                          passwordhaserror = false;
                                          passwordlength = 0;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        backgroundColor: _passwordVisible
                                            ? const Color.fromARGB(
                                                255, 145, 150, 140)
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        minimumSize: const Size(210, 39),
                                        textStyle: const TextStyle(
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(!_passwordVisible
                                              ? Icons.lock
                                              : Icons.lock_open),
                                          SizedBox(
                                              width: screenSize.width * 0.02),
                                          Text(_passwordVisible
                                              ? "Annuler"
                                              : "Changer le mot de passe"),
                                        ],
                                      ),
                                    )),
                                SizedBox(height: screenSize.height * 0.02),
                                Visibility(
                                  visible: _passwordVisible,
                                  child: Column(
                                    children: [
                                      FormBuilderTextField(
                                        name: 'password',
                                        //controller: password_Controller,
                                        decoration: InputDecoration(
                                          icon: const Icon(Icons.lock),
                                          iconColor: Colors.black,
                                          labelText: "Mot de passe *",
                                          labelStyle: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          //_passwordVisible
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              Icons.remove_red_eye,
                                              color: _passwordcaracVisible
                                                  ? ColorsConst.col_app
                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _passwordcaracVisible =
                                                    !_passwordcaracVisible;
                                              });
                                            },
                                          ),
                                        ),
                                        onChanged: (value) {
                                          passwordlength = value!.length;
                                          _passwordhasmaj =
                                              value.contains(RegExp(r'[A-Z]'));
                                          _passwordhasmin =
                                              value.contains(RegExp(r'[a-z]'));
                                          _passwordhasnumber =
                                              value.contains(RegExp(r'[0-9]'));
                                          _passwordhasspecialcarac =
                                              value.contains(RegExp(
                                                  r'[!@#$%^&*(),.?":{}|<>]'));
                                          if (passwordlength != 0) {
                                            setState(() {
                                              isButtonClickable = true;
                                            });
                                          } else {
                                            setState(() {
                                              isButtonClickable = false;
                                            });
                                          }

                                          if (value.length < 8 ||
                                              !value
                                                  .contains(RegExp(r'[0-9]')) ||
                                              !value
                                                  .contains(RegExp(r'[A-Z]')) ||
                                              !value
                                                  .contains(RegExp(r'[a-z]')) ||
                                              !value.contains(RegExp(
                                                  r'[!@#$%^&*(),.?":{}|<>]')) ||
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
                                        obscureText: !_passwordcaracVisible,
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                          FormBuilderValidators.minLength(8),
                                        ]),
                                      ),
                                      SizedBox(
                                          height: screenSize.height * 0.01),
                                      Visibility(
                                        visible: passwordhaserror,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    screenSize.width * 0.05),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      _passwordhasspecialcarac
                                                          ? Icons.check_circle
                                                          : Icons.info,
                                                      color:
                                                          _passwordhasspecialcarac
                                                              ? ColorsConst
                                                                  .col_app
                                                              : Colors.red,
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            screenSize.width *
                                                                0.01),
                                                    Text(
                                                      "1 Caractère spécial",
                                                      style: TextStyle(
                                                        color:
                                                            _passwordhasspecialcarac
                                                                ? ColorsConst
                                                                    .col_app
                                                                : Colors.red,
                                                        fontSize:
                                                            screenSize.width *
                                                                0.035,
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
                                                    SizedBox(
                                                        width:
                                                            screenSize.width *
                                                                0.01),
                                                    Text(
                                                      "8 Caractères",
                                                      style: TextStyle(
                                                        color:
                                                            passwordlength >= 8
                                                                ? ColorsConst
                                                                    .col_app
                                                                : Colors.red,
                                                        fontSize:
                                                            screenSize.width *
                                                                0.035,
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
                                                    SizedBox(
                                                        width:
                                                            screenSize.width *
                                                                0.01),
                                                    Text(
                                                      "1 Majuscule",
                                                      style: TextStyle(
                                                        color: _passwordhasmaj
                                                            ? ColorsConst
                                                                .col_app
                                                            : Colors.red,
                                                        fontSize:
                                                            screenSize.width *
                                                                0.035,
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
                                                    SizedBox(
                                                        width:
                                                            screenSize.width *
                                                                0.01),
                                                    Text(
                                                      "1 Minuscule",
                                                      style: TextStyle(
                                                        color: _passwordhasmin
                                                            ? ColorsConst
                                                                .col_app
                                                            : Colors.red,
                                                        fontSize:
                                                            screenSize.width *
                                                                0.035,
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
                                                    SizedBox(
                                                        width:
                                                            screenSize.width *
                                                                0.01),
                                                    Text(
                                                      "1 Chiffre",
                                                      style: TextStyle(
                                                        color:
                                                            _passwordhasnumber
                                                                ? ColorsConst
                                                                    .col_app
                                                                : Colors.red,
                                                        fontSize:
                                                            screenSize.width *
                                                                0.035,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ),
                                      SizedBox(
                                          height: screenSize.height * 0.01),
                                      FormBuilderTextField(
                                        name: 'confirm_password',
                                        //controller: confirmPassword_Controller,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          icon: const Icon(Icons.lock),
                                          iconColor: Colors.black,
                                          labelText:
                                              "Confirmez le mot de passe *",
                                          labelStyle: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              Icons.remove_red_eye,
                                              color: _passwordcaracVisible
                                                  ? ColorsConst.col_app
                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _passwordcaracVisible =
                                                    !_passwordcaracVisible;
                                              });
                                            },
                                          ),
                                        ),
                                        obscureText: !_passwordcaracVisible,
                                        onChanged: (value) {
                                          if (value !=
                                              _formKey_profil.currentState
                                                  ?.fields['password']?.value) {
                                            setState(() {
                                              passwordconfirmhaserror = true;
                                            });
                                          } else {
                                            setState(() {
                                              passwordconfirmhaserror = false;
                                            });
                                          }
                                        },
                                        validator: (value) => _formKey_profil
                                                    .currentState
                                                    ?.fields['password']
                                                    ?.value !=
                                                value
                                            ? 'Ne correspond pas au mot de passe'
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.02),
                                ElevatedButton(
                                  onPressed: () {
                                    //deleteaccount();
                                    confirmSuppr();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: const Size(210, 39),
                                    textStyle: const TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          //deleteaccount();
                                          confirmSuppr();
                                        },
                                      ),
                                      const Spacer(),
                                      const Text("Supprimer ompte"),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          //deleteaccount();
                                          confirmSuppr();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.05),
                                Container(
                                  padding:
                                      EdgeInsets.all(screenSize.width * 0.05),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              backgroundColor:
                                                  Colors.blueGrey[800],
                                              textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            onPressed: () async {
                                              ParseUser? currentUser =
                                                  await ParseUser.currentUser()
                                                      as ParseUser?;
                                              context.goNamed('HomeEmployer',
                                                  extra: currentUser);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Retour'),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: screenSize.width * 0.05),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              backgroundColor:
                                                  ColorsConst.col_app,
                                              textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            onPressed: isButtonClickable
                                                ? () async {
                                                    if (_formKey_profil
                                                        .currentState!
                                                        .saveAndValidate()) {
                                                      await submitProfilHandler();
                                                    } else {
                                                      print('error');
                                                    }
                                                    //submitProfilHandler();
                                                  }
                                                : null,
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Enregistrer'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ], //FIN CHILDREN PRINCIPAL
                  ), //FIN COLUMN PRINCIPAL
                )));
  }
}
