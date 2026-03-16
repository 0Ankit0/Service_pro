import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:service_pro_user/core/api_config.dart';

class ServiceProvider with ChangeNotifier {
  List<dynamic> _service = [];
  List<dynamic> get service => _service;
  Future<List<dynamic>> getService(BuildContext context) async {
    final response =
        await http.get(Uri.parse(ApiConfig.baseUrl + '/service'));
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
