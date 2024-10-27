import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:service_pro_user/Provider/user_provider/profile_provider.dart';
import 'package:service_pro_user/UI/profile/account_information.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor:
            const Color(0xFF43cbac), // Use the theme color for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Card(
              color: const Color(0xFF43cbac).withOpacity(0.1),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF43cbac),
                  child: Icon(Icons.account_circle, color: Colors.white),
                ),
                title: const Text('Account Information'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountInformationPage(
                        name:
                            Provider.of<ProfileProvider>(context, listen: false)
                                    .data['Name'] ??
                                'Invalid Name',
                        email:
                            Provider.of<ProfileProvider>(context, listen: false)
                                    .data['Email'] ??
                                'nomail@gmail.com',
                        phone:
                            Provider.of<ProfileProvider>(context, listen: false)
                                    .data['PhoneNo']
                                    .toString() ??
                                '0000000000',
                        address:
                            Provider.of<ProfileProvider>(context, listen: false)
                                    .data['Address'] ??
                                'Invalid Address',
                        profile: Provider.of<ProfileProvider>(context,
                                    listen: false)
                                .data['ProfileImg'] ??
                            'https://dudewipes.com/cdn/shop/articles/gigachad.jpg?v=1667928905&width=2048',
                      ),
                    ),
                  );
                },
              ),
            ),
            Card(
              color: const Color(0xFF43cbac).withOpacity(0.1),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF43cbac),
                  child: Icon(Icons.check_circle, color: Colors.white),
                ),
                title: const Text('Active Status'),
                onTap: () {
                  Navigator.pushNamed(context, '/active_status');
                },
              ),
            ),
            Card(
              color: const Color(0xFF43cbac).withOpacity(0.1),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF43cbac),
                  child: Icon(Icons.lock, color: Colors.white),
                ),
                title: const Text('Change Password'),
                onTap: () {
                  Navigator.pushNamed(context, '/change_password');
                },
              ),
            ),
            Card(
              color: const Color(0xFF43cbac).withOpacity(0.1),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF43cbac),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                title: const Text('Delete Account'),
                onTap: () {
                  Navigator.pushNamed(context, '/delete_account');
                },
              ),
            ),
            Card(
              color: const Color(0xFF43cbac).withOpacity(0.1),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF43cbac),
                  child: Icon(Icons.privacy_tip, color: Colors.white),
                ),
                title: const Text('Privacy Policy'),
                onTap: () {
                  Navigator.pushNamed(context, '/privacy_policy');
                },
              ),
            ),
            Card(
              color: const Color(0xFF43cbac).withOpacity(0.1),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF43cbac),
                  child: Icon(Icons.gavel, color: Colors.white),
                ),
                title: const Text('Terms & Conditions'),
                onTap: () {
                  Navigator.pushNamed(context, '/terms_conditions');
                },
              ),
            ),
            Card(
              color: const Color(0xFF43cbac).withOpacity(0.1),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF43cbac),
                  child: Icon(Icons.logout, color: Colors.white),
                ),
                title: const Text('Logout'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async {
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
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
