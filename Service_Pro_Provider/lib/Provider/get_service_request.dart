import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:service_pro_provider/core/api_config.dart';

class GetServiceRequest with ChangeNotifier {
  List<dynamic> _serviceRequests = [];

  List<dynamic> get serviceRequests => _serviceRequests;

  Future<List<dynamic>> getServiceRequest(BuildContext context) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.baseUrl + '/request'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        _serviceRequests = jsonDecode(response.body)['data'];

        notifyListeners();
        // print('Service requests fetched successfully:');

        return _serviceRequests;
      } else {
        print(
            'Failed to get service requests: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error getting service requests: $e');
    }
    return [];
  }

  Future<void> acceptRequest(BuildContext context, String id) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    try {
      final response = await http.post(
          Uri.parse(ApiConfig.baseUrl + '/request/accept/$id'),
          headers: {
            'Authorization': 'Bearer $token',
          },
          body: {
            'Status': 'accepted',
          });
      if (response.statusCode == 200) {
        print('Request accepted successfully');
        notifyListeners();
      } else {
        print(
            'Error accepting request: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error accepting request: $e');
    }
  }

  Future<void> rejectRequest(BuildContext context, String id) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    try {
      final response = await http.post(
          Uri.parse(ApiConfig.baseUrl + '/request/reject/$id'),
          headers: {
            'Authorization': 'Bearer $token',
          },
          body: {
            'Status': 'rejected',
          });
      if (response.statusCode == 200) {
        print('Request rejected successfully');
        notifyListeners();
      } else {
        print(
            'Error accepting request: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error accepting request: $e');
    }
  }
}
