import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:service_pro_provider/Ui/login_signup/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  Future<void> checkUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? '';
    final apiProvider =
        Provider.of<LoginLogoutProvider>(context, listen: false);
    await apiProvider.autoLogin(context);

    Timer(const Duration(seconds: 2), () {
      if (apiProvider.isLoggedIn) {
        if (role == 'Provider') {
          Navigator.pushNamedAndRemoveUntil(
              context, '/dashboard', (route) => false);
        } else if (role == 'admin') {
          Navigator.pushNamedAndRemoveUntil(
              context, '/admin', (route) => false);
        } else {
          print('Error: Invalid role');
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set the status bar color to transparent
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return const Scaffold(
      backgroundColor: Color(0xFF4A90E2), // Blue color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.build, // Service icon
              size: 60,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Service Pro',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your Trusted Service Provider',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
