import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/category_and_service_provider/service_provider.dart';
import 'package:service_pro_user/Provider/category_provider.dart';
import 'package:service_pro_user/Provider/chat_user_provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/signup_provider.dart';
import 'package:service_pro_user/Provider/rating_and_reviews/get_reviews_provider.dart';
import 'package:service_pro_user/Provider/rating_and_reviews/reviews_provider.dart';
import 'package:service_pro_user/Provider/search_provider/service_search_provider.dart';
import 'package:service_pro_user/Provider/search_provider/user_search_provider.dart';
import 'package:service_pro_user/Provider/serviceRequest_provider/get_service_request_provider.dart';
import 'package:service_pro_user/Provider/serviceRequest_provider/serviceRequest_provider.dart';
import 'package:service_pro_user/Provider/user_provider/change_password_provider.dart';
import 'package:service_pro_user/Provider/user_provider/profile_provider.dart';
import 'package:service_pro_user/Provider/user_provider/put_user_provider.dart';
import 'package:service_pro_user/Provider/user_provider/reset_password_provider.dart';
import 'package:service_pro_user/UI/Navigator/navigator_scaffold.dart';
import 'package:service_pro_user/UI/Request/booking.dart';
import 'package:service_pro_user/UI/password_reset/forgot_password_screen.dart';
import 'package:service_pro_user/UI/login_signup/login_screen.dart';
import 'package:service_pro_user/UI/settings/widgets/active_status.dart';
import 'package:service_pro_user/UI/settings/widgets/change_password.dart';
import 'package:service_pro_user/UI/settings/widgets/delete_account.dart';
import 'package:service_pro_user/UI/splash_screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:khalti/khalti.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await Khalti.init(
    publicKey: 'test_public_key_dc74e0fd57cb46cd93832aee0a507256',
    enabledDebugging: false,
  );
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
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ChatUserProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => UpdateUserDetails()),
        ChangeNotifierProvider(create: (_) => SearchService()),
        ChangeNotifierProvider(create: (_) => UserSearchProvider()),
        ChangeNotifierProvider(create: (_) => ServiceRequestProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => GetServiceRequest()),
        ChangeNotifierProvider(create: (_) => ResetPassword()),
        ChangeNotifierProvider(create: (_) => ChangePassword()),
        ChangeNotifierProvider(create: (_) => RatingReview()),
        ChangeNotifierProvider(create: (_) => GetReviewsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF43cbac),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/dashboard': (context) => const NavigatorScaffold(),
          '/login': (context) => const LoginScreen(),
          '/booking': (context) => const Booking(),
          '/forgotPassword': (context) => const ForgotPasswordScreen(),
          '/active_status': (context) => const ActiveStatus(),
          '/change_password': (context) => const ChangePasswordScreen(),
          '/delete_account': (context) => const DeleteAccount(),
        },
      ),
    );
  }
}
