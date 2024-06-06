import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
  bool newPasswordVisible = true;
  bool confirmPasswordVisible = true;
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
          content: Text('password_changed_successfully'.tr()),
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
          content: Text('something_went_wrong'.tr()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("new_password".tr()),
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
                    labelText: "enter_old_password".tr(),
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
                      return 'please_enter_old_password'.tr();
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
                  obscureText: newPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "enter_new_password".tr(),
                    floatingLabelStyle:
                        TextStyle(color: Colors.orange.shade700),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange.shade700),
                    ),
                    suffixIcon: IconButton(
                      color: Colors.grey,
                      icon: Icon(
                        newPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            newPasswordVisible = !newPasswordVisible;
                          },
                        );
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_new_password'.tr();
                    } else if (value.length < 6) {
                      return 'password_min_length'.tr();
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
                  obscureText: confirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "confirm_new_password".tr(),
                    floatingLabelStyle:
                        TextStyle(color: Colors.orange.shade700),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange.shade700),
                    ),
                    suffixIcon: IconButton(
                      color: Colors.grey,
                      icon: Icon(
                        confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            confirmPasswordVisible = !confirmPasswordVisible;
                          },
                        );
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_confirm_new_password'.tr();
                    } else if (value != newPasswordController.text) {
                      return 'passwords_do_not_match'.tr();
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
                      bool oldPasswordValid = await _verifyOldPassword();
                      if (oldPasswordValid) {
                        await _changePassword();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('old_password_incorrect'.tr()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Text("save_changes".tr()),
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
