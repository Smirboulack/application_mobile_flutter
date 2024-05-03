import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/entreprise.dart';
import 'package:sevenapplication/core/models/sector.dart';
import 'package:sevenapplication/core/services/database/database.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/widgets/footer_widget.dart';
import 'package:sevenapplication/widgets/header_widget.dart';
import 'package:sevenapplication/widgets/textWidgets/large_text.dart';

class EmployerEntreprise extends StatefulWidget {
  ParseUser? utilisateur;
  EmployerEntreprise({Key? key, this.utilisateur}) : super(key: key);

  @override
  _EmployerEntrepriseState createState() => _EmployerEntrepriseState();
}

class _EmployerEntrepriseState extends State<EmployerEntreprise> {
  final _formKey_entreprise = GlobalKey<FormBuilderState>();

  late final TextEditingController _addressController;

  bool _isLoading = true;
  bool phonevisible = false;
  bool isExpanded = false;
  late bool isButtonClickable;
  Entreprise? entreprise;
  late List<String>? sectors;
  late bool phoneNumberhaserror;
  late int phonenumber_length;
  late int siret_length;
  List<dynamic> _suggestions = [];
  late String selectedSecteurActivite;
  late double _latitude;
  late double _longitude;
  final Widget loadingWidget = const SpinKitFadingCircle(
    color: ColorsConst.col_app,
    size: 200.0,
  );

  Future<void> initiateinfos() async {
    sectors = await getSectorsNames();
    if (widget.utilisateur?.get('entreprise') != null) {
      entreprise = await getEntrepriseById(
          widget.utilisateur?.get('entreprise').objectId);
    }
    setState(() {
      sectors = sectors;
      _addressController.text = entreprise != null ? entreprise!.address : '';
      selectedSecteurActivite = entreprise?.sector?.name ?? '';
      entreprise = entreprise;
      _isLoading = false;
    });
  }

