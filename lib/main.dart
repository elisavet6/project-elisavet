import 'package:flutter/material.dart';
import 'package:iq_project/eggrafh.dart';
import 'package:iq_project/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MaterialApp(
      home: login(), debugShowCheckedModeBanner: false, title: 'Login Page'));
}
