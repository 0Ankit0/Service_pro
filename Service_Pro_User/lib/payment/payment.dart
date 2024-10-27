// import 'package:flutter/material.dart';
// import 'package:khalti_flutter/khalti_flutter.dart';

// import 'package:provider/provider.dart';
// import 'package:service_provide_app/design/booking.dart';

// import 'package:service_provide_app/design/create_review.dart';
// import 'package:service_provide_app/design/new_loginUI.dart';

// import 'package:service_provide_app/design/notification.dart';
// import 'package:service_provide_app/design/payment_btn.dart';
// import 'package:service_provide_app/design/paymentdetail_screen.dart';
// import 'package:service_provide_app/design/provider_category.dart';
// import 'package:service_provide_app/design/ratingandreview.dart';
// import 'package:service_provide_app/design/request.dart';
// import 'package:service_provide_app/design/userrequest_screen.dart';

// import 'package:service_provide_app/provider/api_provider.dart';
// import 'package:service_provide_app/ui/splash_screen.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   Future.delayed(const Duration(seconds: 2));
//   runApp(MultiProvider(
//     providers: [
//       ChangeNotifierProvider(create: (_) => ApiProvider()),
//     ],
//     child: MyApp(),
//   ));
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String? _token;

//   @override
//   void initState() {
//     super.initState();
//     _getToken();
//   }

//   Future<void> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     setState(() {
//       _token = token;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return KhaltiScope(
//       publicKey: 'test_public_key_7c837e9b57b94f6284ad8cd3367cf697',
//       enabledDebugging: true,
//       builder: (context, navKey) {
//         return MaterialApp(
//           theme: ThemeData(
//             primaryColor: Colors.teal,
//           ),
//           title: 'Khalti',
//           debugShowCheckedModeBanner: false,
//           home: payment(),
//           navigatorKey: navKey,
//           localizationsDelegates: [
//             KhaltiLocalizations.delegate,
//           ],
//         );
//       },
//     );
//   }
// }
