import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';

class ServiceManage with ChangeNotifier {
  Future<void> serviceManage(BuildContext context, List service) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    final response =
        await http.put(Uri.parse('http:20.52.185.247:8000/user/profile'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'Services': service,
            }));
    if (response.statusCode == 200) {
      print('Services updated successfully with ${response.body}');
      notifyListeners();
    } else {
      print(
          'Failed to update services: ${response.statusCode}, ${response.body}');
    }
  }
}
