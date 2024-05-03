import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/*Cette classe a pour but de fetch les données et faire des requetes sur L'API SIRENE V3 de l'INSEE
  Voir plus de détails ici : https://api.insee.fr/catalogue/site/themes/wso2/subthemes/insee/pages/item-info.jag?name=Sirene&version=V3&provider=insee
 */

String _accessToken = '';

class Siret_Services {
  static Future<void> generateAccessToken() async {
    final clientId = "XFMcMBzh96pFGlydrxbLR1z7o9Ia";
    final clientSecret = "KmmmT0Vsqj9p4AvskNoxPTYgzOwa";
    final tokenUrl = "https://api.insee.fr/token";

    final response = await http.post(
      Uri.parse(tokenUrl),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      print('Jetons d\'accès générés avec succès !');
      final jsonResponse = json.decode(response.body);
      _accessToken = jsonResponse['access_token'];
    } else {
      print('Échec de la génération des jetons d\'accès.');
      throw Exception('Failed to generate access token.');
    }
  }

  static Future<bool> verifySiret(String siret) async {
    if (_accessToken.isEmpty) {
      await generateAccessToken();
    }

    final apiUrl = 'https://api.insee.fr/entreprises/sirene/V3/siret/$siret';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $_accessToken'},
    );
    final jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      print('Siret valide !');
      return true;
    } else {
      print('Siret invalide !');
      return false;
    }
  }
}
