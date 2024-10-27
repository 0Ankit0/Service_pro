import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';

class CategoryProvider with ChangeNotifier {
  List<dynamic> data = [];
  Future<void> fetchCategories() async {
    try {
      final response =
          await http.get(Uri.parse('http://20.52.185.247:8000/category/'));
      if (response.statusCode == 200) {
        print('Response: ${data}');
        data = jsonDecode(response.body)['data'] as List;
        notifyListeners();
      } else {
        print(
            'error in fetching categories:${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('error in fetching categories: $e');
    }
  }

  Future<void> addCategory(
    BuildContext context,
    String name,
    String description,
    String imageUrl,
  ) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    try {
      final reponse =
          await http.post(Uri.parse('http://20.52.185.247:8000/category/add'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode({
                'Name': name,
                'Description': description,
              }));
    } catch (e) {
      print('error in adding category: $e');
    }
  }
}
