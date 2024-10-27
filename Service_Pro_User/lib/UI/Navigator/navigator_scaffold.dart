import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:service_pro_user/Provider/search_provider/user_search_provider.dart';
import 'package:service_pro_user/UI/Request/booking.dart';
import 'package:service_pro_user/UI/chat/chat_list.dart';
import 'package:service_pro_user/UI/home_screen/home_screen.dart';
import 'package:service_pro_user/UI/profile/profile_page.dart';
import 'package:service_pro_user/UI/service_providers/service_provider_details.dart';

class NavigatorScaffold extends StatefulWidget {
  final int initialIndex;

  const NavigatorScaffold({super.key, this.initialIndex = 0});

  @override
  State<NavigatorScaffold> createState() => _NavigatorScaffoldState();
}

class _NavigatorScaffoldState extends State<NavigatorScaffold> {
  late int currentIndex;
  Color? unSelectedItemColor = Colors.white;
  Color? selectedItemColor = const Color(0xFF191645);
  late Widget currentBody;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    setBodyContent();
  }

  void setBodyContent() {
    switch (currentIndex) {
      case 0:
        currentBody = const HomeScreen();
        break;
      case 1:
        currentBody = const Chat();
        break;
      case 2:
        currentBody = const Booking();
        break;
      case 3:
        currentBody = ProfilePage();
        break;
    }
  }

  String getAppBarTitle() {
    switch (currentIndex) {
      case 0:
        return 'SERVICE PRO';
      case 1:
        return 'CHAT';
      case 2:
        return 'BOOKING';
      case 3:
        return 'PROFILE';
      default:
        return 'SERVICE PRO';
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<LoginLogoutProvider>(context).token;
    final userProvider = Provider.of<LoginLogoutProvider>(context);

    setBodyContent(); // Update the body content whenever the currentIndex changes

    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Text(getAppBarTitle(),
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10.0),
                      hintText: 'Search Service Providers',
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () async {
                          await Provider.of<UserSearchProvider>(context,
                                  listen: false)
                              .searchUser(context, searchController.text);
                          await showSearchResults(context);
                          searchController.clear();
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 1.0),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              IconButton(
                onPressed: () {
                  print('Token value: $token');
                  if (token != null) {
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
                              onPressed: () {
                                userProvider.logOut();
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Login'),
                          content: const Text(
                              'You need to login to access full feature of the app'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                icon: Image.asset('assets/icons/logout.png'),
              )
            ],
          ),
        ),
      ),
      body: currentBody,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
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
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/booking.png',
                    height: 30,
                    color: currentIndex == 2
                        ? selectedItemColor
                        : unSelectedItemColor),
                label: 'Booking',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/profile.png',
                    height: 30,
                    color: currentIndex == 3
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
    );
  }

  Future<void> showSearchResults(BuildContext context) async {
    final searchServiceData =
        Provider.of<UserSearchProvider>(context, listen: false).searchData;
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Search Results',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: searchServiceData.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No results found.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchServiceData.length,
                        itemBuilder: (context, index) {
                          final providerId =
                              searchServiceData[index]['_id'].toString();
                          final providerName =
                              searchServiceData[index]['Name'].toString();
                          final providerAddress =
                              searchServiceData[index]['Address'].toString();
                          final providerPhone =
                              searchServiceData[index]['PhoneNo'].toString();
                          final providerEmail =
                              searchServiceData[index]['Email'].toString();
                          final providerServiceTotal = searchServiceData[index]
                                  ['ServiceAnalytics']['TotalServices']
                              .toString();
                          final providerServiceCompleted =
                              searchServiceData[index]['ServiceAnalytics']
                                      ['CompletedServices']
                                  .toString();
                          final providerProfile =
                              searchServiceData[index]['ProfileImg'] ?? '';

                          if (searchServiceData[index]['Role'] != 'user' &&
                              searchServiceData[index]['Verified'] == true &&
                              searchServiceData[index]['Active'] == true) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceProviderDetails(
                                      providerId: providerId,
                                      providerName: providerName,
                                      providerAddress: providerAddress,
                                      providerPhone: providerPhone,
                                      providerEmail: providerEmail,
                                      providerServiceTotal:
                                          providerServiceTotal,
                                      providerServiceCompleted:
                                          providerServiceCompleted,
                                      providerProfile: providerProfile,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.search),
                                    title: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: providerProfile !=
                                                  null
                                              ? NetworkImage(providerProfile)
                                              : const AssetImage(
                                                      'assets/profile/default_profile.png')
                                                  as ImageProvider,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          searchServiceData[index]['Name']
                                              .toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              ),
                            );
                          } else {}
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
