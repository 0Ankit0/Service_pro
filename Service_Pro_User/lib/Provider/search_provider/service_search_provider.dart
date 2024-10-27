import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';

class SearchService with ChangeNotifier {
  String searchText = '';
  List searchData = [];

  Future<void> setSearchService(BuildContext context, String searchText) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    this.searchText =
        searchText; // Correctly set the class's searchText property
    final url = 'http://20.52.185.247:8000/service/search/$searchText/';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        searchData = responseBody['data'] as List;
        print('searchData: $searchData');
        notifyListeners();
      } else {
        print('Failed to load data: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to load data: $e');
    }
  }
}
