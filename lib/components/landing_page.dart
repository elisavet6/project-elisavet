import 'dart:convert';
import 'package:iq_project/components/localization.dart';
import 'package:iq_project/components/payment.dart';
import 'package:iq_project/services/api_ose.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:iq_project/components/drawer.dart';
import 'package:iq_project/components/custom_button.dart';

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
  String startCityId = "";
  String destCityId = "";

  TextEditingController destination = TextEditingController();
  TextEditingController startingDate = TextEditingController();
  TextEditingController destinationDate = TextEditingController();
  DateTime? startDate;
  DateTime? destDate;
  final user = FirebaseAuth.instance.currentUser!;
  bool isSwitched = false;

  static const IconData directions_boat_outlined =
      IconData(0xefc2, fontFamily: 'MaterialIcons');
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  void onSearchButtonPressed() {
    int startId = int.tryParse(startCityId) ?? 0;
    int destId = int.tryParse(destCityId) ?? 0;
    DateTime? selectedDate = startDate;
    apiService.sendRequest(startId, destId, selectedDate!);
    print({selectedDate});
    print(startId);
    print(destId);
  }

  @override
  Widget build(BuildContext context) {
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
                              fontSize: 17,
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
                                child: Autocomplete<Map<String, String>>(
                                  optionsBuilder: (TextEditingValue
                                      textEditingValue) async {
                                    if (textEditingValue.text.isEmpty) {
                                      return const Iterable<
                                          Map<String, String>>.empty();
                                    }
                                    try {
                                      return await apiService.searchPlacename(
                                          textEditingValue.text);
                                    } catch (e) {
                                      print('Error fetching suggestions: $e');
                                      return const Iterable<
                                          Map<String, String>>.empty();
                                    }
                                  },
                                  //ti tha emfanizetai sto dropdown
                                  displayStringForOption: (option) =>
                                      option['label']!,

                                  onSelected: (option) => setState(() {
                                    startCity = option['label'] as String;
                                    startCityId =
                                        option['locationId'].toString();
                                  }),
                                  initialValue:
                                      TextEditingValue(text: startCity),
                                  fieldViewBuilder: (context, controller,
                                      focusNode, onEditingComplete) {
                                    return TextFormField(
                                      controller: controller,
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
                                    final tempCity = destCity;
                                    final tempCityId = destCityId;
                                    destCity = startCity;
                                    destCityId = startCityId;
                                    startCity = tempCity;
                                    startCityId = tempCityId;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Autocomplete<Map<String, String>>(
                                  optionsBuilder: (TextEditingValue
                                      textEditingValue) async {
                                    if (textEditingValue.text.isEmpty) {
                                      return const Iterable<
                                          Map<String, String>>.empty();
                                    }
                                    try {
                                      return await apiService.searchPlacename(
                                          textEditingValue.text);
                                    } catch (e) {
                                      print('Error fetching suggestions: $e');
                                      return const Iterable<
                                          Map<String, String>>.empty();
                                    }
                                  },
                                  displayStringForOption: (option) =>
                                      option['label']!,
                                  onSelected: (option) => setState(() {
                                    destCity = option['label'] as String;
                                    destCityId =
                                        option['locationId'].toString();
                                  }),
                                  initialValue:
                                      TextEditingValue(text: destCity),
                                  fieldViewBuilder: (context, controller,
                                      focusNode, onEditingComplete) {
                                    return TextFormField(
                                      controller: controller,
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
                            // SizedBox(
                            //   width: 130,
                            // ),
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
                                        isSwitched = false;
                                      });
                                    }
                                  }),
                          ],
                        ),
                        if (isSwitched)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
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
                        ElevatedButton(
                          onPressed: onSearchButtonPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                            fixedSize: Size(200, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            tr('search_trips'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const payment())),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                            fixedSize: Size(200, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(tr("checkout")),
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
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: maxDate,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        startDate = picked;
        startingDate.text = DateFormat('yyyy-MM-dd').format(picked);
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
        destDate = _picked;
        destinationDate.text = DateFormat('yyyy-MM-dd').format(_picked);
      });
    }
  }
}
