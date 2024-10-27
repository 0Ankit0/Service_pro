import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetPassword with ChangeNotifier {
  Future<void> resetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://20.52.185.247:8000/mail/send/resetPassword'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'Email': email}),
      );
      if (response.statusCode == 200) {
        print('Password reset link sent to email');
        notifyListeners();
      } else {
        throw Exception(
            'Failed to send password reset link: ${response.statusCode} ${response.body}');
      }
    } catch (error) {
      print('Error occurred: $error');
      rethrow;
    }
  }
}
