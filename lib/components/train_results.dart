import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iq_project/models/train_destinations.dart';

class TrainResults extends StatelessWidget {
  final List<TrainTrip> results;
  final List<TrainTrip> results2;

  TrainResults({required this.results, required this.results2});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (results.isNotEmpty) ...[
          Text(
            tr("departure"),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (context, index) {
              var result = results[index];
              return buildTripCard(result, context);
            },
          ),
        ] else ...[
          Center(
            child: Text(
              tr("no_results"),
              style: TextStyle(fontSize: 16.0, color: Colors.red),
            ),
          ),
        ],
        if (results2.isNotEmpty) ...[
          Text(
            tr("return"),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: results2.length,
            itemBuilder: (context, index) {
              var result = results2[index];
              return buildTripCard(result, context);
            },
          ),
        ] else if (results.isNotEmpty) ...[
          // Display no return trips only if there are departure trips
          Center(
            child: Text(
              tr("no_results"),
              style: TextStyle(fontSize: 16.0, color: Colors.red),
            ),
          ),
        ],
      ],
    );
  }

  Widget buildTripCard(TrainTrip result, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: () {
          // Handle tap event here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Tapped on ${result.origin} to ${result.destination}')),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.train, color: Colors.orange.shade800),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat.Hm().format(result.departureTime),
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      DateFormat.Hm().format(result.arrivalTime),
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      result.origin,
                      style: TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Text(
                      result.destination,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      result.duration,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      "€${result.amount.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 16, color: Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
