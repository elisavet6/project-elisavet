import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iq_project/get_all_users.dart';
import 'package:iq_project/components/login_2.dart';
import 'package:flutter/material.dart';

import 'package:iq_project/components/drawer.dart';
import 'package:iq_project/services/users.dart';

void main() {
  runApp(MaterialApp(
      home: Home(), debugShowCheckedModeBanner: false, title: 'Home Page'));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserServices userServices = UserServices();
  final User? currentUser = FirebaseAuth.instance.currentUser!;

  TextEditingController startingPoint = TextEditingController();
  TextEditingController destination = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  String name = "";
  List data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange.shade600,
          title: Text("H O M E"),
        ),
        drawer: MyDrawer(),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUser?.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
                //data recieived
              } else if (snapshot.hasData) {
                //extract data
                Map<String, dynamic>? user =
                    snapshot.data!.data() as Map<String, dynamic>?;

                return SingleChildScrollView(
                  child: Center(
                    child: Container(
                      child: Form(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'lib/images/logotry.png',
                              width: 400,
                              height: 150,
                            ),
                            Text(
                              'Welcome ' +
                                  user!['name'] +
                                  '! Book your next trip!',
                              style: TextStyle(
                                  wordSpacing: 2,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600,
                                  height: 3),
                            ),
                            SizedBox(height: 50),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: startingPoint,
                                      decoration: InputDecoration(
                                          labelText: "Starting Point"),
                                    ),
                                  ),
                                ),

                                //reverse locations button
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.cached_outlined,
                                      color: Colors.orange.shade600,
                                      size: 30.0,
                                    ),
                                    onPressed: () {
                                      final temp = destination.text;
                                      destination.text = startingPoint.text;
                                      startingPoint.text = temp;
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: destination,
                                      decoration: InputDecoration(
                                          labelText: "Destination"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Errors${snapshot.error}'),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
