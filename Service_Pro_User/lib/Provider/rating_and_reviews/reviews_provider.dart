import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';

class RatingReview with ChangeNotifier {
  Future<void> addRatingReviews(
    BuildContext context,
    String serviceId,
    String providerId,
    String rating,
    String comment,
  ) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    final response = await http.post(
      Uri.parse('http://20.52.185.247:8000/feedback/add'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'ServiceId': serviceId,
        'ProviderId': providerId,
        'Rating': rating,
        'Comment': comment,
      }),
    );
    if (response.statusCode == 200) {
      print('Rating and Review added successfully');
      notifyListeners();
    } else {
      print('Rating and Review not added $response.statusCode $response.body');
    }
  }
}
