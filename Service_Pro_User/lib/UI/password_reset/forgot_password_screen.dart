import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/user_provider/reset_password_provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            alignment: Alignment.centerLeft,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor,
            ),
          )),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Forgot Password?',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Enter your email to reset password',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey[700]),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                final resetPasswordProvider =
                    Provider.of<ResetPassword>(context, listen: false);
                try {
                  await resetPasswordProvider
                      .resetPassword(emailController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VerificationScreen(email: emailController.text),
                    ),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to send password reset link: $error'),
                  ));
                }
              },
              child: const Text('Reset Password'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerificationScreen extends StatelessWidget {
  final String email;

  const VerificationScreen({super.key, required this.email});

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
                'We have sent a Reset Passsword link to $email',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              Text(
                '''After getting new password, Please do not forgot to change your password.
                
                ''',
                style: TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  'Back to Login',
                  style: TextStyle(color: Colors.white),
                ),
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
