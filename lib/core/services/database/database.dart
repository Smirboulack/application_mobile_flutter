import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/entreprise.dart';
import 'package:sevenapplication/core/models/equipment.dart';
import 'package:sevenapplication/core/models/facture.dart';
import 'package:sevenapplication/core/models/metier.dart';
import 'package:sevenapplication/core/models/mobility.dart';
import 'package:sevenapplication/core/models/sector.dart';
import 'package:sevenapplication/core/models/service.dart';
import 'package:sevenapplication/core/models/status.dart';
import 'package:sevenapplication/core/models/titles.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/core/services/email_services.dart';
import 'package:sevenapplication/utils/const_app.dart';
import 'package:sevenapplication/utils/email_texts.dart';

//initialisation de la base de données version final
Future<void> initializeParse() async {
  try {
    await Parse().initialize(
      ConstApp.keyApplicationId,
      ConstApp.keyParseServerUrl,
      autoSendSessionId: true,
      liveQueryUrl: ConstApp.keyParseServerUrl,
      debug: true,
    );
    print('Connexion à la base de données réussie');
  } catch (e) {
    print('Erreur lors de la connexion à la base de données : $e');
  }
}

//initialisation de la base de données version test
/* Future<void> initializeParseTest() async {
  final keyApplicationId = 'gAwqkcQCmdob4QZd63WAgZwhuztMzKDHSSKoPZqW';
  final keyClientKey = 'JWcdTCWpHpuI6dNqTBfx5btd7XoJeOT9jFunijMI';
  final keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
    debug: true,
  );
  print("Connexion à la base de données réussie");
} */

final currentUser = ParseUser(null, null, null);
////////////////////////////////////////////////////////////////////////////////////
///////////////////UTILISATEUR//////////////////////////////////////////////////////
///////////////////UTILISATEUR//////////////////////////////////////////////////////
///////////////////UTILISATEUR//////////////////////////////////////////////////////
///////////////////UTILISATEUR//////////////////////////////////////////////////////

Future<String> createUserBoss(
    username, email, phoneNumber, password, type, XFile? avatar) async {
  final user = ParseUser.createUser(email, password, email);
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  user.set('fcmToken', fcmToken!);

  user.set('username', username);
  user.set('phoneNumber', phoneNumber);

  user.set('type', type);
  if (avatar != null) {
    user.set('Avatar', avatar);
  }
  final response = await user.create();
  if (response.success) {
    EmailService.sendHtmlEmail(
        recipient: email,
        subject: "Bienvenue dans la communauté SevenJobs !",
        htmlBody: emails_register(username));

    print('User created successfully!');
  } else {
    print('Error creating user: ${response.error!.message}');
    return response.error!.message;
  }
  return '';
}

Future<String> createJobber(username, email, phoneNumber, password, type,
    XFile? avatar, Service? service, ParseGeoPoint location) async {
  final user = ParseUser.createUser(email, password, email);
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  user.set('fcmToken', fcmToken!);
  user.set('username', username);
  user.set('phoneNumber', phoneNumber);
  user.set('type', type);
  user.set('location', location);

  if (avatar != null) {
    user.set('Avatar', avatar);
  }
  if (service != null) {
    user.set(
        'service', ParseObject('Service')..set('objectId', service.objectId));
  }
  final response = await user.create();
  if (response.success) {
    print('User created successfully!');
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    user.set('fcmToken', fcmToken!);
    EmailService.sendHtmlEmail(
        recipient: email,
        subject: "Bienvenue dans la communauté SevenJobs !",
        htmlBody: emails_register(username));
  } else {
    print('Error creating user: ${response.error!.message}');
    return response.error!.message;
  }
  return '';
}

Future<String> createAutoEntrepreneurJobber(
    username,
    email,
    phoneNumber,
    password,
    type,
    XFile? avatar,
    Service? service,
    String entrepriseID,
    ParseGeoPoint location) async {
  final user = ParseUser.createUser(email, password, email);
  user.set('username', username);
  user.set('phoneNumber', phoneNumber);
  user.set('location', location);
  user.set('type', type);
  if (avatar != null) {
    user.set('Avatar', avatar);
  }
  if (service != null) {
    user.set(
        'service', ParseObject('Service')..set('objectId', service!.objectId));
  }
  if (entrepriseID != null) {
    user.set(
        'entreprise', ParseObject('Entreprise')..set('objectId', entrepriseID));
  }

  final response = await user.create();
  if (response.success) {
    print('User created successfully!');
  } else {
    print('Error creating user: ${response.error!.message}');
    return response.error!.message;
  }
  return '';
}

