import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginLogoutProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String _token = '';
  String _userId = '';
  bool _verified = false;
  bool _activated = false;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String get token => _token;
  String get userId => _userId;
  bool get verified => _verified;
  bool get activated => _activated;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://20.52.185.247:8000/user/login'),
        body: jsonEncode({
          'Email': email,
          'Password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('data: ${data['data']}');
        print('login success');
        if (data != null && data['data'] != null) {
          final userData = data['data'];
          _token = userData['token'];
          Map<String, dynamic> decodedToken = JwtDecoder.decode(_token);
          _userId = decodedToken['id']; // Use _userId = '' if _id is null
          _verified = userData['Verified'] == true; // Ensure boolean type
          _activated = userData['Active'] == true; // Ensure boolean type

          if (userData['Role'] == 'user') {
            await storeToken(_token, _verified, _activated);
            _isLoggedIn = true;
          } else {
            print('Error: Invalid role');
            _isLoggedIn = false;
          }
        } else {
          print('Error: Invalid response format');
          _isLoggedIn = false;
        }
      } else {
        print('Error: ${response.body}');
        _isLoggedIn = false;
      }
    } catch (e) {
      print('Error: $e');
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = '';
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    _verified = prefs.getBool('verified') ?? false;
    _activated = prefs.getBool('activated') ?? false;
    _isLoggedIn = _token.isNotEmpty && _verified && activated;

    notifyListeners();
  }

  Future<void> storeToken(String token, bool verified, bool activated) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setBool('verified', verified);
    await prefs.setBool('activated', activated);
  }
}
