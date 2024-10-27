import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';

class VerifyAccount with ChangeNotifier {
  Future<void> verifyAccount(
    BuildContext context,
    String userId,
  ) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    final response = await http.get(
        Uri.parse('http://20.52.185.247:8000/user/verifyAccount?id=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      print('Account verified');
      notifyListeners();
    } else {
      print('Failed to verify account');
    }
  }
}
