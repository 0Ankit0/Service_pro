import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/user_provider/profile_provider.dart';
import 'package:service_pro_user/Provider/user_provider/put_user_provider.dart';

class ActiveStatus extends StatefulWidget {
  const ActiveStatus({Key? key}) : super(key: key);

  @override
  _ActiveStatusState createState() => _ActiveStatusState();
}

class _ActiveStatusState extends State<ActiveStatus> {
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    isActive =
        Provider.of<ProfileProvider>(context, listen: false).data['Active'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Status'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Online'),
              trailing: CupertinoSwitch(
                value: isActive,
                onChanged: (bool value) {
                  setState(() {
                    isActive = value;
                  });
                  Provider.of<UpdateUserDetails>(context, listen: false)
                      .changeActiveState(context, value);
                },
              ),
            ),
            ListTile(
              title: Text('Offline'),
              trailing: CupertinoSwitch(
                value: !isActive,
                onChanged: (bool value) {
                  setState(() {
                    isActive = !value;
                  });
                  Provider.of<UpdateUserDetails>(context, listen: false)
                      .changeActiveState(context, !value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
