import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final String providerId;
  final String providerName;
  final String providerImage;

  const ChatScreen(
      {required this.providerId,
      required this.providerName,
      required this.providerImage,
      Key? key})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _connectSocket();
    _fetchMessages();
  }

  void _connectSocket() async {
    try {
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
              'sender': 'receiver',
              'message': data,
            });
            _scrollToBottom();
          });
        });

        socket.on(
            'disconnect', (_) => print('Disconnected from socket server'));
      } else {
        print('Token is null. Cannot connect to socket server.');
      }
    } catch (e) {
      print('Error connecting to socket: $e');
    }
  }

  Future<void> _fetchMessages() async {
    try {
      final token =
          Provider.of<LoginLogoutProvider>(context, listen: false).token;
      if (token == null) {
        print('Token is null. Cannot fetch messages.');
        return;
      }
      final response = await http.post(
        Uri.parse('http://20.52.185.247:8000/message'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'receiver': widget.providerId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        print('messages: ${data}');
        var newMessages = data['data'] as List<dynamic>;

        setState(() {
          messages = newMessages.map<Map<String, dynamic>>((message) {
            return {
              'sender': message['status'] == 'sender' ? 'sender' : 'receiver',
              'message': message['message'],
              'createdAt': message['createdAt'] ?? '',
            };
          }).toList();
          _scrollToBottom();
        });
      } else {
        print('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = {
        'receiverId': widget.providerId,
        'message': _controller.text,
        'sender': 'sender',
        'createdAt': DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
      };
      print('Sending message: $message');
      socket.emit('message', message);
      setState(() {
        messages.add(message);
        _controller.clear();
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            Expanded(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
            Expanded(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.providerImage),
              ),
            ),
          ],
        ),
        backgroundColor: primaryColor,
        title: Text(widget.providerName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final String formattedTime = DateFormat('MMM d h:mm a').format(
                  DateTime.parse(message['createdAt'])
                      .toUtc()
                      .add(Duration(hours: 5, minutes: 45)),
                );
                final isSentByMe = message['sender'] == 'sender';
                return Align(
                  alignment:
                      isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSentByMe ? primaryColor : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['message'],
                          style: TextStyle(
                            color: isSentByMe ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          formattedTime,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSentByMe ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(
                    Icons.send,
                    color: primaryColor,
                  ),
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
