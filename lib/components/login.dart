import 'package:flutter/material.dart';
import 'package:iq_project/components/anonymous_home.dart';
import 'package:iq_project/components/eggrafh.dart';
import 'package:iq_project/components/landing_page.dart';
import 'package:iq_project/components/message_helper.dart';

import 'package:iq_project/services/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:iq_project/components/forgot_pw.dart';

void main() {
  runApp(
    login(),
  );
}

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.orange.shade700,
                  Colors.orange.shade500,
                  Colors.orange.shade300,
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 1),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/images/logotry.png',
                        width: 400,
                        height: 150,
                      ),
                      Text(
                        "Welcome!",
                        style: TextStyle(
                            color: Colors.white, fontSize: 40, height: 1),
                      ),
                    ],
                  ),
                ),
                if (constraints.maxWidth > 600)
                  Center(
                    child: Container(
                      width: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: YourContent(),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                      ),
                      child: YourContent(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

//Periexomeno plaisiou (pedia symplhrwshs)
class YourContent extends StatefulWidget {
  @override
  State<YourContent> createState() => _YourContentState();
}

class _YourContentState extends State<YourContent> {
  bool passwordVisible = true;
  bool isChecked = false;
  TextEditingController emailcontroll = TextEditingController();
  TextEditingController passwordcontroll = TextEditingController();
  Future SignIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroll.text.trim(),
        password: passwordcontroll.text.trim(),
      );
    } catch (e) {
      String errorMessage = 'An error occurred';
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect password';
        }
      }
      // Show the error message to the user
      ShowMessageHelper.showMessage(
          context: context, text: "Email or password is wrong");
    }
  }

  @override
  void dispose() {
    emailcontroll.dispose();
    passwordcontroll.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60),
          topRight: Radius.circular(60),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              "Sign In",
              style: TextStyle(
                  color: Colors.orange.shade700, fontSize: 30, height: 2),
            ),
            SizedBox(height: 15),
            Column(
              children: <Widget>[
                TextField(
                  controller: emailcontroll,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: "Enter your email",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: passwordVisible,
                  controller: passwordcontroll,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.vpn_key,
                    ),
                    hintText: "Enter your password",
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
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ForgotPassword();
                    }));
                  },
                  child: Text("Forgot your password?"),
                  style: TextButton.styleFrom(primary: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: ElevatedButton(
                onPressed: () {
                  SignIn();
                },
                child: Text("Sign In"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(5),
                  fixedSize: Size(300, 50),
                  backgroundColor: Colors.orange.shade700,
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpForm()),
                );
              },
              child: Text('Sign Up'),
              style: TextButton.styleFrom(primary: Colors.grey),
            ),
            TextButton(
              onPressed: () {
                // await FirebaseAuth.instance.signInAnonymously();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Anonymous_Home()),
                );
              },
              child: Text('or Sign in Anonymously'),
              style: TextButton.styleFrom(primary: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
