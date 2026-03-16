import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:service_pro_provider/core/api_config.dart';

class SignUpProvider with ChangeNotifier {
  Future<void> signUp(
    String email,
    String password,
    String name,
    String address,
    String phone,
    String role,
    String profileImg,
    List documents,
    List services,
  ) async {
    final response = await http.post(
      Uri.parse(ApiConfig.baseUrl + '/user/signup'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'Email': email,
        'Password': password,
        'Name': name,
        'Address': address,
        'PhoneNo': phone,
        'Role': role,
        'ProfileImg': profileImg,
        'Documents': documents,
        'Services': services,
      }),
    );
    if (response.statusCode == 200) {
      print('Sign up successful');
    } else {
      print('Sign up failed  ${response.statusCode} and  ${response.body}');
    }
  }

  Future<String?> uploadImage(BuildContext context, String filePath) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.baseUrl + '/upload/file'),
      );
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('Image uploaded successfully: $responseData'); // Debug statement
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
}
