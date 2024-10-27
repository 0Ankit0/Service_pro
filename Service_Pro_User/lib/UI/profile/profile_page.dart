import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/user_provider/profile_provider.dart';
import 'package:service_pro_user/UI/profile/account_information.dart';
import 'package:service_pro_user/UI/settings/settings.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).userProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF43cbac);

    return SafeArea(
      child: SingleChildScrollView(
          child: Consumer<ProfileProvider>(builder: (context, profile, child) {
        Color activeColor = Colors.grey;
        final activeStatus = profile.data['Active'];
        if (activeStatus == true) {
          activeColor = Colors.green;
        } else if (activeStatus == false) {
          activeColor = Colors.red;
        }
        var user = profile.data;
        final name = user['Name'] ?? 'Invalid Name';
        final email = user['Email'] ?? 'nomail@gmail.com';
        final phone = user['PhoneNo'].toString() ?? '0000000000';
        final address = user['Address'] ?? 'Invalid Address';
        final profilePic = user['ProfileImg'] ??
            'https://dudewipes.com/cdn/shop/articles/gigachad.jpg?v=1667928905&width=2048';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        primaryColor.withOpacity(0.8),
                        activeColor,
                      ],
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/background.jpgg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.2), BlendMode.darken),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.25,
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        CachedNetworkImageProvider(profilePic.toString()),
                  ),
                ),
              ],
            ),
            SizedBox(height: 70),
            Text(
              user['Name'] ?? 'User Name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              user['Email'] ?? 'User Email',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: Icon(Icons.person, color: primaryColor),
                      title: Text('Account Information'),
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: primaryColor),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountInformationPage(
                              name: name,
                              email: email,
                              phone: phone,
                              address: address,
                              profile: profilePic,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: Icon(Icons.settings, color: primaryColor),
                      title: Text('Settings'),
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: primaryColor),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsScreen()));
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        );
      })),
    );
  }
}
