import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iq_project/components/eggrafh.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailcontroller = TextEditingController();
  void dispose() {
    emailcontroller.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailcontroller.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Email sent.'),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Your email is not correct'),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Password Reset'),
          backgroundColor: Colors.orange.shade600,
        ),
        body: Column(
          children: [
            SizedBox(height: 80),
            Text(
              'Type your email:',
              style: TextStyle(fontSize: 17),
            ),
            Padding(
              padding: const EdgeInsets.all(35),
              child: TextField(
                controller: emailcontroller,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                passwordReset();
              },
              child: Text("Reset password"),
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
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpForm()),
                );
              },
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ));
  }
}