Future<bool> loginUser(String email, String password) async {
  bool connection = false;
  final user = ParseUser(email, password, email);
  final response = await user.login();
  if (response.success) {
    print('Connexion réussie!');
    connection = true;
  } else {
    print('Erreur lors de la connexion: ${response.error!.message}');
  }
  return connection;
}

Future<void> logoutUser() async {
  final response = await currentUser.logout();
  if (response.success) {
    print('User logged out successfully!');
  } else {
    print('Error logging out user: ${response.error!.message}');
  }
}

Future<void> addUserAvatar(XFile image) async {
  ParseFileBase? parseFile;

  if (kIsWeb) {
    //Flutter Web
    parseFile = ParseWebFile(await image!.readAsBytes(),
        name: 'image.jpg'); //Name for file is required
  } else {
    //Flutter Mobile/Desktop
    parseFile = ParseFile(File(image!.path));
  }
  await parseFile.save();
  final currentUser = await ParseUser.currentUser();
  currentUser.set('Avatar', parseFile);
  await currentUser.save();
  if (currentUser.get('Avatar') != null) {
    print('L\'avatar a été ajouté avec succès !');
  } else {
    print('Erreur lors de l\'ajout de l\'avatar');
  }
}

Future<void> deleteUserAvatar() async {
  final ParseUser? currentUser = await ParseUser.currentUser();
  currentUser?.unset('Avatar');
  await currentUser?.save();
  print('Avatar supprimé avec succès !');
}

Future<bool> checkUserEmail(String email) async {
  bool exist = false;
  final query = QueryBuilder<ParseUser>(ParseUser.forQuery());
  query.whereEqualTo('email', email);
  final response = await query.query();
  if (response.success && response.results != null) {
    final user = response.results!.first;
    if (user != null) {
      exist = true;
    }
  } else {
    print('Error getting user by email: ${response.error?.message}');
  }
  return exist;
}

Future<bool> checkUserPassword(String email, String password) async {
  bool exist = false;
  final query = QueryBuilder<ParseUser>(ParseUser.forQuery());
  query.whereEqualTo('email', email);
  final response = await query.query();
  if (response.success && response.results != null) {
    final user = response.results!.first;
    if (user != null && user.password == password) {
      exist = true;
    }
  } else {
    print('Error getting user by email: ${response.error?.message}');
  }
  return exist;
}

Future<bool> checkUserUsername(String username) async {
  bool exist = false;
  final query = QueryBuilder<ParseUser>(ParseUser.forQuery());
  query.whereEqualTo('username', username);
  final response = await query.query();
  if (response.success && response.results != null) {
    final user = response.results!.first;
    if (user != null) {
      exist = true;
    }
  } else {
    print('Error getting user by email: ${response.error?.message}');
  }
  return exist;
}

Future<void> deleteUser(ParseUser? user) async {
  try {
    await deleteAssociatedObjects(user!);
    await user.delete();
    print('User deleted successfully.');
  } catch (e) {
    print('Error deleting user and associated objects: $e');
  }
}

Future<void> deleteAssociatedObjects(ParseUser? user) async {
  try {
    ParseObject? entreprise = user!.get<ParseObject>('entreprise');
    if (entreprise != null) {
      await entreprise.delete();
      print('Associated "entreprise" object deleted successfully.');
    }
  } catch (e) {
    print('Error deleting associated objects: $e');
  }
}

