import 'package:flutter/material.dart';

class UserDetailsScreen extends StatefulWidget {
  final String name;
  final List user;
  const UserDetailsScreen({super.key, required this.user, required this.name});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: ListView.builder(
        itemCount: widget.user.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Image.network(
                '${widget.user[index]}',
                fit: BoxFit.cover,
              ),
            ]),
          );
        },
      ),
    );
  }
}
