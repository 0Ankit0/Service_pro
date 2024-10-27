import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const ChatScreen({required this.userId, required this.userName, Key? key})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _connectSocket();
    _fetchMessages();
  }

  void _connectSocket() async {
    final token = await AuthService().getToken();
    if (token != null) {
      socket = IO.io('http://20.52.185.247:8000', <String, dynamic>{
        'transports': ['websocket'],
        'query': {'token': token},
      });

      socket.on('connect', (_) {
        print('Connected to socket server');
      });

      socket.on('liveMessage', (data) {
        setState(() {
          messages.add({
            'sender': 'receiver', // Assuming the message is from the receiver
            'message': data,
          });
        });
      });

      socket.on('disconnect', (_) => print('Disconnected from socket server'));
    } else {
      // Handle the case where the token is null
      print('Token is null. Cannot connect to socket server.');
    }
  }

  Future<void> _fetchMessages() async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    final response = await http.post(
      Uri.parse('http://20.52.185.247:8000/message'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'receiver': widget.userId}),
    );

    if (response.statusCode == 200) {
      print('Response: ${response.body}');

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      var newMessages = data['data'] as List<dynamic>;

      setState(() {
        messages = newMessages.map<Map<String, dynamic>>((message) {
          return {
            'sender': message['status'] == 'sender' ? 'sender' : 'receiver',
            'message': message['message'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load messages');
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = {
        'receiverId': widget.userId,
        'message': _controller.text,
        'sender': 'sender', // Customize this to reflect the actual sender ID
        'createdAt': DateTime.now().toString(),
      };
      socket.emit('message', message);
      setState(() {
        messages.add(message);
        _controller.clear();
      });
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isSentByMe = message['sender'] == 'sender';
                return Align(
                  alignment:
                      isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSentByMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(message['message']),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
