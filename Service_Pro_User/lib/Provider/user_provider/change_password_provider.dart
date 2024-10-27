import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';

class ChangePassword with ChangeNotifier {
  Future<void> changePassword(
      BuildContext context, String oldPassword, String newPassword) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    final response = await http.post(
      Uri.parse('http://20.52.185.247:8000/user/changePassword'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'OldPassword': oldPassword,
        'NewPassword': newPassword,
      }),
    );
    if (response.statusCode == 200) {
      print('Password changed successfully');
    } else {
      print(
          'Failed to change password: ${response.statusCode} ${response.body}');
      throw Exception('Failed to change password');
    }
  }
}
