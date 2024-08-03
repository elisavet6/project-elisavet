import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iq_project/components/eggrafh.dart';
import 'package:iq_project/components/landing_page.dart';
import 'package:iq_project/components/localization.dart';

import 'package:iq_project/components/message_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  LocalizationCheck localizationCheck = LocalizationCheck();
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Tooltip(
                  message: tr('switch_language'),
                  child: Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: LocalizationCheck()),
                ),
                SizedBox(height: 1),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logotry.png',
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
                      decoration: const BoxDecoration(
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
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
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
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(
                tr('sign_in'),
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
                      hintText: tr('enter_email'),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    obscureText: passwordVisible,
                    controller: passwordcontroll,
                    decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      hintText: tr('enter_password'),
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
                  ),
                ],
              ),
              SizedBox(height: 20),
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
                    child: Text(
                      tr('forgot_password'),
                      style: TextStyle(color: Colors.grey),
                    ),
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
                  child: Text(tr('sign_in_button')),
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
                child: Text(
                  tr('sign_up'),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                child: Text(
                  tr('or_sign_in_anonymously'),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
