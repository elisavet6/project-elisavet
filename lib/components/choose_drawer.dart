import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iq_project/components/anonymous_drawer.dart';
import 'package:iq_project/components/drawer.dart';

class chooseDrawer extends StatefulWidget {
  const chooseDrawer({super.key});

  @override
  State<chooseDrawer> createState() => _chooseDrawerState();
}

class _chooseDrawerState extends State<chooseDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyDrawer();
        } else {
          return anonymous_drawer();
        }
      },
    ));
  }
}
