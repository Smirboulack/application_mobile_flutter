import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sevenapplication/core/services/database/database.dart';
import 'package:sevenapplication/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeParse();
  runApp(SevenJobs());
}
