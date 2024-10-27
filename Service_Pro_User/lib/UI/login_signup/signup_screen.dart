import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/signup_provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _buildImageContainer() {
    return _image != null
        ? Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: CircleAvatar(
              radius: 75,
              backgroundImage: FileImage(_image!),
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('SERVICE PRO'),
        backgroundColor: Color(0xFF43cbac),
      ),
      body: Container(
        height: screenHeight - appBarHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF43cbac), Color(0xFF006d77)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  buildInputField(nameController, 'Name', Icons.person),
                  SizedBox(height: 10),
                  buildInputField(
                    addressController,
                    'Address',
                    Icons.location_on,
                    hintText: 'Please be very specific about your address',
                  ),
                  SizedBox(height: 10),
                  buildInputField(
                      phoneNumberController, 'Phone Number', Icons.phone),
                  SizedBox(height: 10),
                  buildInputField(
                    emailController,
                    'Email Address',
                    Icons.email,
                  ),
                  SizedBox(height: 10),
                  buildInputField(passwordController, 'Password', Icons.lock,
                      isPassword: true),
                  SizedBox(height: 10),
                  buildInputField(
                      confirmPasswordController, 'Confirm Password', Icons.lock,
                      isPassword: true),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Select Profile',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF43cbac),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildImageContainer(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final name = nameController.text;
                        final address = addressController.text;
                        final phoneNumber = phoneNumberController.text;
                        final email = emailController.text;
                        final password = passwordController.text;

                        if (_image != null) {
                          final compressedImage = await context
                              .read<SignUpProvider>()
                              .compressImage(_image!);
                          if (compressedImage != null) {
                            final imageUrl = await context
                                .read<SignUpProvider>()
                                .uploadProfileImage(compressedImage.path);
                            if (imageUrl != null) {
                              await context.read<SignUpProvider>().signUp(
                                    name,
                                    email,
                                    password,
                                    phoneNumber,
                                    address,
                                    imageUrl,
                                  );
                              Navigator.pushReplacementNamed(context, '/login');

                              // Clear all text fields
                              nameController.clear();
                              addressController.clear();
                              phoneNumberController.clear();
                              emailController.clear();
                              passwordController.clear();
                              confirmPasswordController.clear();

                              // Show pop-up message
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Success'),
                                    content: Text(
                                        'Sign up successful!\nPlease login to verify your email!!'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              showErrorDialog(context,
                                  'Failed to upload profile image. Please try again.');
                            }
                          }
                        } else {
                          showErrorDialog(
                              context, 'Please select a profile image.');
                        }
                      }
                    },
                    child:
                        Text('Sign Up', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF43cbac),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?',
                          style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xFF43cbac),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
      TextEditingController controller, String labelText, IconData icon,
      {bool isPassword = false, String? hintText}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white), // Text style inside the text field
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white), // Label style
        hintText: hintText ??
            'Enter your $labelText', // Use provided hintText if available
        hintStyle: TextStyle(color: Colors.white54), // Hint text style
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor:
            Colors.white.withOpacity(0.1), // Slightly transparent fill color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color:
                  Colors.white.withOpacity(0.5)), // Border style when enabled
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.white), // Border style when focused
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        if (labelText == 'Phone Number' && value.length != 10) {
          return 'Incomplete Phone No.';
        }
        if (isPassword && labelText == 'Confirm Password') {
          if (value != passwordController.text) {
            return 'Passwords do not match';
          }
        }
        return null;
      },
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
