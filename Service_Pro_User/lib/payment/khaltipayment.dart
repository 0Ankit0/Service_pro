// import 'package:flutter/material.dart';
// import 'package:khalti_flutter/khalti_flutter.dart';

// class payment extends StatefulWidget {
//   @override
//   _paymentState createState() => _paymentState();
// }

// class _paymentState extends State<payment> {
//   String referenceId = '';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Air Conditioner'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Air Conditioner Repair',
//               style: TextStyle(fontSize: 24),
//             ),
//             Text('Get your AC fixed for a flat ₹100 fee'),
//             SizedBox(
//               height: 400,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 payWithKhaltiInApp();
//               },
//               child: Text('pay'),
//             ),
//             Text(referenceId)
//           ],
//         ),
//       ),
//     );
//   }

//   payWithKhaltiInApp() {
//     KhaltiScope.of(context).pay(
//         config: PaymentConfig(
//             amount: 1000,
//             productIdentity: "product id",
//             productName: "product name"),
//         preferences: [PaymentPreference.khalti],
//         onSuccess: onSuccess,
//         onFailure: onFailure,
//         onCancel: onCancel);
//   }

//   void onSuccess(PaymentSuccessModel success) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text("Payment Successful"),
//             actions: [
//               SimpleDialogOption(
//                 child: Text("OK"),
//                 onPressed: () {
//                   setState(() {
//                     referenceId = success.idx;
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   void onFailure(PaymentFailureModel failure) {
//     debugPrint(failure.toString());
//   }

//   void onCancel() {
//     debugPrint("Cancelled");
//   }
// }