Future<void> updateUser(username, email, password, phoneNumber, type,
    Entreprise? entreprise) async {
  final ParseUser? currentUser = await ParseUser.currentUser();
  if (currentUser != null) {
    currentUser.username = username;
    currentUser.emailAddress = email;
    if (password == null) {
      currentUser.password = currentUser.password;
    }
    currentUser.password = password;
    currentUser.set('phoneNumber', phoneNumber);
    currentUser.set('type', type);
    if (entreprise != null) {
      currentUser.set('entreprise',
          ParseObject('Entreprise')..set('objectId', entreprise!.objectId));
    }
    try {
      await currentUser.save();
      print('Informations utilisateur mis à jour avec succès.');
    } catch (e) {
      print(
          'Une erreur s\'est produite lors de la mise à jour du mot de passe : $e');
    }
  } else {
    print('Aucun utilisateur n\'est connecté.');
  }
}

Future<void> updateUserRib(username, email, password, phoneNumber, type,
    Entreprise? entreprise) async {}

Future<void> updateUser2(username, email, password, phoneNumber,
    String? serviceID, Entreprise? entreprise) async {
  final ParseUser? currentUser = await ParseUser.currentUser();
  if (currentUser != null) {
    currentUser.username = username;
    currentUser.emailAddress = email;
    if (password == null) {
      currentUser.password = currentUser.password;
    }
    currentUser.password = password;
    currentUser.set('phoneNumber', phoneNumber);
    currentUser.set(
        'service', ParseObject('Service')..set('objectId', serviceID));
    if (entreprise != null) {
      currentUser.set('entreprise',
          ParseObject('Entreprise')..set('objectId', entreprise!.objectId));
    }
    try {
      await currentUser.save();
      print('Informations utilisateur mis à jour avec succès.');
    } catch (e) {
      print(
          'Une erreur s\'est produite lors de la mise à jour du mot de passe : $e');
    }
  } else {
    print('Aucun utilisateur n\'est connecté.');
  }
}

Future<void> updateBoss(
    String username, String? password, String email, String phonenumber) async {
  final ParseUser? currentUser = await ParseUser.currentUser();
  currentUser!.username = username;
  currentUser.emailAddress = email;
  currentUser.password = password;
  currentUser.set('phoneNumber', phonenumber);
  try {
    await currentUser.save();
    print('Informations utilisateur mis à jour avec succès.');
  } catch (e) {
    print(
        'Une erreur s\'est produite lors de la mise à jour du mot de passe : $e');
  }
}

Future<void> resetPassword(String email) async {
  final ParseUser user = ParseUser(null, null, email);
  final ParseResponse parseResponse = await user.requestPasswordReset();
  if (parseResponse.success) {
    print('Password reset request was sent successfully!');
  } else {
    print(
        'Error sending password reset request: ${parseResponse.error!.message}');
  }
}

Future<User> getUserById(String identifiant) async {
  final query = QueryBuilder<ParseUser>(ParseUser.forQuery());
  query.whereEqualTo('objectId', identifiant);
  final response = await query.query();
  if (response.success && response.results != null) {
    final user = response.results!.first;
    if (user != null) {
      return User.fromJson(user.toJson());
    }
  } else {
    print('Error getting user by email: ${response.error?.message}');
  }
  return User.fromJson({});
}

///////////////////////////////////////////////////////////////////////////////////
///////////////////ENTREPRISE//////////////////////////////////////////////////////
///////////////////ENTREPRISE//////////////////////////////////////////////////////
///////////////////ENTREPRISE//////////////////////////////////////////////////////
///////////////////ENTREPRISE//////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

Future<String> createEntreprise(
    nom, Sector? sector, adresse, siret, contact, interlocutor) async {
  final entreprise = ParseObject('Entreprise')
    ..set('name', nom)
    ..set('address', adresse)
    ..set('siret', siret)
    ..set('contact', contact)
    ..set('interlocutor', interlocutor);
  if (sector != null) {
    entreprise.set(
        'sector', ParseObject('Sector')..set('objectId', sector!.objectId));
  } else {
    entreprise..set('sector', null);
  }

  final response = await entreprise.save();
  if (response.success) {
    print('Entreprise created successfully!');
    return response.results!.first.objectId!;
  } else {
    print('Error creating entreprise: ${response.error!.message}');
    return response.error!.message;
  }
  return '';
}

