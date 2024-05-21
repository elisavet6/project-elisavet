import 'package:flutter/material.dart';
import 'package:iq_project/components/eggrafh.dart';
import 'package:iq_project/components/login_2.dart';

class anonymous_drawer extends StatefulWidget {
  const anonymous_drawer({super.key});

  @override
  State<anonymous_drawer> createState() => _anonymous_drawerState();
}

class _anonymous_drawerState extends State<anonymous_drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.orange.shade800,
      child: Column(children: [
        const DrawerHeader(
            child: Icon(
          Icons.person,
          color: Colors.white,
          size: 60,
        )),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: Text(
              "H O M E",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => anonymous_drawer())),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: ListTile(
            leading: Icon(
              Icons.login,
              color: Colors.white,
            ),
            title: Text(
              "S I G N  I N",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => login_2()),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.white,
            ),
            title: Text(
              "S I G N  U P",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpForm()),
            ),
          ),
        ),
      ]),
    );
  }
}
