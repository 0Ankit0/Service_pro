import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:service_pro_provider/Ui/chat/chat_list.dart';
import 'package:service_pro_provider/Ui/home_screen.dart/home_screen.dart';
import 'package:service_pro_provider/Ui/profile/profile_page.dart';

class NavigatorScaffold extends StatefulWidget {
  const NavigatorScaffold({super.key});

  @override
  State<NavigatorScaffold> createState() => _NavigatorScaffoldState();
}

class _NavigatorScaffoldState extends State<NavigatorScaffold> {
  int currentIndex = 0;
  Color? unSelectedItemColor = Colors.pink[900];
  Color selectedItemColor = Colors.white;
  late Widget currentBody;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<LoginLogoutProvider>(context);
    switch (currentIndex) {
      case 0:
        currentBody = const HomeScreen();

        break;
      case 1:
        currentBody = const Chat();

        break;

      // case 2:
      //   currentBody = Add();
      //   break;

      case 2:
        currentBody = ProfilePage();
    }
    return Scaffold(
      extendBody: true,
      // backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
          child: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Service Pro'),
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                IconButton(
                    onPressed: () {
                      // Show confirmation dialog for logout
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Logout'),
                            content:
                                const Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await userProvider.logOut();
                                  await Navigator.pushReplacementNamed(
                                      context, '/login');
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Image.asset(
                      'assets/icons/logout.png',
                    ))
              ]),
        ),
      ),
      body: currentBody,
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: BottomNavigationBar(
                // type: BottomNavigationBarType.fixed,
                backgroundColor: Theme.of(context).primaryColor,
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/icons/home.png',
                      height: 30,
                      color: currentIndex == 0
                          ? selectedItemColor
                          : unSelectedItemColor,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/chat.png',
                        height: 30,
                        color: currentIndex == 1
                            ? selectedItemColor
                            : unSelectedItemColor),
                    label: 'Chat',
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Image.asset('assets/icons/booking.png',
                  //       height: 30,
                  //       color: currentIndex == 2
                  //           ? selectedItemColor
                  //           : unSelectedItemColor),
                  //   label: 'Add',
                  // ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/profile.png',
                        height: 30,
                        color: currentIndex == 2
                            ? selectedItemColor
                            : unSelectedItemColor),
                    label: 'Profile',
                  ),
                ],
                currentIndex: currentIndex,
                selectedItemColor: selectedItemColor,
                unselectedItemColor: unSelectedItemColor,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
