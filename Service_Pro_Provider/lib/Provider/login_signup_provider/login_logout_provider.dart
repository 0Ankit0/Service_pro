import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginLogoutProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String _token = '';
  String _role = '';

  String get role => _role;
  String get token => _token;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

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
        final verified = data['data']['Verified'];
        if (verified == true) {
          _token = data['data']['token'];
          _role = data['data']['Role'];
          final role = data['data']['Role'];
          if (role == 'Provider' || role == 'provider' || role == 'admin') {
            await _storeToken(_token);
            await _storeRole(role);
            _isLoggedIn = true;
            notifyListeners();
          } else {
            _isLoggedIn = false;
            throw Exception('Invalid role');
          }
        } else {
          _isLoggedIn = false;
          throw Exception('User not verified');
        }
      } else {
        _isLoggedIn = false;
        throw Exception('Failed to login');
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
    await _clearTokenAndRole();
    notifyListeners();
  }

  Future<void> _clearTokenAndRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    _token = '';
    _role = '';
    _isLoggedIn = false;
  }

  Future<void> autoLogin(context) async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    _role = prefs.getString('role') ?? '';
    if (_token.isNotEmpty && _role.isNotEmpty) {
      if (_role == 'Provider' || _role == 'provider' || _role == 'admin') {
        _isLoggedIn = true;
      }
    }
    notifyListeners();
    return;
  }

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> _storeRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }
}
