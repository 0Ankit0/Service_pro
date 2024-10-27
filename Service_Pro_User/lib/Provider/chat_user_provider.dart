import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';

class ChatUserProvider with ChangeNotifier {
  List<dynamic> users = [];

  Future<List<dynamic>> getChatUser(BuildContext context) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    print('token : $token');
    final response = await http
        .get(Uri.parse('http://20.52.185.247:8000/message/userList'), headers: {
      'Content-Type': 'application /json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      users = jsonDecode(response.body)['users'];

      notifyListeners();
      return users;
    } else {
      print('Error: ${response.body}');
    }
    return [];
  }
}
