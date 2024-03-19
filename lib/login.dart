import 'package:flutter/material.dart';
import 'package:iq_project/eggrafh.dart';
import 'package:iq_project/services/auth.dart';

// void main() {
//   runApp(login());
// }

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
class YourContent extends StatelessWidget {
  bool isChecked = false;
  @override
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
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: "Enter your email",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.vpn_key,
                    ),
                    hintText: "Enter your password",
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // remember me
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Remember me',
                      style: TextStyle(color: Colors.grey),
                    ),
                    checkExample(),
                  ],
                ),
                TextButton(
                  onPressed: () {},
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
                onPressed: () {},
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
            )
          ],
        ),
      ),
    );
  }
}

class checkExample extends StatefulWidget {
  const checkExample({super.key});

  @override
  State<checkExample> createState() => _checkExampleState();
}

class _checkExampleState extends State<checkExample> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.grey,
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
