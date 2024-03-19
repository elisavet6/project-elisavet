import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iq_project/landing_page.dart';

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
  String email = "",
      name = "",
      password = "",
      lastName = "",
      date = "",
      country = "",
      language = "",
      phoneNumber = "";
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController lastNamecontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  TextEditingController countrycontroller = TextEditingController();
  TextEditingController languagecontroller = TextEditingController();
  TextEditingController phoneNumbercontroller = TextEditingController();

  registration() async {
    if (password != "" &&
        namecontroller.text != "" &&
        emailcontroller.text != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Registered Successfully",
          style: TextStyle(fontSize: 20.0),
        )));
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0),
              )));
        }
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(40.0),
            width: 900,
            key: _formKey,
            child: Form(
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
                    ),
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
                  SizedBox(height: 35),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          email = emailcontroller.text;
                          name = namecontroller.text;
                          password = passwordcontroller.text;
                        });
                      }
                      registration();
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('You must be at least 16 years old to register')),
          );
        } else {
          // Update the text field if the age is valid
          datecontroller.text = _picked.toString().split(" ")[0];
        }
      });
    }
  }
}
