import 'package:flutter/material.dart';

class BookingDetailsPage extends StatefulWidget {
  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  int _selectedLocation = 0;
  String _paymentMethod = 'CASH';

  void _showPaymentOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('CASH'),
                leading: Radio<String>(
                  value: 'CASH',
                  groupValue: _paymentMethod,
                  onChanged: (String? value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: Text('Khalti'),
                leading: Radio<String>(
                  value: 'Khalti',
                  groupValue: _paymentMethod,
                  onChanged: (String? value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Air Conditioner Repair',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Service Fee estimation',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              '₹1.00',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Payment Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.payment),
                    SizedBox(width: 8),
                    Text(_paymentMethod),
                  ],
                ),
                TextButton(
                  onPressed: _showPaymentOptionsDialog,
                  child: Text('Change', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  // Handle make request action
                },
                child: Text('Make request', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
