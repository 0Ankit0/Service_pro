import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Admin%20Panel/user_details.dart';
import 'package:service_pro_provider/Provider/chat_user_provider.dart';
import 'package:service_pro_provider/Provider/deactivate_user_provider.dart';
import 'package:service_pro_provider/Provider/verify_provider.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  String _selectedRole = 'user / provider';
  String _selectedDateSort = 'old / new ';
  String _selectedVerificationStatus = 'verifyed / not';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    await Provider.of<ChatUserProvider>(context, listen: false)
        .getChatUser(context);
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<ChatUserProvider>(context).users;

    List filteredUsers = users.where((user) {
      if (_selectedRole.toLowerCase() != 'user / provider' &&
          user['Role'].toString().toLowerCase() !=
              _selectedRole.toLowerCase()) {
        return false;
      }
      if (_selectedVerificationStatus != 'verifyed / not') {
        bool isVerified = _selectedVerificationStatus == 'Verified';
        if (user['Verified'] != isVerified) {
          return false;
        }
      }
      return true;
    }).toList();

    if (_selectedDateSort != 'old / new ') {
      filteredUsers.sort((a, b) {
        DateTime dateA = DateTime.parse(a['createdAt']);
        DateTime dateB = DateTime.parse(b['createdAt']);
        if (_selectedDateSort == 'Latest') {
          return dateB.compareTo(dateA);
        } else {
          return dateA.compareTo(dateB);
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Manage Users',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: _selectedRole,
                items: <String>['user / provider', 'user', 'Provider']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
              ),
              DropdownButton<String>(
                value: _selectedDateSort,
                items: <String>['old / new ', 'Latest', 'Oldest']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDateSort = newValue!;
                  });
                },
              ),
              DropdownButton<String>(
                value: _selectedVerificationStatus,
                items: <String>['verifyed / not', 'Verified', 'Not Verified']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedVerificationStatus = newValue!;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchUsers,
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  Color verifyButtonColor =
                      filteredUsers[index]['Verified'] == true
                          ? Colors.blue
                          : Colors.orange;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsScreen(
                              name: filteredUsers[index]['Name'] ?? '',
                              user: filteredUsers[index]['Documents'] ?? []),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(filteredUsers[index]
                                  ['ProfileImg'] ??
                              'https://qph.cf2.quoracdn.net/main-qimg-45522400d2414ea1f59c13bd04663089'),
                        ),
                        title: Text(
                          filteredUsers[index]['Name'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email: ${filteredUsers[index]['Email'].toString()}',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Verified: ${filteredUsers[index]['Verified'].toString()}',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Active: ${filteredUsers[index]['Active'].toString()}',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Role: ${filteredUsers[index]['Role'].toString()}',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Created: ${DateFormat('MMMM d, y').format(DateTime.parse(filteredUsers[index]['createdAt']))}',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Modified: ${DateFormat('MMMM d, y').format(DateTime.parse(filteredUsers[index]['updatedAt']))}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.verified,
                                    color: verifyButtonColor),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            'Verify  ${filteredUsers[index]['Name'].toString()}'),
                                        content: Text(
                                            'Are you sure you want to verify this account?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              try {
                                                await Provider.of<
                                                            VerifyAccount>(
                                                        context,
                                                        listen: false)
                                                    .verifyAccount(
                                                  context,
                                                  filteredUsers[index]['_id']
                                                      .toString(),
                                                );
                                                setState(
                                                    () {}); // Refresh UI after verification
                                                Navigator.pop(context);
                                              } catch (e) {
                                                print('Verification error: $e');
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Text('Verify'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              'Delete  ${filteredUsers[index]['Name'].toString()}'),
                                          content: Text(
                                              'Are you sure you want to delete this account?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                try {
                                                  await Provider.of<DeleteUser>(
                                                          context,
                                                          listen: false)
                                                      .deleteUser(
                                                    context,
                                                    filteredUsers[index]['_id']
                                                        .toString(),
                                                  );
                                                  setState(
                                                      () {}); // Refresh UI after deletion
                                                  Navigator.pop(context);
                                                } catch (e) {
                                                  print('Deletion error: $e');
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
