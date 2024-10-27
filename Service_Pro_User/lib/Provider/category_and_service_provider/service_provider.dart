import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServiceProvider with ChangeNotifier {
  List<dynamic> _service = [];
  List<dynamic> get service => _service;
  Future<List<dynamic>> getService(BuildContext context) async {
    final response =
        await http.get(Uri.parse('http://20.52.185.247:8000/service'));
    if (response.statusCode == 200) {
      _service = jsonDecode(response.body)['data'];
      notifyListeners();
      return _service;
    } else {
      print(
          'Failed to load service request: ${response.statusCode} ${response.body}');
    }
    return [];
  }
}
