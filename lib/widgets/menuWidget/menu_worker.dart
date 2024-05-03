import 'package:flutter/material.dart';

class MenuWorker extends StatefulWidget {
  const MenuWorker({Key? key}) : super(key: key);

  static void navigateToAccueil(BuildContext context) {
    // Action à effectuer lorsque l'élément Accueil est cliqué
    Navigator.pop(context); // Ferme le menu
    // Naviguez vers la page d'accueil
  }

  static void navigateToProfil(BuildContext context) {
    Navigator.pop(context); // Ferme le menu
    // Naviguez vers la page de profil
  }

  static void navigateToParametres(BuildContext context) {
    Navigator.pop(context); // Ferme le menu
    // Naviguez vers la page des paramètres
  }

  @override
  _MenuWorkerState createState() => _MenuWorkerState();
}

class _MenuWorkerState extends State<MenuWorker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text('Accueil'),
                onTap: () {
                  MenuWorker.navigateToAccueil(context);
                },
              ),
              ListTile(
                title: Text('Profil'),
                onTap: () {
                  MenuWorker.navigateToProfil(context);
                },
              ),
              ListTile(
                title: Text('Paramètres'),
                onTap: () {
                  MenuWorker.navigateToParametres(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
