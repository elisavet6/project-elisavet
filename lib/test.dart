import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iq_project/components/drawer.dart';
import 'package:iq_project/components/custom_button.dart';
import 'package:iq_project/models/countries.dart';
import 'package:iq_project/services/users.dart';
import 'package:iq_project/components/custom_button.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    title: 'Home Page',
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserServices userServices = UserServices();
  final User? currentUser = FirebaseAuth.instance.currentUser!;

  TextEditingController startingPoint = TextEditingController();
  TextEditingController destination = TextEditingController();
  TextEditingController startingDateController = TextEditingController();
  TextEditingController destinationDateController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  bool isSwitched = false;

  List<String> greeceCities = [];
  List<String> countryNames = [];
  Map<String, List<String>> countryCities = {};
  List<String> cities = [];
  DateTime? startingDate;

  static const IconData directions_boat_outlined =
      IconData(0xefc2, fontFamily: 'MaterialIcons');

  @override
  void initState() {
    super.initState();
    getGreekCities();
  }

  Future<void> getGreekCities() async {
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
      greeceCities = countryCities['Greece'] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade600,
        title: Text("H O M E"),
      ),
      drawer: MyDrawer(),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            Map<String, dynamic>? user =
                snapshot.data!.data() as Map<String, dynamic>?;

            return SingleChildScrollView(
              child: Center(
                child: Container(
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/images/logotry.png',
                          width: 400,
                          height: 150,
                        ),
                        Text(
                          'Welcome ' + user!['name'] + '! Book your next trip!',
                          style: const TextStyle(
                              wordSpacing: 2,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 3),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                                icon: Icons.airplanemode_active,
                                text: 'Airplane',
                                onPressed: () {}),
                            SizedBox(
                              width: 5,
                            ),
                            CustomButton(
                                icon: Icons.train,
                                text: "Train",
                                onPressed: () {}),
                            SizedBox(
                              width: 5,
                            ),
                            CustomButton(
                                icon: directions_boat_outlined,
                                text: "Ship",
                                onPressed: () {}),
                          ],
                        ),
                        SizedBox(height: 50),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Autocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue StartValue) {
                                    if (StartValue.text == '') {
                                      return greeceCities;
                                    }
                                    return greeceCities.where((String city) {
                                      return city.toLowerCase().contains(
                                          StartValue.text.toLowerCase());
                                    });
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      startingPoint,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextFormField(
                                      controller: startingPoint,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        labelText: "Starting Point",
                                        floatingLabelStyle: TextStyle(
                                            color: Colors.orange.shade700),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.orange.shade700),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.cached_outlined,
                                  color: Colors.orange.shade600,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  final temp = destination.text;
                                  destination.text = startingPoint.text;
                                  startingPoint.text = temp;

                                  print(startingPoint.text);
                                  print(destination.text);
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Autocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue destinationValue) {
                                    if (destinationValue.text == '') {
                                      return greeceCities;
                                    }
                                    return greeceCities.where((String city) {
                                      return city.toLowerCase().contains(
                                          destinationValue.text.toLowerCase());
                                    });
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      destination,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextFormField(
                                      controller: destination,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        labelText: "Destination",
                                        floatingLabelStyle: TextStyle(
                                            color: Colors.orange.shade700),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.orange.shade700),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                              width: 10,
                            ),
                            Text(
                              "From:",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            IconButton(
                              onPressed: () {
                                _selectDate();
                              },
                              icon: Icon(Icons.calendar_month),
                              color: Colors.grey.shade600,
                            ),
                            Text(startingDateController.text),
                            SizedBox(
                              width: 200,
                            ),
                            Switch(
                                value: isSwitched,
                                onChanged: (value) async {
                                  setState(() {
                                    isSwitched = value;
                                  });

                                  if (isSwitched) {
                                    await _selectReturn();
                                  } else {
                                    setState(() {
                                      destinationDateController.clear();
                                    });
                                  }
                                }),
                          ],
                        ),
                        if (isSwitched)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                                width: 10,
                              ),
                              Text(
                                "Return:",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              IconButton(
                                onPressed: () {
                                  _selectReturn();
                                },
                                icon: Icon(Icons.calendar_month),
                                color: Colors.grey.shade600,
                              ),
                              Text(destinationDateController.text),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          print(startingPoint);
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime currentDate = DateTime.now();
    DateTime maxDate =
        DateTime(currentDate.year + 2, currentDate.month, currentDate.day);
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: maxDate);

    if (_picked != null) {
      setState(() {
        startingDate = _picked;
        startingDateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _selectReturn() async {
    DateTime minDate = startingDate ?? DateTime.now();
    DateTime maxDate = DateTime(minDate.year + 2, minDate.month, minDate.day);
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: minDate,
        firstDate: minDate,
        lastDate: maxDate);

    if (_picked != null) {
      setState(() {
        destinationDateController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
