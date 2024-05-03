import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io' show Platform;

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}

final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
const String _kLocationServicesDisabledMessage =
    'Location services are disabled.';
const String _kPermissionDeniedMessage = 'Permission denied.';
const String _kPermissionDeniedForeverMessage = 'Permission denied forever.';
const String _kPermissionGrantedMessage = 'Permission granted.';
final List<_PositionItem> _positionItems = <_PositionItem>[];

Future<Map<String, double>> getUserLocation() async {
  final hasPermission = await _handlePermission();

  if(!hasPermission){
    //await _requestLocationPermission();
    await _handlePermission();
  }

  try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double userlat = position.latitude;
    double userlong = position.longitude;
    return {
      'userlat': userlat,
      'userlong': userlong,
    };
  } catch (e) {
    print('Erreur lors de la récupération de la position : $e');
    return {
      'userlat': 0.0,
      'userlong': 0.0,
    };
  }
}

// Fonction pour calculer la distance entre la position de l'utilisateur et la cible
Future<List<double>> calculateDistance(double userlat, double userlong,
    double targetlat, double targetlong) async {
  try {
    double distance = await Geolocator.distanceBetween(
      userlat,
      userlong,
      targetlat,
      targetlong,
    );

    double distanceInMeters = distance;
    double distKilometer = distance / 1000;

    return [distanceInMeters, distKilometer];
  } catch (e) {
    print('Erreur lors du calcul de la distance : $e');
    return [0.0, 0.0];
  }
}

Future<void> getCurrentPosition() async {
  final hasPermission = await _handlePermission();

  if (!hasPermission) {
    return;
  }

  final position = await _geolocatorPlatform.getCurrentPosition();
  _updatePositionList(
    _PositionItemType.position,
    position.toString(),
  );
}

Future<void> getLocationAccurarate() async {
  final status = await _geolocatorPlatform.getLocationAccuracy();
  _handleLocationAccuracyStatus(status);
}

void _requestTemporaryFullAccuracy() async {
  final status = await _geolocatorPlatform.requestTemporaryFullAccuracy(
    purposeKey: "TemporaryPreciseAccuracy",
  );
  _handleLocationAccuracyStatus(status);
}

void _handleLocationAccuracyStatus(LocationAccuracyStatus status) {
  String locationAccuracyStatusValue;
  if (status == LocationAccuracyStatus.precise) {
    locationAccuracyStatusValue = 'Precise';
  } else if (status == LocationAccuracyStatus.reduced) {
    locationAccuracyStatusValue = 'Reduced';
  } else {
    locationAccuracyStatusValue = 'Unknown';
  }
  _updatePositionList(
    _PositionItemType.log,
    '$locationAccuracyStatusValue location accuracy granted.',
  );
}

Future<bool> _handlePermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    _updatePositionList(
      _PositionItemType.log,
      _kLocationServicesDisabledMessage,
    );

    return false;
  }

  permission = await _geolocatorPlatform.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await _geolocatorPlatform.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      _updatePositionList(
        _PositionItemType.log,
        _kPermissionDeniedMessage,
      );

      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    _updatePositionList(
      _PositionItemType.log,
      _kPermissionDeniedForeverMessage,
    );

    return false;
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  _updatePositionList(
    _PositionItemType.log,
    _kPermissionGrantedMessage,
  );
  return true;
}

void _updatePositionList(_PositionItemType type, String displayValue) {
  _positionItems.add(_PositionItem(type, displayValue));
}

void _openLocationSettings() async {
  final opened = await _geolocatorPlatform.openLocationSettings();
  String displayValue;

  if (opened) {
    displayValue = 'Opened Location Settings';
  } else {
    displayValue = 'Error opening Location Settings';
  }

  _updatePositionList(
    _PositionItemType.log,
    displayValue,
  );
}

Future<void> _requestLocationPermission() async {
  if (await Permission.location.isGranted) {
    // L'autorisation de localisation est déjà accordée.
    return;
  }

  final status = await Permission.location.request();
  if (status.isGranted) {
    // L'autorisation de localisation est accordée.
    // Vous pouvez appeler ici la fonction pour obtenir la position de l'utilisateur.
    //getUserLocation();
  } else if (status.isDenied) {
    // L'autorisation de localisation a été refusée une fois.
    // Vous pouvez afficher un message à l'utilisateur pour lui demander de l'accorder dans les paramètres de l'application.
    print('L\'autorisation de localisation a été refusée.');
  } else if (status.isPermanentlyDenied) {
    // L'autorisation de localisation a été définitivement refusée.
    // Vous pouvez afficher un message à l'utilisateur pour lui demander de l'accorder dans les paramètres du système.
    print('L\'autorisation de localisation a été définitivement refusée.');
  }
}
