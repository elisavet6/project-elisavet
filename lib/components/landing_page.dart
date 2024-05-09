import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iq_project/get_all_users.dart';
import 'package:iq_project/components/login_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:iq_project/components/drawer.dart';
import 'package:iq_project/services/users.dart';

// void main() {
//   runApp(Home());
// }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserServices userServices = UserServices();
  final User? currentUser = FirebaseAuth.instance.currentUser!;

  String startingPoint = "";
  String destination = "";
  final user = FirebaseAuth.instance.currentUser!;

  void showGoogleAutoComplete() async {
    const kGoogleApiKey = "API_KEY";

    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.overlay, // Mode.fullscreen
        language: "en",
        components: [new Component(Component.country, "en")]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade600,
        title: Text("H O M E"),
      ),
      drawer: MyDrawer(),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: UserServices().getUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
              //data recieived
            } else if (snapshot.hasData) {
              //extract data
              Map<String, dynamic>? user = snapshot.data!.data();

              return SingleChildScrollView(
                child: Center(
                  child: Container(
                    child: Form(
                      child: Column(
                        children: [
                          Text(
                            'Welcome ' +
                                user!['name'] +
                                '! Book your next trip!',
                            style: TextStyle(
                                wordSpacing: 2,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                                height: 5),
                          ),
                          SizedBox(height: 50),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        labelText: "Starting Point"),
                                    onChanged: (value) {
                                      setState(() {
                                        startingPoint = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    onTap: () {
                                      showGoogleAutoComplete();
                                    },
                                    decoration: InputDecoration(
                                        labelText: "Destination"),
                                    onChanged: (value) {
                                      setState(() {
                                        destination = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (startingPoint.isNotEmpty &&
                                      destination.isNotEmpty) {
                                    String temp = startingPoint;
                                    startingPoint = destination;
                                    destination = temp;
                                  }
                                });
                              },
                              child: Text('Reverse Locations'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Errors${snapshot.error}'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}




//       body: SingleChildScrollView(
//         child: Center(
//           child: Container(
//             child: Form(
//               child: Column(
                
//                 children: [
//                   Text(
//                     'Welcome ' + UserServices().getUserDetails().user!['name'] + '. Book your next trip!',
//                     style: TextStyle(
//                         wordSpacing: 2,
//                         fontSize: 23,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey.shade700,
//                         height: 5),
//                   ),
//                   SizedBox(height: 50),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextFormField(
//                             decoration:
//                                 InputDecoration(labelText: "Starting Point"),
//                             onChanged: (value) {
//                               setState(() {
//                                 startingPoint = value;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextFormField(
//                             readOnly: true,
//                             onTap: () {
//                               showGoogleAutoComplete();
//                             },
//                             decoration:
//                                 InputDecoration(labelText: "Destination"),
//                             onChanged: (value) {
//                               setState(() {
//                                 destination = value;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           if (startingPoint.isNotEmpty &&
//                               destination.isNotEmpty) {
//                             String temp = startingPoint;
//                             startingPoint = destination;
//                             destination = temp;
//                           }
//                         });
//                       },
//                       child: Text('Reverse Locations'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
