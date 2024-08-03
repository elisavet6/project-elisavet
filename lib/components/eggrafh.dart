import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/model/select_status_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:iq_project/components/landing_page.dart';
import 'package:iq_project/components/localization.dart';
import 'package:iq_project/components/login.dart';
import 'package:iq_project/components/login_2.dart';
import 'package:iq_project/components/message_helper.dart';
import 'package:http/http.dart' as http;
import 'package:iq_project/models/countries.dart';
import 'package:iq_project/services/users.dart';

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
  TextEditingController codecontroller = TextEditingController();
  TextEditingController citycontroller = TextEditingController();
  List<String> countryNames = [];
  Map<String, List<String>> countryCities = {};
  List<String> cities = [];

  @override
  void initState() {
    super.initState();
    getCountries();
  }

  Future<void> getCountries() async {
    var response =
        await http.get(Uri.https('countriesnow.space', 'api/v0.1/countries'));
    var jsonData = jsonDecode(response.body);
    List<TheCountry> countries = [];
    for (var eachCountry in jsonData['data']) {
      countries.add(TheCountry.fromJson(eachCountry));
    }
    setState(() {
      countryNames = countries.map((country) => country.country).toList();
      countryCities = {
        for (var country in countries) country.country: country.cities
      };
    });
  }

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
        'city': citycontroller.text.trim(),
        'language': languagecontroller.text.trim(),
        'phoneNumber': phoneNumbercontroller.text.trim(),
        'country code': codecontroller.text.trim(),
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
            MaterialPageRoute(builder: (context) => Home()),
          );
        } else {
          ShowMessageHelper.showMessage(
              context: context, text: tr("password_confirm_error"));
        }
      } catch (e) {
        ShowMessageHelper.showMessage(
            context: context, text: "${tr("signup_failed")}: $e");
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
    citycontroller.dispose();
    phoneNumbercontroller.dispose();
    codecontroller.dispose();
    super.dispose();
  }

  bool passwordVisible = true;
  bool confirmVisible = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    getCountries();
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('sign_up')),
        backgroundColor: Colors.orange.shade700,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: LocalizationCheck(),
              ),
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
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(
                      tr("are_you_member"),
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => login()),
                          );
                        },
                        child: Text(tr("sign_in"),
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                decoration: TextDecoration.underline))),
                  ]),
                  TextFormField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                      labelText: tr("first_name"),
                      floatingLabelStyle:
                          TextStyle(color: Colors.orange.shade700),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange.shade700),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr("enter_first_name");
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: lastNamecontroller,
                    decoration: InputDecoration(
                      labelText: tr("last_name"),
                      floatingLabelStyle:
                          TextStyle(color: Colors.orange.shade700),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange.shade700),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr("enter_last_name");
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: datecontroller,
                    decoration: InputDecoration(
                      labelText: tr("birth_date"),
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
                        return tr("enter_birth_date");
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return countryNames;
                      }
                      return countryNames.where((String country) {
                        return country
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selection) {
                      setState(() {
                        countrycontroller.text = selection;
                        cities = countryCities[selection] ?? [];
                      });
                    },
                    fieldViewBuilder: (BuildContext context, countrycontroller,
                        FocusNode focusNode, VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        controller: countrycontroller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: tr("country"),
                          floatingLabelStyle:
                              TextStyle(color: Colors.orange.shade700),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orange.shade700),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return cities;
                      }
                      return cities.where((String city) {
                        return city
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selection) {
                      setState(() {
                        citycontroller.text = selection;
                      });
                    },
                    fieldViewBuilder: (BuildContext context, citycontroller,
                        FocusNode focusNode, VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        controller: citycontroller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: tr("city"),
                          floatingLabelStyle:
                              TextStyle(color: Colors.orange.shade700),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orange.shade700),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: languagecontroller,
                    decoration: InputDecoration(
                      labelText: tr("language"),
                      floatingLabelStyle:
                          TextStyle(color: Colors.orange.shade700),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange.shade700),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr("enter_language");
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: phoneNumbercontroller,
                    decoration: InputDecoration(
                        labelText: tr("phone_number"),
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
                                      codecontroller.text = code.dialCode;
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
                      labelText: tr("email"),
                      floatingLabelStyle:
                          TextStyle(color: Colors.orange.shade700),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange.shade700),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr("enter_email");
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: passwordcontroller,
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                      labelText: tr("password"),
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
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr("enter_password");
                      } else if (value.length < 6) {
                        return 'Your password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: confirmPwcontroller,
                    obscureText: confirmVisible,
                    decoration: InputDecoration(
                      labelText: tr("confirm_password"),
                      floatingLabelStyle:
                          TextStyle(color: Colors.orange.shade700),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange.shade700),
                      ),
                      suffixIcon: IconButton(
                        color: Colors.grey,
                        icon: Icon(
                          confirmVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            confirmVisible = !confirmVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  ElevatedButton(
                    onPressed: () {
                      if (namecontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context, text: tr("enter_first_name"));
                      } else if (lastNamecontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context, text: tr("enter_last_name"));
                      } else if (datecontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context, text: tr("enter_birth_date"));
                      } else if (countrycontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context, text: tr("enter_country"));
                      } else if (languagecontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context, text: tr("enter_language"));
                      } else if (citycontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context, text: tr("enter_city"));
                      } else if (phoneNumbercontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context, text: tr("enter_phone_number"));
                      } else if (emailcontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context, text: tr("enter_email"));
                      } else if (passwordcontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context, text: tr("enter_password"));
                      } else if (passwordcontroller.text.length < 6) {
                        ShowMessageHelper.showMessage(
                            context: context, text: tr("min_password"));
                      } else if (confirmPwcontroller.text.isEmpty) {
                        ShowMessageHelper.showMessage(
                            context: context,
                            text: tr("enter_confirm_password"));
                      }
                      //  else if (confirmPwcontroller != passwordcontroller) {
                      //   ShowMessageHelper.showMessage(
                      //       context: context, text: tr("password_mismatch"));
                      // }
                      else {
                        signUp();
                      }
                    },
                    child: Text(tr("sign_up")),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
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
          ShowMessageHelper.showMessage(context: context, text: tr("min_age"));
        } else {
          // Update the text field if the age is valid
          datecontroller.text = _picked.toString().split(" ")[0];
        }
      });
    }
  }
}
