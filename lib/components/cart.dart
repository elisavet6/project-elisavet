import 'package:flutter/material.dart';
import 'package:iq_project/components/payment.dart';
import 'package:iq_project/models/train_destinations.dart';
import 'package:easy_localization/easy_localization.dart';

class CartPage extends StatelessWidget {
  final List<TrainTrip> selectedTrips;

  CartPage({required this.selectedTrips});

  @override
  Widget build(BuildContext context) {
    double totalCost = selectedTrips.fold(0, (sum, trip) => sum + trip.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('cart')),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('selected_trips'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: selectedTrips.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(selectedTrips[index].destination),
                    subtitle: Text(
                        '${selectedTrips[index].departureTime} - ${selectedTrips[index].arrivalTime}'),
                    trailing: Text(
                        '€${selectedTrips[index].amount.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${tr('total_cost')}: €${totalCost.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to payment page or handle checkout logic
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const payment()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                fixedSize: Size(200, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(tr('checkout')),
            ),
          ],
        ),
      ),
    );
  }
}
