import 'package:flutter/material.dart';

class Verification extends StatelessWidget {
  final String email;

  const Verification({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
        backgroundColor: Color(0xFF43cbac),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email, size: 100, color: Color(0xFF43cbac)),
              SizedBox(height: 20),
              Text(
                'Please open your email to verify your account.',
                style: TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'We have sent a verification link to $email',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back to Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF43cbac),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
