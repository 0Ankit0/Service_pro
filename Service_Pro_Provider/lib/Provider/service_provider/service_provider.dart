import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';

class ServiceProvider with ChangeNotifier {
  List<dynamic> _service = [];

  List<dynamic> get service => _service;
  Future<void> getServices() async {
    try {
      final response =
          await http.get(Uri.parse('http://20.52.185.247:8000/service'));
      if (response.statusCode == 200) {
        _service = jsonDecode(response.body)['data'];
        notifyListeners();
      } else {
        print(
            'Error in fetching services: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error in fetching services: $e');
    }
  }

  Future<void> addService(
    BuildContext context,
    String name,
    String description,
    String image,
    String price,
    String duration,
  ) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    try {
      final reponse =
          await http.post(Uri.parse('http://20.52.185.247:8000/service/add'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode({
                'Name': name,
                'Description': description,
                'Image': image,
                'Price': price,
                'Duration': duration,
              }));
    } catch (e) {
      print('error in adding category: $e');
    }
  }
}
