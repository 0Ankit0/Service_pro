import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';

class ProfileProvider with ChangeNotifier {
  String _userId = '';
  String get userId => _userId;
  Map<String, dynamic> data = {};
  Future<void> userProfile(BuildContext context) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    print('Token: $token');
    try {
      if (token == null) {
        print('Token is null');
      } else {
        final response = await http
            .get(Uri.parse('http://20.52.185.247:8000/user/profile'), headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
        if (response.statusCode == 200) {
          print('Response: ${response.body}');
          data = jsonDecode(response.body)['data'];
          print('Passowrd: ${data['Password']}');
          _userId = data['_id'] ?? 'no id';
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
