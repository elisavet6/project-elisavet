import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iq_project/components/edit_profile.dart';
import 'package:iq_project/components/landing_page.dart';
import 'package:iq_project/components/login.dart';
import 'package:iq_project/components/login_2.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

final FirebaseStorage _storage = FirebaseStorage.instance;
final User currentUser = FirebaseAuth.instance.currentUser!;
Uint8List? _image;
File? image;
String? _imageUrl;

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    super.initState();
    getProfilePicture(); // Fetch the profile picture URL on initialization
  }

  Future<void> getProfilePicture() async {
    final storageRef =
        _storage.ref().child("profile_pictures/${currentUser.uid}");
    try {
      final imageUrl = await storageRef.getDownloadURL();
      print('Fetched image URL: $imageUrl'); // Log the fetched image URL
      setState(() {
        _imageUrl = imageUrl;
      });
    } catch (e) {
      print('Error fetching profile picture: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Drawer(
              backgroundColor: Colors.orange.shade800,
              child: Column(children: [
                DrawerHeader(
                  child: _imageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            _imageUrl!,
                            fit: BoxFit.cover,
                            width: 128,
                            height: 128,
                            errorBuilder: (context, error, stackTrace) {
                              return CircleAvatar(
                                radius: 64,
                                backgroundColor: Colors.orange.shade800,
                                foregroundColor: Colors.white,
                                child: Icon(Icons.person, size: 80),
                              );
                            },
                          ),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.orange.shade800,
                          foregroundColor: Colors.white,
                          child: Icon(Icons.person, size: 80),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    title: Text(
                      "home".tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home())),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: Text(
                      "profile".tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyProfile())),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: Text(
                      "logout".tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        // Navigate to login page after successful sign out
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => login()),
                        );
                      } catch (e) {
                        print("Error signing out: $e");
                      }
                    },
                  ),
                ),
              ]),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${tr("error")}: ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
