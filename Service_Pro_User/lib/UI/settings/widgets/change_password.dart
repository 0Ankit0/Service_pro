import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:service_pro_user/Provider/user_provider/change_password_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Change Password',
            style: TextStyle(fontFamily: 'Roboto')),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            TextFormField(
              controller: oldPasswordController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                labelText: 'Old Password',
                labelStyle: TextStyle(fontFamily: 'Roboto'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hoverColor: Colors.blue[100],
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: newPasswordController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                labelText: 'New Password',
                labelStyle: TextStyle(fontFamily: 'Roboto'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hoverColor: Colors.blue[100],
                prefixIcon: Icon(Icons.lock_open),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                labelText: 'Confirm Password',
                labelStyle: TextStyle(fontFamily: 'Roboto'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hoverColor: Colors.blue[100],
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors
                          .green; // return the color when button is pressed
                    return Theme.of(context)
                        .primaryColor; // return default color when button is not pressed
                  },
                ),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
              ),
              onPressed: () async {
                if (oldPasswordController.text.isEmpty ||
                    newPasswordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fill all fields'),
                    duration: const Duration(seconds: 2),
                  ));
                  return;
                } else if (newPasswordController.text !=
                    confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Passwords do not match'),
                    duration: const Duration(seconds: 2),
                  ));
                  return;
                } else {
                  await Provider.of<ChangePassword>(context, listen: false)
                      .changePassword(context, oldPasswordController.text,
                          newPasswordController.text);
                  await Provider.of<LoginLogoutProvider>(context, listen: false)
                      .logOut()
                      .then((value) => Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false));
                }
              },
              child: const Text(
                'Change Password',
                style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
