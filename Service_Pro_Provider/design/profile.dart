// import 'package:flutter/material.dart';
// import 'package:service_pro_provider/Ui/login_signup/login_screen.dart';

// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Profile'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.person),
//             onPressed: () {
//               // TODO: Implement change profile functionality
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height * 0.4,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.white, Colors.white],
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundImage: AssetImage('assets/user.png'),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'John Doe',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   Text(
//                     'john.doe@example.com',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ListTile(
//                     leading: Icon(Icons.key),
//                     title: TextButton(
//                       onPressed: () {
//                         // TODO: Implement change password functionality
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: Text('Change Password'),
//                               content: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   TextField(
//                                     decoration: InputDecoration(
//                                       labelText: 'Current Password',
//                                     ),
//                                   ),
//                                   TextField(
//                                     decoration: InputDecoration(
//                                       labelText: 'New Password',
//                                     ),
//                                   ),
//                                   TextField(
//                                     decoration: InputDecoration(
//                                       labelText: 'Retype New Password',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () {
//                                     // TODO: Save password changes
//                                     Navigator.pop(context);
//                                   },
//                                   child: Text('Save'),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     // TODO: Discard password changes
//                                     Navigator.pop(context);
//                                   },
//                                   child: Text('Discard'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                       child: Text(
//                         'Change Password',
//                         style: TextStyle(fontSize: 20, color: Colors.black),
//                       ),
//                     ),
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.logout),
//                     title: TextButton(
//                       onPressed: () {
//                         // Show confirmation dialog for logout
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: Text('Logout'),
//                               content: Text('Are you sure you want to logout?'),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.pop(context); // Close the dialog
//                                   },
//                                   child: Text('No'),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.pushAndRemoveUntil(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (BuildContext context) =>
//                                             LoginScreen(),
//                                       ),
//                                       (route) => false,
//                                     );
//                                   },
//                                   child: Text('Yes'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                       child: Text(
//                         'Logout',
//                         style: TextStyle(fontSize: 20, color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
