// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:service_pro_user/Provider/login_logout_provider.dart';
// import 'package:service_pro_user/UI/login_signup/signup_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   bool _isPasswordVisible = false;

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<LoginLogoutProvider>(context);

//     return Scaffold(
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               Expanded(
//                 flex: 5,
//                 child: Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/profile/default_profile.jpg'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(height: 100),
//                   Text(
//                     'Service Pro',
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
//                     margin: EdgeInsets.symmetric(horizontal: 32),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 10,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           'Welcome',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'Please login with your information',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         TextFormField(
//                           controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: InputDecoration(
//                             labelText: 'Email Address',
//                             prefixIcon: Icon(Icons.email),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your email';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 20),
//                         TextFormField(
//                           controller: _passwordController,
//                           obscureText: !_isPasswordVisible,
//                           decoration: InputDecoration(
//                             labelText: 'Password',
//                             prefixIcon: Icon(Icons.lock),
//                             suffixIcon: IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   _isPasswordVisible = !_isPasswordVisible;
//                                 });
//                               },
//                               icon: _isPasswordVisible
//                                   ? Icon(Icons.visibility)
//                                   : Icon(Icons.visibility_off),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your password';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Checkbox(value: false, onChanged: (value) {}),
//                                 Text('Remember me'),
//                               ],
//                             ),
//                             TextButton(
//                               onPressed: () {},
//                               child: Text('Forgot my password'),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: () async {
//                             await userProvider.login(
//                               _emailController.text,
//                               _passwordController.text,
//                             );

//                             // Check if the login was successful
//                             if (userProvider.isLoggedIn) {
//                               Navigator.pushReplacementNamed(
//                                   context, '/dashboard');
//                             } else {
//                               showDialog(
//                                 context: context,
//                                 builder: (context) {
//                                   return AlertDialog(
//                                     title: Text('Error'),
//                                     content: Text('Invalid email or password'),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () {
//                                           Navigator.pop(context);
//                                         },
//                                         child: Text('OK'),
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               );
//                             }
//                           },
//                           child: userProvider.isLoading
//                               ? CircularProgressIndicator()
//                               : Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 32, vertical: 12),
//                                   child: Text('Login'),
//                                 ),
//                         ),
//                         SizedBox(height: 20),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => SignUpPage(),
//                               ),
//                             );
//                           },
//                           child: Text.rich(
//                             TextSpan(
//                               text: "Don't have an account? ",
//                               children: [
//                                 TextSpan(
//                                   text: 'SignUp',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
