import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';

class ServiceRequestProvider with ChangeNotifier {
  Future<void> sendServiceRequest(
      BuildContext context,
      String userId,
      String providerId,
      String serviceId,
      String image,
      String dateTime) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    try {
      final response = await http.post(
        Uri.parse('http://20.52.185.247:8000/request/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'UserId': userId,
          'ProviderId': providerId,
          'ServiceId': serviceId,
          'Image': image,
          'DateTime': dateTime,
        }),
      );
      if (response.statusCode == 200) {
        print('Service Request Sent');
        notifyListeners();
      } else {
        print('Service Request Failed');
      }
    } catch (e) {
      print('Failed to request service: $e');
    }
  }

  Future<String?> uploadImage(BuildContext context, String filePath) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://20.52.185.247:8000/upload/file'),
      );
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        return responseData;
      } else {
        print(
            'Error uploading image: ${response.statusCode} ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception uploading image: $e');
      return null;
    }
  }

  Future<void> completeRequest(BuildContext context, String id) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    final response = await http.post(
      Uri.parse('http://20.52.185.247:8000/request/complete/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print('Request completed');
      notifyListeners();
    } else {
      print(
          'Failed to complete request ${response.statusCode} ${response.body}');
    }
  }

  Future<void> cancelRequest(BuildContext context, String id) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    final response = await http.post(
      Uri.parse('http://20.52.185.247:8000/request/cancel/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print('Request canceled');
      notifyListeners();
    } else {
      print(
          'Failed to complete request ${response.statusCode} ${response.body}');
    }
  }
}
