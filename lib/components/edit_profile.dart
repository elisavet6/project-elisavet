import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iq_project/components/TextBox.dart';
import 'package:iq_project/components/change_password.dart';
import 'package:iq_project/components/landing_page.dart';
import 'package:iq_project/components/message_helper.dart';
import 'package:iq_project/services/users.dart';
import 'package:iq_project/components/login_2.dart';
import 'package:image_picker/image_picker.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final UserServices userServices = UserServices();
  final User currentUser = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  Map<String, dynamic>? userData;
  Uint8List? _image;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    getProfilePicture();
  }

  Future<void> selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return ShowMessageHelper.showMessage(
          context: context, text: tr("no_photo"));
    }

    try {
      final String userEmail = currentUser.email ?? "unknown_user";
      final storageRef = _storage.ref();
      final imageRef = storageRef.child(userEmail);
      final imageBytes = await image.readAsBytes();
      await imageRef.putData(imageBytes);
      setState(() {
        _image = imageBytes;
      });
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> getProfilePicture() async {
    final String userEmail = currentUser.email ?? "unknown_user";
    try {
      final storageRef = _storage.ref().child(userEmail);
      print("Fetching image for: $userEmail");
      final imageBytes = await storageRef.getData();
      if (imageBytes != null) {
        setState(() {
          _image = imageBytes;
        });
      } else {
        print('No profile picture found');
      }
    } catch (e) {
      print('Error fetching profile picture: $e');
    }
  }

  Future<void> deleteAccount() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          tr("confirm_delete"),
          style: TextStyle(color: Colors.orange),
        ),
        content: Text(tr("delete_account_confirmation")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr("cancel")),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(tr("delete")),
          ),
        ],
      ),
    );

    if (confirm) {
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
      DateTime currentDate = DateTime.now();
      DateTime minDate =
          DateTime(currentDate.year - 16, currentDate.month, currentDate.day);
      int age = currentDate.year - _picked.year;

      if (_picked.isAfter(minDate)) {
        ShowMessageHelper.showMessage(
            context: context, text: tr("age_restriction_message"));
      } else if (value.trim().isNotEmpty) {
        await usersCollection.doc(currentUser.email).update({field: value});
      }
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
          title: Text(tr("my_profile")),
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
                  Center(
                    child: Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: Image.memory(_image!).image,
                              )
                            : CircleAvatar(
                                radius: 64,
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                child: Icon(Icons.person, size: 80),
                              ),
                        Positioned(
                          child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(Icons.add_a_photo)),
                          bottom: -10,
                          left: 80,
                        )
                      ],
                    ),
                  ),
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
                        Text(tr("my_details"),
                            style: TextStyle(color: Colors.grey)),
                        ElevatedButton(
                          onPressed: deleteAccount,
                          child: Text(tr("delete_account")),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            textStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  EditableTextField(
                    label: tr("first_name"),
                    initialValue: user['name'] ?? '',
                    onSaved: (value) => saveField('name', value),
                  ),
                  EditableTextField(
                    label: tr("last_name"),
                    initialValue: user['lastname'] ?? '',
                    onSaved: (value) => saveField('lastname', value),
                  ),
                  EditableTextField(
                    label: tr("country"),
                    initialValue: user['country'] ?? '',
                    onSaved: (value) => saveField('country', value),
                  ),
                  EditableTextField(
                    label: tr("city"),
                    initialValue: user['city'] ?? '',
                    onSaved: (value) => saveField('city', value),
                  ),
                  EditableTextField(
                    label: tr("birth_date"),
                    initialValue: user['date'] ?? '',
                    onSaved: (value) => _selectDate('date', value),
                  ),
                  EditableTextField(
                    label: tr("phone_number"),
                    initialValue: user['phoneNumber'] ?? '',
                    onSaved: (value) => saveField('phoneNumber', value),
                  ),
                  EditableTextField(
                    label: tr("language"),
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
                      tr("change_password_prompt"),
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
                      child: Text(tr("save_changes")),
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
                  child: Text('${tr("error")}: ${snapshot.error}'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
