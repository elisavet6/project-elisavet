// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(MaterialApp(home: ReadAllUsers()));
// }

// class ReadAllUsers extends StatefulWidget {
//   const ReadAllUsers({super.key});

//   @override
//   State<ReadAllUsers> createState() => _ReadAllUsersState();
// }

// class _ReadAllUsersState extends State<ReadAllUsers> {
//   List<String> docIds = [];
//   Future<List<String>>? docIdFuture;

//   @override
//   void initState() {
//     super.initState();
//     docIdFuture = getDocId();
//   }

//   Future<List<String>> getDocId() async {
//     List<String> ids = [];
//     var snapshot = await FirebaseFirestore.instance.collection('Users').get();
//     for (var element in snapshot.docs) {
//       ids.add(element.reference.id);
//     }
//     return ids;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Users'),
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(10),
//           child: FutureBuilder<List<String>>(
//               future: docIdFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text("Error: ${snapshot.error}");
//                 } else if (snapshot.hasData) {
//                   return ListView.builder(
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(snapshot.data![index]),
//                         );
//                       });
//                 } else {
//                   return Text("No data");
//                 }
//               }),
//         ));
//   }
// }
