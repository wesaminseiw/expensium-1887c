import 'dart:developer'; // Import for logging
import 'package:expensium/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    log('Firebase initialized in main.');
  } catch (e) {
    log('Error initializing Firebase in main: $e');
  }

  runApp(const MyApp());
}
