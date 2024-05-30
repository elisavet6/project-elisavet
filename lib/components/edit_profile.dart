import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iq_project/components/TextBox.dart';
import 'package:iq_project/components/change_password.dart';
import 'package:iq_project/components/landing_page.dart';
import 'package:iq_project/components/message_helper.dart';

import 'package:iq_project/services/users.dart';
import 'package:iq_project/components/login_2.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final UserServices userServices = UserServices();
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  Map<String, dynamic>? userData;

  Future<void> deleteAccount() async {
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
      try {
        await userServices.deleteUser(currentUser.email!);
        await currentUser.delete();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => login_2()));
      } catch (e) {
        print("Error deleting account: $e");
      }
    }
  }

  Future<void> _selectDate(String field, String value) async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now());

    if (_picked != null) {
      setState(() async {
        // Calculate the age based on the selected date
        DateTime currentDate = DateTime.now();
        DateTime minDate =
            DateTime(currentDate.year - 16, currentDate.month, currentDate.day);
        int age = currentDate.year - _picked.year;

        // Check if the selected date makes the user younger than 16 years old
        if (_picked.isAfter(minDate)) {
          // Show a message if the age is younger than 16 years old
          ShowMessageHelper.showMessage(
              context: context,
              text: "You must be at least 16 years old to register");
        } else if (value.trim().isNotEmpty) {
          await usersCollection.doc(currentUser.email).update({field: value});
        }
      });
    }
  }

  Future<void> saveField(String field, String value) async {
    if (value.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.email).update({field: value});
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
                final user = snapshot.data!.data() as Map<String, dynamic>?;
                return ListView(children: [
                  SizedBox(height: 20),
                  Icon(Icons.person, size: 60),
                  SizedBox(height: 20),
                  Text(
                    user!['email'],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('My Details',
                            style: TextStyle(color: Colors.grey)),
                        ElevatedButton(
                          onPressed: deleteAccount,
                          child: Text("Delete Account"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            textStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  EditableTextField(
                    label: 'First Name',
                    initialValue: user['name'] ?? '',
                    onSaved: (value) => saveField('name', value),
                  ),
                  EditableTextField(
                    label: 'Last Name',
                    initialValue: user['lastname'] ?? '',
                    onSaved: (value) => saveField('lastname', value),
                  ),
                  EditableTextField(
                    label: 'Country',
                    initialValue: user['country'] ?? '',
                    onSaved: (value) => saveField('country', value),
                  ),
                  EditableTextField(
                    label: 'City',
                    initialValue: user['city'] ?? '',
                    onSaved: (value) => saveField('city', value),
                  ),
                  EditableTextField(
                    label: 'Birth Date',
                    initialValue: user['date'] ?? '',
                    onSaved: (value) => _selectDate('date', value),
                  ),
                  EditableTextField(
                    label: 'Phone Number',
                    initialValue: user['phoneNumber'] ?? '',
                    onSaved: (value) => saveField('phoneNumber', value),
                  ),
                  EditableTextField(
                    label: 'Language',
                    initialValue: user['language'] ?? '',
                    onSaved: (value) => saveField('language', value),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePassword()),
                      );
                    },
                    child: Text(
                      "Do you want to change your password?",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                      child: Text("Save changes"),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        fixedSize: Size(100, 50),
                        backgroundColor: Colors.orange.shade700,
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ]);
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
