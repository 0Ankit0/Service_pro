import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';

class ChatUserProvider with ChangeNotifier {
  List<dynamic> users = [];

  Future<void> getChatUser(BuildContext context) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    print('token : $token');
    final response = await http
        .get(Uri.parse('http://20.52.185.247:8000/message/userList'), headers: {
      'Content-Type': 'application /json; charset=UTF-8',
      'Authorization':
          'Bearer $token' //server baata token vitra ko role user ho vani user ko role dinxa nai tyo user ma provider ko data dhekauxa and vice versa
    });
    if (response.statusCode == 200) {
      //200 xa vani tya vitra ko data response body ma aauxu
      users = jsonDecode(response.body)['users'];
      notifyListeners();
    } else {
      print('Error: ${response.body}');
    }
  }
}