Future<void> updateEntreprise(objectId, name, Sector? sector, address, siret,
    interlocuteur, phoneContact) async {
  final entreprise = ParseObject('Entreprise');
  entreprise.objectId = objectId;
  entreprise.set('name', name);
  entreprise.set(
      'sector',
      ParseObject('Sector')
        ..set('objectId', sector!.objectId)
        ..set('name', sector.name));
  entreprise.set('address', address);
  entreprise.set('siret', siret);
  entreprise.set('interlocutor', interlocuteur);
  entreprise.set('contact', phoneContact);
  try {
    await entreprise.save();
    print('Informations entreprise mis à jour avec succès.');
  } catch (e) {
    print(
        'Une erreur s\'est produite lors de la mise à jour du mot de passe : $e');
  }
}

Future<void> deleteEntreprise(String? id) async {
  final entreprise = ParseObject('Entreprise');
  final ParseUser? currentUser = await ParseUser.currentUser();
  entreprise.objectId = id;
  currentUser?.unset('entreprise');
  await currentUser?.save();
  final response = await entreprise.delete();
  if (response.success) {
    print('Entreprise deleted successfully!');
  } else {
    print('Error deleting entreprise: ${response.error!.message}');
  }
}

Future<Entreprise> getEntrepriseById(id) async {
  final query = QueryBuilder(ParseObject('Entreprise'))
    ..includeObject(["sector"]);
  query.whereEqualTo('objectId', id);
  final response = await query.query();
  if (response.success && response.results != null) {
    final entreprise = response.results!.first;
    if (entreprise != null) {
      return Entreprise.fromJson(entreprise);
    }
  } else {
    print('Error getting sector by name: ${response.error?.message}');
  }
  return Entreprise.fromJson({});
}

Future<Entreprise> getEntrepriseBySiret(siret) async {
  final query = QueryBuilder(ParseObject('Entreprise'))
    ..includeObject(["sector"]);
  query.whereEqualTo('siret', siret);
  final response = await query.query();
  if (response.success && response.results != null) {
    final entreprise = response.results!.first;
    if (entreprise != null) {
      return Entreprise.fromJson(entreprise);
    }
  } else {
    print('Error getting sector by name: ${response.error?.message}');
  }
  return Entreprise.fromJson({});
}

/////////////////////////////////////////////////////////////////////////////////
///////////////////Missions//////////////////////////////////////////////////////
///////////////////Missions//////////////////////////////////////////////////////
///////////////////Missions//////////////////////////////////////////////////////
///////////////////Missions//////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

Future<bool> createMission(
    ParseUser? currentUser,
    String? titreannonce,
    String? titleId,
    String? serviceID,
    DateTime? start_date,
    DateTime? end_date,
    String address,
    String? statusID,
    List<String> equipements,
    List<String> mobilites,
    String? heuretravail,
    String? nbworker,
    String? pausetravaux,
    String? description,
    ParseGeoPoint? localisation,
    double? totalprice) async {
  final mission = ParseObject('Mission')
    ..set('title', (ParseObject("Title")..objectId = titleId).toPointer())
    ..set('titre', titreannonce)
    ..set('address', address)
    ..set('start_date', start_date)
    ..set('end_date', end_date)
    ..set('heurestravaux', heuretravail)
    ..set('pausetravaux', pausetravaux)
    ..set('service', (ParseObject("Service")..objectId = serviceID).toPointer())
    ..set('user', currentUser?.toPointer())
    ..set('description', description)
    ..set('status', (ParseObject("Status")..objectId = statusID).toPointer())
    ..setAddAllUnique(
      'equipments',
      equipements
          .map((objectId) => ParseObject('Equipment')..objectId = objectId)
          .toList(),
    )
    ..setAddAllUnique(
      'mobility',
      mobilites
          .map((objectId) => ParseObject('Mobility')..objectId = objectId)
          .toList(),
    )
    ..set('nbworker', nbworker)
    ..set('location', localisation)
    ..set('totalprice', totalprice);

  try {
    final response = await mission.save();
    if (response.success) {
      print('Mission created successfully!');
      return true;
    } else {
      print('Error creating mission: ${response.error!.message}');
      return false;
    }
  } catch (e) {
    print('Error creating mission: $e');
    return false;
  }
}

