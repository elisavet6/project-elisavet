import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iq_project/components/eggrafh.dart';

class UserServices {
  final User? currentUser = FirebaseAuth.instance.currentUser!;
//get all users
  final CollectionReference Users =
      FirebaseFirestore.instance.collection("Users");

//read from the firebase current user's details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email)
        .get();
  }

//delete user
  Future<void> deleteUser(String email) async {
    try {
      await Users.doc(email).delete();
    } catch (e) {
      print("Error deleting user: $e");
      throw e;
    }
  }
}
