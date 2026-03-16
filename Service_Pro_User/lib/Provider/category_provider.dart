import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:service_pro_user/Models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:service_pro_user/core/api_config.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  Future<void> getCategories() async {
    final response =
        await http.get(Uri.parse(ApiConfig.baseUrl + '/category'));

    if (response.statusCode == 200) {
      final categoryData = jsonDecode(response.body)['data'] as List;
      _categories = categoryData.map((e) => CategoryModel.fromJson(e)).toList();

      notifyListeners();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