  Future<void> _startLoading(dynamic duration, Widget loadingWidget) async {
    // Mettez ici votre logique de rafraîchissement des données
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;

    if (currentUser?.get('entreprise') != null) {
      entreprise =
          await getEntrepriseById(currentUser?.get('entreprise').objectId);
      setState(() {
        entreprise = entreprise;
      });
    } else {
      setState(() {
        selectedSecteurActivite = "";
        entreprise = null;
        siret_length = 0;
        _addressController.text = '';
      });
    }
    setState(() {
      _isLoading = false;
      isButtonClickable = false;
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

  @override
  void initState() {
    initiateinfos();
    super.initState();
    _addressController = TextEditingController();
    _latitude = 0.0;
    _longitude = 0.0;
    siret_length = entreprise != null ? entreprise!.siret.length : 0;
    isButtonClickable = false;
    phoneNumberhaserror = false;
    phonenumber_length = entreprise != null ? entreprise!.contact.length : 0;
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
              color: const Color(0xFFF5F5F5),
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
                      color: const Color(0xFF5C5C5C),
                      fontSize: screenSize.width * 0.05,
                      fontFamily: 'Istok Web',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenSize.height * 0.05),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF8CC63E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
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
                      child: const Text("Se connecter"),
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
                  color: Colors.red,
                ),
                const SizedBox(height: 20),
                Text(
                  'Êtes-vous sûr de vouloir supprimer votre entreprise ?',
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
                        await delete();
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
                    'Votre entreprise a été supprimée!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Istok Web',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: ScreenSize.height * 0.03),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(210, 39),
                      textStyle: const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(ScreenSize.width * 0.02),
                      child: const Text("Ok"),
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
    selectedSecteurActivite == "Autre"
        ? secteuractivite = _formKey_entreprise
            .currentState!.fields['autresecteuractivite']!.value
            .toString()
        : secteuractivite = selectedSecteurActivite;
    String address = _addressController.text;

    String interlocuteur =
        _formKey_entreprise.currentState!.fields['Intercoluteur']!.value;
    String phoneContact = phonenumbercontroller ?? entreprise!.contact;

    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    String secteurId = await getIdSectorByName(secteuractivite);
    Sector secteur = Sector(name: secteuractivite, objectId: secteurId);

    //print(currentUser?.get('entreprise').objectId);
    if (currentUser?.get('entreprise') != null) {
      await updateEntreprise(currentUser?.get('entreprise').objectId, name,
          secteur, address, siret, interlocuteur, phoneContact);
      await _startLoading(2, loadingWidget);
      showmodal();
    } else {
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
      await _startLoading(2, loadingWidget);
      showmodal();
    }
  }

  Future<void> delete() async {
    await deleteEntreprise(widget.utilisateur!.get('entreprise').objectId);
    await _startLoading(2, loadingWidget);
    showmodalSuppr();
  }

  Future<void> checkEntrepriseHasChanged(champnumber) async {
    if (champnumber == 1) {
      if (entreprise!.name ==
          _formKey_entreprise.currentState!.fields['entreprisename']!.value
              .toString()) {
        print('ils sont égaux');
        setState(() {
          isButtonClickable = false;
        });
      }
    } else if (champnumber == 2) {
      if (entreprise!.sector!.name == selectedSecteurActivite) {
        setState(() {
          isButtonClickable = false;
        });
      }
    } else if (champnumber == 3) {
      if (entreprise!.address == _addressController.text) {
        setState(() {
          isButtonClickable = false;
        });
      }
    } else if (champnumber == 4) {
      if (entreprise!.interlocutor ==
          _formKey_entreprise.currentState!.fields['Intercoluteur']!.value
              .toString()) {
        setState(() {
          isButtonClickable = false;
        });
      }
    } else if (champnumber == 5) {
      if (entreprise!.contact ==
          _formKey_entreprise.currentState!.fields['phone']!.value.toString()) {
        setState(() {
          isButtonClickable = false;
        });
      }
    } else if (champnumber == 6) {
      if (entreprise!.siret ==
          _formKey_entreprise.currentState!.fields['siret']!.value.toString()) {
        setState(() {
          isButtonClickable = false;
        });
      }
    }
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
                      'Chargement en cours ...',
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
                  children: [
                    const HeaderWidget(),
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
                                text: 'Mes informations',
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
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  //onPrimary: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: Size(screenSize.width * 0.9,
                                      screenSize.height * 0.01),
                                  textStyle: const TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                child: FormBuilderTextField(
                                  name: 'entreprisename',
                                  initialValue: entreprise != null
                                      ? entreprise!.name
                                      : '',
                                  decoration: const InputDecoration(
                                    labelText: "Nom entreprise",
                                    icon: Icon(Icons.business),
                                    iconColor: Colors.black,
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  onChanged: (value) async {
                                    setState(() {
                                      isButtonClickable = true;
                                    });
                                    await checkEntrepriseHasChanged(1);
                                    if (value == '') {
                                      setState(() {
                                        isButtonClickable = false;
                                      });
                                    }
                                  },
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.minLength(1)
                                  ]),
                                ),
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
                                    initialValue: entreprise != null
                                        ? entreprise!.sector?.name
                                        : '',
                                    decoration: const InputDecoration(
                                      labelText: 'Secteur d’activité',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                      icon: Icon(Icons.factory_outlined),
                                      iconColor: Colors.black,
                                      border: InputBorder.none,
                                    ),
                                    icon: const Icon(Icons.arrow_downward),
                                    onChanged: (value) async {
                                      setState(() {
                                        selectedSecteurActivite = value!;
                                        isButtonClickable = true;
                                      });
                                      await checkEntrepriseHasChanged(2);
                                      if (value == '') {
                                        setState(() {
                                          isButtonClickable = false;
                                        });
                                      }
                                    },
                                    items: sectors!
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
                                      color: const Color.fromARGB(
                                          255, 224, 237, 255),
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Text(selectedSecteurActivite))
                              ],
                            ),
                            SizedBox(height: screenSize.height * 0.01),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05),
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      //onPrimary: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      minimumSize: Size(screenSize.width * 0.9,
                                          screenSize.height * 0.01),
                                      textStyle: const TextStyle(
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _addressController,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                      ),
                                      onChanged: (value) async {
                                        _fetchAddressSuggestions(value);
                                        setState(() {
                                          isButtonClickable = true;
                                        });
                                        await checkEntrepriseHasChanged(3);
                                        if (value == '') {
                                          setState(() {
                                            isButtonClickable = false;
                                          });
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        labelText: 'Adresse de l\'entreprise',
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        border: InputBorder.none,
                                        hintText:
                                            'Ex: 1 rue de la Paix 75002 Paris',
                                        icon: Icon(Icons.search),
                                        iconColor: Colors.black,
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
                            ),
                            SizedBox(height: screenSize.height * 0.01),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.05),
                                child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      //onPrimary: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      minimumSize: Size(screenSize.width * 0.9,
                                          screenSize.height * 0.01),
                                      textStyle: const TextStyle(
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    child: FormBuilderTextField(
                                      name: 'Intercoluteur',
                                      initialValue: entreprise != null
                                          ? entreprise!.interlocutor
                                          : '',
                                      decoration: InputDecoration(
                                        labelText: "Interlocuteur",
                                        hintText: "Personne à joindre",
                                        hintStyle: TextStyle(
                                          fontSize: screenSize.width * 0.035,
                                        ),
                                        icon: const Icon(Icons.person_outline),
                                        iconColor: Colors.black,
                                        border: InputBorder.none,
                                        labelStyle: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      onChanged: (value) async {
                                        setState(() {
                                          isButtonClickable = true;
                                        });
                                        await checkEntrepriseHasChanged(4);
                                        if (value == '') {
                                          setState(() {
                                            isButtonClickable = false;
                                          });
                                        }
                                      },
                                    ))),
                            SizedBox(height: screenSize.height * 0.01),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05),
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    textStyle: const TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                    fixedSize:
                                        Size.fromWidth(screenSize.width * 0.9),
                                  ),
                                  child: FormBuilderTextField(
                                      name: 'phone',
                                      keyboardType: TextInputType.number,
                                      maxLength: 10,
                                      initialValue: entreprise != null
                                          ? entreprise!.contact
                                          : '',
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.phone),
                                        iconColor: Colors.black,
                                        border: InputBorder.none,
                                        labelText: "Téléphone entreprise *",
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      onChanged: (value) async {
                                        phonenumber_length = value!.length;
                                        if (value.length != 10) {
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
                                            isButtonClickable = true;
                                            phoneNumberhaserror = false;
                                          });
                                          await checkEntrepriseHasChanged(5);
                                        }
                                      },
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                        FormBuilderValidators.numeric(),
                                      ]))),
                            ),
                            SizedBox(height: screenSize.height * 0.01),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  //onPrimary: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: Size(screenSize.width * 0.9,
                                      screenSize.height * 0.01),
                                  textStyle: const TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                child: FormBuilderTextField(
                                  name: 'siret',
                                  maxLength: 14,
                                  initialValue: entreprise?.siret ??
                                      entreprise?.siret ??
                                      '',
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Numéro Siret",
                                    icon: Icon(Icons.assured_workload_outlined),
                                    iconColor: Colors.black,
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.minLength(14),
                                    FormBuilderValidators.maxLength(14),
                                  ]),
                                  onChanged: (value) async {
                                    setState(() {
                                      siret_length = value!.length;
                                    });
                                    if (siret_length == 14) {
                                      setState(() {
                                        isButtonClickable = true;
                                      });
                                    } else {
                                      setState(() {
                                        isButtonClickable = false;
                                      });
                                    }
                                    await checkEntrepriseHasChanged(6);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.05),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05),
                              child: ElevatedButton(
                                onPressed: entreprise != null
                                    ? () {
                                        confirmSuppr();
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: Size(screenSize.width * 0.9,
                                      screenSize.height * 0.07),
                                  textStyle: const TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: entreprise != null
                                          ? () {
                                              confirmSuppr();
                                            }
                                          : null,
                                    ),
                                    const Spacer(),
                                    const Text("Supprimer mon entreprise"),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: entreprise != null
                                          ? () {
                                              confirmSuppr();
                                            }
                                          : null,
                                    ),
                                  ],
                                ),
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
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                          backgroundColor: Colors.blueGrey[800],
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        onPressed: () async {
                                          context.pushReplacementNamed(
                                              'HomeEmployer',
                                              extra: widget.utilisateur);
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
                                          backgroundColor: ColorsConst.col_app,
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        onPressed: isButtonClickable
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
                                          child: Text('Enregistrer'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, screenSize.height * 0.05, 0, 0),
                      child: const FooterWidget(),
                    ),
                  ],
                ),
              ));
  }
}
