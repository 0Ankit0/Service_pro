import 'package:flutter/material.dart';

class RequestManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Management'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Pending'),
                Tab(text: 'Completed'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  PendingRequestsTab(),
                  Center(child: Text('No Completed Requests')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PendingRequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return RequestItemCard();
      },
    );
  }
}

class RequestItemCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service Name', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text('Add: 4517 Washington Ave. Manchester, Kentucky...'),
            SizedBox(height: 8.0),
            Text('Service Details: Lorem ipsum dolor sit amet, consectetur...'),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: '18/05/2022',
                  items: [
                    DropdownMenuItem(
                      child: Text('18/05/2022'),
                      value: '18/05/2022',
                    ),
                  ],
                  onChanged: (value) {},
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child:
                          Text('REJECT', style: TextStyle(color: Colors.red)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child:
                          Text('APPROVE', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
