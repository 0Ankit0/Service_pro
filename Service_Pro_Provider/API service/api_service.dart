// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:service_provide_app/models/category_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ApiService {
//   static const baseUrl1 = "http://10.0.2.2:8000/user/";
//   static const baseUrl2 = "http://10.0.2.2:8000/category/";

//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   Future<List<CategoryModel>> fetchCategory() async {
//     final userToken = await getToken();
//     final response = await http.get(Uri.parse(baseUrl2),
//         headers: {'Authorization': 'Bearer $userToken'});

//     if (response.statusCode == 200) {
//       print('token: $userToken');
//       final data2 = jsonDecode(response.body)['categories'] as List;
//       return data2
//           .map((categoryData) => CategoryModel.fromJson(categoryData))
//           .toList();
//     } else {
//       throw Exception('Failed to load category');
//     }
//   }
// }
