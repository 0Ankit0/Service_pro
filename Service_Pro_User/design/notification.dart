import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: const Icon(Icons.arrow_back),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
        backgroundColor: Color.fromARGB(255, 109, 233, 241),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SectionHeader(title: 'Today'),
            NotificationCard(
              iconData: Icons.check_circle,
              iconColor: Colors.cyan,
              title: 'Payment Successful!',
              description: 'Service booking was successful!',
            ),
            NotificationCard(
              iconData: Icons.account_balance_wallet,
              iconColor: Colors.blue,
              title: 'E-sewa Connected',
              description: 'E-Sewa has been connected to Helia',
            ),
            const SectionHeader(title: 'Yesterday'),
            NotificationCard(
              iconData: Icons.cancel,
              iconColor: Colors.red,
              title: 'Service Booking Canceled',
              description:
                  'You have canceled your Service booking of pipe reparing',
            ),
            NotificationCard(
              iconData: Icons.lock,
              iconColor: Colors.blueAccent,
              title: '2 step verification successful',
              description: 'booking was successful!',
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final String title;
  final String description;

  const NotificationCard({
    required this.iconData,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2C2C2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.2),
              child: Icon(
                iconData,
                color: iconColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