Future<bool> SetMissionclotured(String missionID) async {
  final mission = ParseObject('Mission');
  mission.objectId = missionID;
  final Status? status = await getStatusByName('Clôturée');
  mission.set('status',
      (ParseObject("Status")..objectId = status!.objectId).toPointer());
  try {
    final response = await mission.save();
    if (response.success) {
      print('Mission created successfully!');
      return true;
    } else {
      print('Error creating mission: ${response.error!.message}');
      return false;
    }
  } catch (e) {
    print('Error creating mission: $e');
    return false;
  }
}

////////////////////////////////////////////////////////////////////////////////
///////////////////Sectors//////////////////////////////////////////////////////
///////////////////Sectors//////////////////////////////////////////////////////
///////////////////Sectors//////////////////////////////////////////////////////
///////////////////Sectors//////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Future<String> getIdSectorByName(name) async {
  String idSector = '';
  final query = QueryBuilder(ParseObject('Sector'));
  query.whereEqualTo('name', name);
  final response = await query.query();
  if (response.success && response.results != null) {
    final sector = response.results!.first;
    if (sector != null) {
      idSector = sector.objectId!;
    }
  } else {
    print('Error getting sector by name: ${response.error?.message}');
  }
  return idSector;
}

Future<Sector> getSectorByID(id) async {
  final query = QueryBuilder(ParseObject('Sector'));
  query.whereEqualTo('objectId', id);
  final response = await query.query();
  if (response.success && response.results != null) {
    final sector = response.results!.first;
    if (sector != null) {
      return Sector.fromJson(sector.toJson());
    }
  } else {
    print('Error getting sector by name: ${response.error?.message}');
  }
  return Sector.fromJson({});
}

Future<List<String>> getSectorsNames() async {
  List<String> sectorsNames = [];
  final query = QueryBuilder(ParseObject('Sector'));
  query.orderByAscending('name');
  final response = await query.query();

  if (response.success && response.results != null) {
    final sectors = response.results as List<ParseObject>;
    for (var sector in sectors) {
      sectorsNames.add(sector.get('name'));
    }
  } else {
    print('Error getting sectors: ${response.error!.message}');
  }
  return sectorsNames;
}

///////////////////////////////////////////////////////////////////////////////////
///////////////////Services//////////////////////////////////////////////////////
///////////////////Services//////////////////////////////////////////////////////
///////////////////Services//////////////////////////////////////////////////////
///////////////////Services//////////////////////////////////////////////////////
///////////////////Services////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

Future<List<Service>> getAllServices() async {
  List<Service> services = [];
  final query = QueryBuilder<ParseObject>(ParseObject('Service'))
    ..includeObject(['titles']);
  final ParseResponse apiResponse = await query.query();

  if (apiResponse.success && apiResponse.results != null) {
    services = apiResponse.results!.map((result) {
      return Service.fromJson(result);
    }).toList();
  } else {
    throw Exception('Impossible de récupérer les services.');
  }

  return services;
}

Future<Service> getServiceByNames(String name) async {
  final query = QueryBuilder<ParseObject>(ParseObject('Service'))
    ..includeObject(['titles']);
  query.whereEqualTo('name', name);
  final ParseResponse apiResponse = await query.query();

  if (apiResponse.success && apiResponse.results != null) {
    final service = apiResponse.results!.first;
    if (service != null) {
      return Service.fromJson(service);
    }
  } else {
    throw Exception('Impossible de récupérer les services.');
  }

  return Service.fromJson({});
}

Future<List<String>> getAllServiceNames() async {
  List<String> serviceNames = [];
  final query = QueryBuilder<ParseObject>(ParseObject('Service'))
    ..includeObject(['titles']);
  final ParseResponse apiResponse = await query.query();

  if (apiResponse.success && apiResponse.results != null) {
    serviceNames = apiResponse.results!.map((result) {
      // Convertir le résultat en Service
      Service service = Service.fromJson(result);
      // Extraire le nom du service
      return service.name ?? '';
    }).toList();
  } else {
    throw Exception('Impossible de récupérer les services.');
  }

  return serviceNames;
}

///////////////////////////////////////////////////////////////////////////////////
///////////////////Equipments//////////////////////////////////////////////////////
///////////////////Equipments//////////////////////////////////////////////////////
///////////////////Equipments//////////////////////////////////////////////////////
///////////////////Equipments//////////////////////////////////////////////////////
///////////////////Equipments//////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

