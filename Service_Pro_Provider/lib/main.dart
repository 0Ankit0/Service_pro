import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Admin%20Panel/manage_category.dart';
import 'package:service_pro_provider/Admin%20Panel/admin_home.dart';
import 'package:service_pro_provider/Provider/category_provider/category_provider.dart';
import 'package:service_pro_provider/Provider/category_provider/put_category_provider.dart';
import 'package:service_pro_provider/Provider/profile_provider/add_remove_service_provider.dart';
import 'package:service_pro_provider/Provider/rating_and_reviews/get_reviews_provider.dart';
import 'package:service_pro_provider/Provider/service_provider/put_service_provider.dart';
import 'package:service_pro_provider/Provider/service_provider/service_provider.dart';
import 'package:service_pro_provider/Provider/chat_user_provider.dart';
import 'package:service_pro_provider/Provider/deactivate_user_provider.dart';
import 'package:service_pro_provider/Provider/get_service_request.dart';
import 'package:service_pro_provider/Provider/login_signup_provider/signup_provider.dart';
import 'package:service_pro_provider/Provider/profile_provider.dart';
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:service_pro_provider/Provider/verify_provider.dart';
import 'package:service_pro_provider/Ui/navigator/navigator_scaffold.dart';
import 'package:service_pro_provider/Ui/login_signup/login_screen.dart';
import 'package:service_pro_provider/Ui/splash_screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginLogoutProvider()),
        ChangeNotifierProvider(create: (_) => ChatUserProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => GetServiceRequest()),
        ChangeNotifierProvider(create: (_) => UpdateCategory()),
        ChangeNotifierProvider(create: (_) => UpdateService()),
        ChangeNotifierProvider(create: (_) => VerifyAccount()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => DeleteUser()),
        ChangeNotifierProvider(create: (_) => GetReviewsProvider()),
        ChangeNotifierProvider(create: (_) => ServiceManage()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF42cbac),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/dashboard': (context) => const NavigatorScaffold(),
          '/login': (context) => const LoginScreen(),
          '/admin': (context) => const AdminHome(),
        },
      ),
    );
  }
}
