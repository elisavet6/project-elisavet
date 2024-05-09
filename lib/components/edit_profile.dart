// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iq_project/components/TextBox.dart';
import 'package:iq_project/services/users.dart';

class MyProfile extends StatefulWidget {
  MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final UserServices userServices = UserServices();
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  Map<String, dynamic>? userData;

  @override
  // void initState() {
  //   super.initState();
  //   loadUserData();
  // }

  // Initial fetch and setup of local user data
  // Future<void> loadUserData() async {
  //   var doc = await usersCollection.doc(currentUser.email).get();
  //   setState(() {
  //     userData = doc.data();
  //   });
  // }

// get the users details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email)
        .get();
  }

  //edit method
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit " + field,
          style: TextStyle(color: Colors.orange),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              hintText: "Enter a new $field",
              hintStyle: TextStyle(color: Colors.grey)),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(newValue),
              child: Text('Save')),
        ],
      ),
    );
    //update in firestore
    if (newValue.trim().length > 0) {
      //only update if there is something in the textfield
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("M Y  P R O F I L E"),
          backgroundColor: Colors.orange.shade600,
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUser.email!)
                .snapshots(),
            builder: (context, snapshot) {
              //loading
              //   if (snapshot.connectionState == ConnectionState.waiting) {
              //     return const Center(
              //       child: CircularProgressIndicator(),
              //     );
              //   }
              //   //error
              //  else
              if (snapshot.hasData) {
                //extract data
                final user = snapshot.data!.data() as Map<String, dynamic>?;
                return ListView(children: [
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    Icons.person,
                    size: 50,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    user!['email'],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 15),
                    child: Text(
                      'My Details',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),

                  //Fields
                  MyTextBox(
                      sectionName: 'First Name',
                      text: user['name'],
                      onPressed: () => editField('First Name')),

                  MyTextBox(
                      sectionName: 'Last Name',
                      text: user['lastname'],
                      onPressed: () => editField('Last Name')),

                  MyTextBox(
                      sectionName: 'Country',
                      text: user['country'],
                      onPressed: () => editField('Country')),
                  MyTextBox(
                      sectionName: 'Birth Date',
                      text: user['date'],
                      onPressed: () => editField('Birth Date')),

                  MyTextBox(
                      sectionName: 'Phone Number',
                      text: user['phoneNumber'],
                      onPressed: () => editField('Phone Number')),
                  MyTextBox(
                      sectionName: 'Language',
                      text: user['language'],
                      onPressed: () => editField('Language')),
                  MyTextBox(
                      sectionName: 'Change your Password',
                      text: '',
                      onPressed: () => editField('Change your Password')),
                  MyTextBox(
                      sectionName: 'Confirm your new Password',
                      text: '',
                      onPressed: () => editField('Confirm your new Password')),
                ]);
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
