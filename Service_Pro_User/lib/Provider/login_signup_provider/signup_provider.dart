import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';

class SignUpProvider with ChangeNotifier {
  Future<void> signUp(
    String name,
    String email,
    String password,
    String phoneNo,
    String address,
    String imageUrl,
  ) async {
    final response = await http.post(
      Uri.parse('http://20.52.185.247:8000/user/signup'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'Name': name,
        'Email': email,
        'Password': password,
        'PhoneNo': phoneNo,
        'Address': address,
        'ProfileImg': imageUrl,
      }),
    );

    if (response.statusCode == 200) {
      print('Sign up successful');
    } else {
      print('Sign up failed: ${response.statusCode}');
      throw Exception('Failed to sign up');
    }
  }

  Future<void> sendVerificationEmail(BuildContext context, String email) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    final id = Provider.of<LoginLogoutProvider>(context, listen: false)
        .userId
        .toString();
    final response = await http.post(
      Uri.parse('http://20.52.185.247:8000/mail/send/welcome'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer $token',
      },
      body: json.encode({'Email': email, 'id': id}),
    );

    if (response.statusCode == 200) {
      print('id: $id');
      print('Verification email sent');
    } else {
      print(
          'Failed to send verification email: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to send verification email');
    }
  }

  Future<String?> uploadProfileImage(String filePath) async {
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

  Future<XFile?> compressImage(File file) async {
    final filePath = file.absolute.path;

    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final split = filePath.substring(0, lastIndex);
    final outPath = "${split}_out${filePath.substring(lastIndex)}";

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 50,
    );

    return result;
  }
}
