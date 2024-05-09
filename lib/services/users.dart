import 'dart:js';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserServices {
  final User? currentUser = FirebaseAuth.instance.currentUser!;

  final CollectionReference Users =
      FirebaseFirestore.instance.collection("Users");

  // Create user, firestore
  // Future<void> addUser(String name, String lastname, String date,
  //     String country, String language, String phoneNumber, String email) async {
  //   return Users.add({
  //     'name': name,
  //     'lastname': lastname,
  //     'date': date,
  //     'country': country,
  //     'language': language,
  //     'phoneNumber': phoneNumber,
  //     'email': email,
  //     // 'password': password,
  //     // 'confirm password': confirmPassword,
  //   }).then((value) => print("user added")).catchError((error) {
  //     print("something went wrong while trying to communicate with the server");
  //   });
  // }

//read from the firebase
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email)
        .get();
  }
//current user
}
