import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/signup_provider.dart';
import 'package:service_pro_user/UI/login_signup/signup_screen.dart';
import 'package:service_pro_user/UI/login_signup/verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<LoginLogoutProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            icon: const Icon(Icons.close, color: Colors.white, size: 30),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Colors.teal.withOpacity(0.2)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Bubble shapes
          Positioned(
            top: 50,
            left: 30,
            child: Bubble(color: Colors.blue, size: 60),
          ),
          Positioned(
            top: 150,
            right: 30,
            child: Bubble(color: Colors.purple, size: 80),
          ),
          Positioned(
            bottom: 100,
            left: 50,
            child: Bubble(
                color: const Color.fromARGB(255, 240, 105, 226), size: 100),
          ),
          Positioned(
            bottom: 200,
            right: 50,
            child: Bubble(color: Colors.pinkAccent, size: 60),
          ),
          // Login Form
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Username or email',
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.person, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Row(
                      //   children: [
                      //     Checkbox(
                      //       value: false,
                      //       onChanged: (value) {},
                      //       checkColor: Colors.blue,
                      //       fillColor: MaterialStateProperty.all(Colors.white),
                      //     ),
                      //     Text('Remember me',
                      //         style: TextStyle(color: Colors.white)),
                      //   ],
                      // ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/forgotPassword');
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 241, 241, 239)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await userProvider.login(
                        _emailController.text,
                        _passwordController.text,
                      );

                      // Check if the login was successful
                      if (userProvider.isLoggedIn) {
                        if (userProvider.verified && userProvider.activated) {
                          Navigator.pushReplacementNamed(context, '/dashboard');
                        } else if (!userProvider.activated) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text('Account not activated'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          await Provider.of<SignUpProvider>(context,
                                  listen: false)
                              .sendVerificationEmail(
                                  context, _emailController.text)
                              .then((_) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Verification(
                                            email: _emailController.text)),
                                  ));
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Invalid email or password'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        children: [
                          TextSpan(
                            text: 'Sign up',
                            style: TextStyle(
                              color: Colors.amberAccent,
                            ),
                          ),
                        ],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final Color color;
  final double size;

  Bubble({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}
