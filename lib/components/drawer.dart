import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iq_project/components/edit_profile.dart';
import 'package:iq_project/components/landing_page.dart';
import 'package:iq_project/components/login_2.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.orange.shade800,
      child: Column(children: [
        const DrawerHeader(
            child: Icon(
          Icons.person,
          color: Colors.white,
          size: 60,
        )),
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
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home())),
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
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyProfile())),
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
                  MaterialPageRoute(builder: (context) => login_2()),
                );
              } catch (e) {
                print("Error signing out: $e");
              }
            },
          ),
        ),
      ]),
    );
  }
}
