import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:service_pro_user/Provider/serviceRequest_provider/serviceRequest_provider.dart';
import 'package:service_pro_user/Provider/user_provider/put_user_provider.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
        backgroundColor: const Color(0xFF43cbac),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Account'),
                        content: const Text(
                            'Are you sure you want to delete your account?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Call the delete account function
                              await Provider.of<UpdateUserDetails>(context,
                                      listen: false)
                                  .deleteAccount(context);
                              await Provider.of<LoginLogoutProvider>(context,
                                      listen: false)
                                  .logOut();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/login', (route) => false);
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    });
              },
              child: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43cbac),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
