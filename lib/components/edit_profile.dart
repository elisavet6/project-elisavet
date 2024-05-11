// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iq_project/components/TextBox.dart';
import 'package:iq_project/components/login_2.dart';
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

  // get the users details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
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
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
              hintText: "Enter a new $field",
              hintStyle: const TextStyle(color: Colors.grey)),
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

  Future<void> deleteAccount() async {
    // Show a confirmation dialog
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Confirm Delete",
          style: TextStyle(color: Colors.orange),
        ),
        content: Text("Are you sure you want to delete your account?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != null && confirm) {
      // Delete the user account
      try {
        await userServices.deleteUser(currentUser.email!);
        await currentUser.delete();

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => login_2()));
      } catch (e) {
        // Handle errors
        print("Error deleting account: $e");
      }
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
                .doc(currentUser.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //extract data
                final user = snapshot.data!.data() as Map<String, dynamic>?;
                return ListView(children: [
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    Icons.person,
                    size: 60,
                  ),
                  SizedBox(
                    height: 20,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Details',
                          style: TextStyle(color: Colors.grey),
                        ),
                        ElevatedButton(
                          onPressed: deleteAccount,
                          child: Text("Delete Account"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            textStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Fields
                  MyTextBox(
                      sectionName: 'First Name',
                      text: user['name'],
                      onPressed: () => editField('name')),

                  MyTextBox(
                      sectionName: 'Last Name',
                      text: user['lastname'],
                      onPressed: () => editField('lastname')),

                  MyTextBox(
                      sectionName: 'Country',
                      text: user['country'],
                      onPressed: () => editField('country')),
                  MyTextBox(
                      sectionName: 'Birth Date',
                      text: user['date'],
                      onPressed: () => editField('date')),

                  MyTextBox(
                      sectionName: 'Phone Number',
                      text: user['phoneNumber'],
                      onPressed: () => editField('phoneNumber')),
                  MyTextBox(
                      sectionName: 'Language',
                      text: user['language'],
                      onPressed: () => editField('language')),
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
