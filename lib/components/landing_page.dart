import 'dart:convert';
import 'package:iq_project/components/localization.dart';
import 'package:iq_project/services/api_ose.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:iq_project/components/drawer.dart';
import 'package:iq_project/components/custom_button.dart';
import 'package:iq_project/models/train_destinations.dart';
import 'package:iq_project/services/users.dart';

void main() {
  runApp(EasyLocalization(
    supportedLocales: [Locale('el', 'GR'), Locale('en', 'US')],
    path: 'assets/translations',
    fallbackLocale: Locale('en', 'US'),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'Home Page',
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserServices userServices = UserServices();
  final User? currentUser = FirebaseAuth.instance.currentUser!;
  final ApiService apiService = ApiService();
  String startCity = "";
  String destCity = "";
  TextEditingController startingPoint = TextEditingController();
  TextEditingController destination = TextEditingController();
  TextEditingController startingDate = TextEditingController();
  TextEditingController destinationDate = TextEditingController();
  DateTime? startDate;
  final user = FirebaseAuth.instance.currentUser!;
  bool isSwitched = false;
  List<String> greeceCities = [];

  List<String> countryNames = [];
  Map<String, List<String>> countryCities = {};
  List<String> cities = [];
  static const IconData directions_boat_outlined =
      IconData(0xefc2, fontFamily: 'MaterialIcons');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(greeceCities);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade600,
        title: Text("home".tr()),
        actions: [LocalizationCheck()],
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
                          'assets/images/logotry.png',
                          width: 400,
                          height: 150,
                        ),
                        Text(
                          tr('welcome_message', args: [user!['name']]),
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
                                text: tr('airplane'),
                                onPressed: () {}),
                            SizedBox(
                              width: 5,
                            ),
                            CustomButton(
                                icon: Icons.train,
                                text: tr('train'),
                                onPressed: () {}),
                            SizedBox(
                              width: 5,
                            ),
                            CustomButton(
                                icon: directions_boat_outlined,
                                text: tr('ship'),
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
                                      (TextEditingValue startValue) async {
                                    if (startValue.text.toString() == '') {
                                      return const Iterable<String>.empty();
                                    }
                                    try {
                                      return await apiService.searchPlacename(
                                          startValue.text.toString());
                                    } catch (e) {
                                      print('Error fetching suggestions: $e');
                                      return const Iterable<String>.empty();
                                    }
                                  },
                                  onSelected: (option) => setState(() {
                                    startCity = option;
                                  }),
                                  initialValue:
                                      TextEditingValue(text: startCity),
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          fieldTextEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextFormField(
                                      controller: fieldTextEditingController,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        labelText: tr('starting_point'),
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
                                  setState(() {
                                    final temp = destCity;
                                    destCity = startCity;
                                    startCity = temp;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Autocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue startValue) async {
                                    if (startValue.text.toString() == '') {
                                      return const Iterable<String>.empty();
                                    }
                                    try {
                                      return await apiService.searchPlacename(
                                          startValue.text.toString());
                                    } catch (e) {
                                      print('Error fetching suggestions: $e');
                                      return const Iterable<String>.empty();
                                    }
                                  },
                                  onSelected: (option) => setState(() {
                                    destCity = option;
                                  }),
                                  initialValue:
                                      TextEditingValue(text: destCity),
                                  fieldViewBuilder: (context,
                                      fieldTextEditingController,
                                      focusNode,
                                      onFieldSubmitted) {
                                    return TextFormField(
                                      controller: fieldTextEditingController,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        labelText: tr('destination'),
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
                              tr('from'),
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            IconButton(
                              onPressed: () {
                                _selectDate();
                              },
                              icon: Icon(Icons.calendar_month),
                              color: Colors.grey.shade600,
                            ),
                            Text(startingDate.text),
                            SizedBox(
                              width: 130,
                            ),
                            if (startingDate.text.isNotEmpty)
                              Text(
                                tr('add_return_date'),
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            if (startingDate.text.isNotEmpty)
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
                                        destinationDate.clear();
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
                                tr('return'),
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              IconButton(
                                  onPressed: () {
                                    _selectReturn();
                                  },
                                  icon: Icon(Icons.calendar_month),
                                  color: Colors.grey.shade600),
                              Text(destinationDate.text),
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
        startDate = _picked;
        startingDate.text = _picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _selectReturn() async {
    DateTime minDate = startDate ?? DateTime.now();
    DateTime maxDate = DateTime(minDate.year + 2, minDate.month, minDate.day);
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: minDate,
        firstDate: minDate,
        lastDate: maxDate);

    if (_picked != null) {
      setState(() {
        destinationDate.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
