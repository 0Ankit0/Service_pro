import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';

class GetReviewsProvider with ChangeNotifier {
  List<dynamic> getreviews = [];
  Future<void> getReviews(BuildContext context, String id) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    final response = await http.get(
        Uri.parse('http://20.52.185.247:8000/feedback/provider/$id'),

        ///$id yo id pathauni vaneko ho
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    if (response.statusCode == 200) {
      getreviews = jsonDecode(response.body)['data'] as List<
          dynamic>; //response 200 xa vani tesko response ko body lai as list rakheko
      print('Reviews loaded successfully');
      notifyListeners();
    } else {
      print('Failed to load reviews $response.statusCode $response.body');
    }
  }
}
