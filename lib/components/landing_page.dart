import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:iq_project/components/choose_drawer.dart';
import 'package:iq_project/components/custom_button.dart';
import 'package:iq_project/components/eggrafh.dart';
import 'package:iq_project/components/localization.dart';
import 'package:iq_project/components/login.dart';
import 'package:iq_project/components/login_2.dart';
import 'package:iq_project/components/message_helper.dart';
import 'package:iq_project/components/payment.dart';
import 'package:iq_project/components/train_results.dart';
import 'package:iq_project/models/train_destinations.dart';
import 'package:iq_project/services/api_ose.dart';
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
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final ApiService apiService = ApiService();
  String startCity = "";
  String destCity = "";
  String startCityId = "";
  String destCityId = "";

  TextEditingController destination = TextEditingController();
  TextEditingController startingDate = TextEditingController();
  TextEditingController destinationDate = TextEditingController();
  DateTime? startDate;
  DateTime? returnDate;
  bool isSwitched = false;
  File? image;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool hasSearched = false;
  List<TrainTrip> results = [];
  List<TrainTrip> results2 = [];

  String? _imageUrl;
  bool hasResults = false;

  static const IconData directions_boat_outlined =
      IconData(0xefc2, fontFamily: 'MaterialIcons');
  DateTime _selectedDate = DateTime.now();

  int _adults = 1; // Add a variable to hold the number of adults
  bool isTrainSelected = true;
  @override
  void initState() {
    super.initState();
  }

  void onSearchButtonPressed() async {
    int startId = int.tryParse(startCityId) ?? 0;
    int destId = int.tryParse(destCityId) ?? 0;
    DateTime? selectedDate = startDate;
    DateTime? selectedReturn = returnDate;

    if (selectedDate == null) {
      ShowMessageHelper.showMessage(
          context: context, text: tr("departure_date"));
    } else if (selectedReturn == null && isSwitched) {
      ShowMessageHelper.showMessage(context: context, text: tr("return_date"));
    } else if (startId == 0) {
      ShowMessageHelper.showMessage(
          context: context, text: tr("enter_departure"));
    } else if (destId == 0) {
      ShowMessageHelper.showMessage(
          context: context, text: tr("enter_destination"));
    }

    final responseBody =
        await apiService.sendRequest(startId, destId, selectedDate!, _adults);

    if (responseBody != null) {
      final data = jsonDecode(responseBody);
      if (data != null && data['solutions'] != null) {
        List<TrainTrip> fetchedTrips = [];
        for (var eachTrip in data['solutions']) {
          final trip = TrainTrip.fromJson(eachTrip);
          fetchedTrips.add(trip);
        }

        setState(() {
          results = fetchedTrips;
          hasSearched = true;
          hasResults = true;
        });
      } else {
        setState(() {
          results = [];
          hasSearched = true;
          hasResults = false;
        });
      }
    } else {
      setState(() {
        results = [];
        hasSearched = true;
        hasResults = false;
      });
    }
    //Return results

    if (isSwitched && returnDate != null) {
      final responseBody = await apiService.sendRequest(
          destId, startId, selectedReturn!, _adults);

      if (responseBody != null) {
        final data = jsonDecode(responseBody);
        if (data != null && data['solutions'] != null) {
          List<TrainTrip> fetchedTrips2 = [];
          for (var eachTrip in data['solutions']) {
            final trip = TrainTrip.fromJson(eachTrip);
            fetchedTrips2.add(trip);
          }

          setState(() {
            results2 = fetchedTrips2;
            hasSearched = true;
            hasResults = true;
          });
        } else {
          setState(() {
            results2 = [];
            hasSearched = true;
            hasResults = false;
          });
        }
      } else {
        setState(() {
          results2 = [];
          hasSearched = true;
          hasResults = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange.shade600,
          title: Text("home".tr()),
          actions: [
            LocalizationCheck(),
            currentUser == null
                ? TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpForm()),
                      );
                    },
                    child: Text(
                      tr('sign_up'),
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : TextButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        // Navigate to login page after successful sign out
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => login()),
                        );
                      } catch (e) {
                        print("Error signing out: $e");
                      }
                    },
                    child: Text(
                      tr('logout'),
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  )
          ],
        ),
        drawer: const chooseDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    // First container: Photo and welcome message
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/logotry.png',
                            width: 400,
                            height: 150,
                          ),
                          Text(
                            tr('welcome_message'),
                            style: const TextStyle(
                                wordSpacing: 2,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Second container: Rest of the page
              buildForm(context),
            ],
          ),
        ));
  }

  Widget buildForm(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CustomButton(
                //     icon: Icons.airplanemode_active,
                //     text: tr('airplane'),
                //     onPressed: () {}),
                SizedBox(
                  width: 5,
                ),
                CustomButton(
                  icon: Icons.train,
                  text: tr('train'),
                  onPressed: () {
                    setState(() {
                      isTrainSelected = true;
                    });
                  },
                ),
                SizedBox(width: 5),
                CustomButton(
                  icon: directions_boat_outlined,
                  text: tr('ship'),
                  onPressed: () {
                    setState(() {
                      isTrainSelected = false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Autocomplete<Map<String, String>>(
                      optionsBuilder:
                          (TextEditingValue textEditingValue) async {
                        if (textEditingValue.text.length < 3) {
                          return const Iterable<Map<String, String>>.empty();
                        }
                        try {
                          return await apiService
                              .searchPlacename(textEditingValue.text);
                        } catch (e) {
                          print('Error fetching suggestions: $e');
                          return const Iterable<Map<String, String>>.empty();
                        }
                      },
                      //ti tha emfanizetai sto dropdown
                      displayStringForOption: (option) => option['label']!,

                      onSelected: (option) => setState(() {
                        startCity = option['label'] as String;
                        startCityId = option['locationId'].toString();
                      }),
                      initialValue: TextEditingValue(text: startCity),
                      fieldViewBuilder:
                          (context, controller, focusNode, onEditingComplete) {
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            labelText: tr('starting_point'),
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
                      String tempCity = startCity;
                      String tempCityId = startCityId;
                      setState(() {
                        startCity = destCity;
                        startCityId = destCityId;
                        destCity = tempCity;
                        destCityId = tempCityId;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Autocomplete<Map<String, String>>(
                      optionsBuilder:
                          (TextEditingValue textEditingValue) async {
                        if (textEditingValue.text.length < 3) {
                          return const Iterable<Map<String, String>>.empty();
                        }
                        try {
                          return await apiService
                              .searchPlacename(textEditingValue.text);
                        } catch (e) {
                          print('Error fetching suggestions: $e');
                          return const Iterable<Map<String, String>>.empty();
                        }
                      },
                      displayStringForOption: (option) => option['label']!,
                      onSelected: (option) => setState(() {
                        destCity = option['label'] as String;
                        destCityId = option['locationId'].toString();
                      }),
                      initialValue: TextEditingValue(text: destCity),
                      fieldViewBuilder:
                          (context, controller, focusNode, onEditingComplete) {
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            labelText: tr('destination'),
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
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
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
                  ],
                ),
                if (startingDate.text.isNotEmpty)
                  Text(
                    tr('return'),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                if (startingDate.text.isNotEmpty)
                  SizedBox(
                    width: 5,
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
                    tr('add_return_date'),
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
            SizedBox(
              height: 15,
            ),
            // New Section for Number of Adults
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr('number_of_adults'),
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (_adults > 1) _adults--;
                        });
                      },
                    ),
                    Text(
                      _adults.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _adults++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
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
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const payment())),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                fixedSize: Size(200, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(tr("checkout")),
            ),
            if (hasSearched)
              Container(
                padding: EdgeInsets.all(16.0),
                child: hasResults
                    ? TrainResults(
                        results: results,
                        results2: results2,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          tr("no_results"),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
              ),
          ],
        ),
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
        returnDate = _picked;
        destinationDate.text = DateFormat('yyyy-MM-dd').format(_picked);
      });
    }
  }
}