Future<List<Equipment>> getAllEquipments() async {
  List<Equipment> equipments = [];
  final query = QueryBuilder<ParseObject>(ParseObject('Equipment'));
  final ParseResponse apiResponse = await query.query();

  if (apiResponse.success && apiResponse.results != null) {
    equipments = apiResponse.results!.map((result) {
      return Equipment.fromJson(result);
    }).toList();
  } else {
    throw Exception('Impossible de récupérer les équipements.');
  }

  return equipments;
}

Future<Equipment> getEquipmentById(String id) async {
  final query = QueryBuilder<ParseObject>(ParseObject('Equipment'));
  query.whereEqualTo('objectId', id);
  final ParseResponse apiResponse = await query.query();

  if (apiResponse.success && apiResponse.results != null) {
    final equipment = apiResponse.results!.first;
    if (equipment != null) {
      return Equipment.fromJson(equipment);
    }
  } else {
    throw Exception('Impossible de récupérer les équipements.');
  }

  return Equipment.fromJson({});
}

///////////////////////////////////////////////////////////////////////////////////
///////////////////Mobilités//////////////////////////////////////////////////////
///////////////////Mobilités//////////////////////////////////////////////////////
///////////////////Mobilités//////////////////////////////////////////////////////
///////////////////Mobilités//////////////////////////////////////////////////////
///////////////////Mobilités//////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

Future<List<Mobility>> getAllMobilities() async {
  List<Mobility> mobilities = [];
  final query = QueryBuilder<ParseObject>(ParseObject('Mobility'));
  final ParseResponse apiResponse = await query.query();

  if (apiResponse.success && apiResponse.results != null) {
    mobilities = apiResponse.results!.map((result) {
      return Mobility.fromJson(result);
    }).toList();
  } else {
    throw Exception('Impossible de récupérer les mobilités.');
  }

  return mobilities;
}

Future<Mobility> getMobilityById(String id) async {
  final query = QueryBuilder<ParseObject>(ParseObject('Mobility'));
  query.whereEqualTo('objectId', id);
  final ParseResponse apiResponse = await query.query();

  if (apiResponse.success && apiResponse.results != null) {
    final mobility = apiResponse.results!.first;
    if (mobility != null) {
      return Mobility.fromJson(mobility);
    }
  } else {
    throw Exception('Impossible de récupérer les mobilités.');
  }

  return Mobility.fromJson({});
}

///////////////////////////////////////////////////////////////////////////////////
///////////////////Status//////////////////////////////////////////////////////
///////////////////Status//////////////////////////////////////////////////////
///////////////////Status//////////////////////////////////////////////////////
///////////////////Status//////////////////////////////////////////////////////
///////////////////Status//////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

Future<List<Status>> getAllStatus() async {
  List<Status> status = [];
  final query = QueryBuilder<ParseObject>(ParseObject('Status'));
  final ParseResponse apiResponse = await query.query();

  if (apiResponse.success && apiResponse.results != null) {
    status = apiResponse.results!.map((result) {
      return Status.fromJson(result);
    }).toList();
  } else {
    throw Exception('Impossible de récupérer les status.');
  }

  return status;
}

Future<Status> getStatusById(String id) async {
  final query = QueryBuilder<ParseObject>(ParseObject('Status'));
  query.whereEqualTo('objectId', id);
  final ParseResponse apiResponse = await query.query();

  if (apiResponse.success && apiResponse.results != null) {
    final status = apiResponse.results!.first;
    if (status != null) {
      return Status.fromJson(status);
    }
  } else {
    throw Exception('Impossible de récupérer les status.');
  }

  return Status.fromJson({});
}

Future<Status> getStatusByName(String name) async {
  final query = QueryBuilder<ParseObject>(ParseObject('Status'));
  query.whereEqualTo('name', name);
  final ParseResponse apiResponse = await query.query();

  if (apiResponse.success && apiResponse.results != null) {
    final status = apiResponse.results!.first;
    if (status != null) {
      return Status.fromJson(status);
    }
  } else {
    throw Exception('Impossible de récupérer les status.');
  }

  return Status.fromJson({});
}
