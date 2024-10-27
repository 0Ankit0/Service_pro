import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Admin%20Panel/manage_category.dart';
import 'package:service_pro_provider/Admin%20Panel/manage_service.dart';
import 'package:service_pro_provider/Admin%20Panel/manage_users.dart';
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Widget currentBody = const ManageUsers();
  @override
  Widget build(BuildContext context) {
    final userProvider =
        Provider.of<LoginLogoutProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        actions: [
          IconButton(
            onPressed: () async {
              await userProvider.logOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('Admin'),
              accountEmail: Text('__'),
            ),
            ListTile(
              title: const Text('Manage Users'),
              onTap: () {
                setState(() {
                  currentBody = const ManageUsers();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Manage Category'),
              onTap: () {
                setState(() {
                  currentBody = const ManageCategory();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Manage Service'),
              onTap: () {
                setState(() {
                  currentBody = const ManageService();
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: currentBody,
    );
  }
}
