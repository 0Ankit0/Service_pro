import 'package:flutter/material.dart';

class PaymentDetailsScreen extends StatefulWidget {
  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  String selectedPaymentMethod = 'VISA Classic';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          'Payment Details',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            PaymentMethodTile(
              methodName: 'VISA Classic',
              lastDigits: '1254',
              selectedMethod: selectedPaymentMethod,
              onSelect: (method) {
                setState(() {
                  selectedPaymentMethod = method;
                });
              },
            ),
            PaymentMethodTile(
              methodName: 'Master Card',
              lastDigits: '1254',
              selectedMethod: selectedPaymentMethod,
              onSelect: (method) {
                setState(() {
                  selectedPaymentMethod = method;
                });
              },
            ),
            PaymentMethodTile(
              methodName: 'Bank Transfer',
              lastDigits: '1254',
              selectedMethod: selectedPaymentMethod,
              onSelect: (method) {
                setState(() {
                  selectedPaymentMethod = method;
                });
              },
            ),
            SizedBox(height: 32),
            Text(
              'Payment Info',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PaymentInfoTile(
                  label: 'From',
                  location: 'New York',
                ),
                PaymentInfoTile(
                  label: 'To',
                  location: 'Cox\'s Bazar',
                ),
              ],
            ),
            Spacer(),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal:',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '\$450',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$450',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Pay Now'),
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final String methodName;
  final String lastDigits;
  final String selectedMethod;
  final Function(String) onSelect;

  PaymentMethodTile({
    required this.methodName,
    required this.lastDigits,
    required this.selectedMethod,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelect(methodName);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selectedMethod == methodName ? Colors.blue : Colors.grey,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.credit_card,
              size: 40,
              color: selectedMethod == methodName ? Colors.blue : Colors.grey,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  methodName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '**** **** **** $lastDigits',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Spacer(),
            Radio(
              value: methodName,
              groupValue: selectedMethod,
              onChanged: (value) {
                onSelect(value!);
              },
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentInfoTile extends StatelessWidget {
  final String label;
  final String location;

  PaymentInfoTile({
    required this.label,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Text(
            location,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
