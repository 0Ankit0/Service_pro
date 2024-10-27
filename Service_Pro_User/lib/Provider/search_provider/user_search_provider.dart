import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';

class UserSearchProvider with ChangeNotifier {
  String searchText = '';
  List<Map<String, dynamic>> searchData = [];

  Future<void> searchUser(BuildContext context, String searchText) async {
    this.searchText = searchText;
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    final response = await http.get(
        Uri.parse('http://20.52.185.247:8000/user/search/$searchText'),
        headers: {
          'Content-Type': 'application/json', // Fixed Content-Type header value
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      print('User search successful: ${response.body}');
      final List<dynamic> jsonData = jsonDecode(response.body)['data'];
      searchData =
          jsonData.map((item) => item as Map<String, dynamic>).toList();
      notifyListeners();
    } else {
      print('Error searching user: ${response.statusCode} ${response.body}');
    }
  }
}
