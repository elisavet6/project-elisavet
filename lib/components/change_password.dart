import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iq_project/components/landing_page.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool passwordVisible = true;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();

  Future<bool> _verifyOldPassword() async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: oldPasswordController.text,
      );
      await currentUser.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _changePassword() async {
    try {
      await currentUser.updatePassword(newPasswordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password changed successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong with your new password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("N E W  P A S S W O R D"),
        backgroundColor: Colors.orange.shade600,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 80,
                width: 60,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: oldPasswordController,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Enter your old password",
                    floatingLabelStyle:
                        TextStyle(color: Colors.orange.shade700),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange.shade700),
                    ),
                    suffixIcon: IconButton(
                      color: Colors.grey,
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your old password';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 80,
                width: 60,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: newPasswordController,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Enter your new password",
                    floatingLabelStyle:
                        TextStyle(color: Colors.orange.shade700),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange.shade700),
                    ),
                    suffixIcon: IconButton(
                      color: Colors.grey,
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 80,
                width: 60,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Confirm your new password",
                    floatingLabelStyle:
                        TextStyle(color: Colors.orange.shade700),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange.shade700),
                    ),
                    suffixIcon: IconButton(
                      color: Colors.grey,
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    } else if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 50),
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Επαλήθευση του παλαιού κωδικού μέσω Firebase Authentication
                      bool oldPasswordValid = await _verifyOldPassword();
                      if (oldPasswordValid) {
                        await _changePassword();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Old password is incorrect'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Text("Save changes"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    fixedSize: Size(300, 50),
                    backgroundColor: Colors.orange.shade700,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
