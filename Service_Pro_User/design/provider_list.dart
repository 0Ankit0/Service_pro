import 'package:flutter/material.dart';

class HomeCleaningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/cleaning.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Home Cleaning',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Proper Cleaning & Sanitization Services',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        children: [
                          ...List.generate(
                            5,
                            (index) => const Icon(Icons.star,
                                color: Colors.yellow, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const Text(
                'Available Providers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const ProviderCard(
              name: 'Smith Jones',
              rate: 40,
              rating: 5,
              imageUrl: 'assets/provider.jpg',
              isVerified: true,
            ),
            const ProviderCard(
              name: 'Martin Jacob',
              rate: 40,
              rating: 4,
              imageUrl: 'assets/provider.jpg',
              isVerified: false,
            ),
            const ProviderCard(
              name: 'Zakir Vasim',
              rate: 40,
              rating: 4,
              imageUrl: 'assets/provider.jpg',
              isVerified: false,
            ),
            const ProviderCard(
              name: 'Johnson Smith',
              rate: 40,
              rating: 5,
              imageUrl: 'assets/provider.jpg',
              isVerified: false,
            ),
            const ProviderCard(
              name: 'Zakir Vasim',
              rate: 40,
              rating: 4,
              imageUrl: 'assets/provider.jpg',
              isVerified: false,
            ),
          ],
        ),
      ),
    );
  }
}

class ProviderCard extends StatelessWidget {
  final String name;
  final double rate;
  final int rating;
  final String imageUrl;
  final bool isVerified;

  const ProviderCard({
    required this.name,
    required this.rate,
    required this.rating,
    required this.imageUrl,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rate: \$$rate/HR',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      ...List.generate(
                        rating,
                        (index) => const Icon(Icons.star,
                            color: Colors.yellow, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}
