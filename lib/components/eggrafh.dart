import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:iq_project/components/landing_page.dart';
import 'package:iq_project/components/login_2.dart';
import 'package:iq_project/components/message_helper.dart';

void main() {
  runApp(MaterialApp(
    home: SignUpForm(),
  ));
}

class SignUpForm extends StatefulWidget {
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final CountryCodePick = const FlCountryCodePicker();
  CountryCode? countryCode;

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController lastNamecontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  TextEditingController countrycontroller = TextEditingController();
  TextEditingController languagecontroller = TextEditingController();
  TextEditingController phoneNumbercontroller = TextEditingController();
  TextEditingController confirmPwcontroller = TextEditingController();
  TextEditingController code = TextEditingController();

  Future<void> addUser(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'name': namecontroller.text.trim(),
        'lastname': lastNamecontroller.text.trim(),
        'date': datecontroller.text.trim(),
        'country': countrycontroller.text.trim(),
        'language': languagecontroller.text.trim(),
        'phoneNumber': phoneNumbercontroller.text.trim(),
        'email': emailcontroller.text.trim(),
      });
    }
  }

  Future signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (passwordcontroller.text.trim() == confirmPwcontroller.text.trim()) {
          UserCredential? userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailcontroller.text.trim(),
                  password: passwordcontroller.text.trim());
          addUser(userCredential);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Home()), // Ensure 'Home' is properly defined and expecting no mandatory arguments.
          );
        } else {
          ShowMessageHelper.showMessage(
              context: context, text: "The confirmed password doesn't match");
        }
      } catch (e) {
        ShowMessageHelper.showMessage(
            context: context, text: "Failed to sign up: $e");
      }
    }
  }

  void dispose() {
    emailcontroller.dispose();
    namecontroller.dispose();
    lastNamecontroller.dispose();
    datecontroller.dispose();
    languagecontroller.dispose();
    countrycontroller.dispose();
    phoneNumbercontroller.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.orange.shade700,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Are you a member?,',
                style: TextStyle(fontSize: 15),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => login_2()),
                    );
                  },
                  child: const Text('Sign In',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          decoration: TextDecoration.underline)))
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(40.0),
            width: 900,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  TextFormField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                      labelText: "First Name *",
                      floatingLabelStyle:
                          TextStyle(color: Colors.orange.shade700),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange.shade700),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your First Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: lastNamecontroller,
                    decoration: InputDecoration(
                      labelText: "Last Name *",
                      floatingLabelStyle:
                          TextStyle(color: Colors.orange.shade700),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange.shade700),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your Last Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: datecontroller,
                    decoration: InputDecoration(
                      labelText: "Birth Date *",
                      filled: true,
                      prefixIcon: Icon(
                        Icons.calendar_month,
                      ),
                      floatingLabelStyle:
                          TextStyle(color: Colors.orange.shade700),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange.shade700),
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your Birth Date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: countrycontroller,
                    decoration: InputDecoration(
                      labelText: "Country *",
                      floatingLabelStyle:
                          TextStyle(color: Colors.orange.shade700),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange.shade700),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your Country';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: languagecontroller,
                    decoration: InputDecoration(
                      labelText: "Language *",
                      floatingLabelStyle:
                          TextStyle(color: Colors.orange.shade700),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange.shade700),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your Language';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: phoneNumbercontroller,
                    decoration: InputDecoration(
                        labelText: "Phone Number *",
                        floatingLabelStyle:
                            TextStyle(color: Colors.orange.shade700),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange.shade700),
                        ),
                        prefixIcon: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 6),
                          // margin: const EdgeInsets.symmetric(horizontal: 1),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final code = await CountryCodePick.showPicker(
                                      context: context);
                                  if (code != null) {
                                    setState(() {
                                      countryCode = code;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade600,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    countryCode?.dialCode ?? "+1",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your Phone Number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      labelText: "e-mail *",
                      floatingLabelStyle:
                          TextStyle(color: Colors.orange.shade700),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange.shade700),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your e-mail';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password *",
                      floatingLabelStyle:
                          TextStyle(color: Colors.orange.shade700),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange.shade700),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: confirmPwcontroller,
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                      labelText: "Confirm Password *",
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
                        return 'Enter your First Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 35),
                  ElevatedButton(
                    onPressed: () {
                      if (namecontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context,
                            text: "Please enter your First Name!");
                      } else if (lastNamecontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context,
                            text: "Please enter your Last Name!");
                      } else if (datecontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context,
                            text: "Please enter your birth date!");
                      } else if (countrycontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context,
                            text: "Please enter your country!");
                      } else if (languagecontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context,
                            text: "Please enter your language!");
                      } else if (phoneNumbercontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context,
                            text: "Please enter your phone number!");
                      } else if (emailcontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context, text: "Please enter your email!");
                      } else if (passwordcontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context, text: "Please enter a password!");
                      } else if (confirmPwcontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context,
                            text: "Please confirm your password!");
                      } else {
                        signUp();
                      }
                    },
                    child: Text('Sign Up'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange.shade700,
                      fixedSize: Size(300, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now());

    if (_picked != null) {
      setState(() {
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
        } else {
          // Update the text field if the age is valid
          datecontroller.text = _picked.toString().split(" ")[0];
        }
      });
    }
  }
}
