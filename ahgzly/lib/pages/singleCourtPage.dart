// ignore: file_names
import 'package:ahgzly/services/PaymentService.dart';
import 'package:flutter/material.dart';
import 'package:ahgzly/models/Court.dart';
import 'package:ahgzly/models/PaymentResult.dart';
import 'package:ahgzly/pages/PaymentPage.dart';

class CourtDetailPage extends StatelessWidget {
  final Court court;

  const CourtDetailPage({super.key, required this.court});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Court Details'),
      ),
      body: ListView(
        children: [
          // Display court details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  court.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Location: ${court.location}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Court Type: ${court.courtType}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Price: ${court.name} EGP',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                // Add more court details here as needed
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () async {
            try {
              PaymentResult? resp =
                  await PaymentService().createPaymentKey(amount: "200");

              if (resp != null && resp.success != null) {
                // Navigate to the reservations page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    paymentResult: resp,
                  ),
                ));
              } else {
                // Handle the case where resp or resp.success is null
                print('Payment response or success is null');
              }
            } catch (e) {
              // Handle any exceptions that might occur during payment processing
              print('Payment failed. Exception: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment failed. Please try again later.'),
                ),
              );
            }
          },
          child: const Text('Reservations'),
        ),
      ),
    );
  }
}
