import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';

class DeleteUser with ChangeNotifier {
  Future<void> deleteUser(BuildContext context, String id) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    final response = await http.delete(
      Uri.parse('http://20.52.185.247:8000/user/delete/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print('User Deleted');
      notifyListeners();
    } else {
      print('User not Deleted with ${response.statusCode} ${response.body}');
      notifyListeners();
    }
  }
}
