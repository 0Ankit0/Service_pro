import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/service_provider/service_provider.dart';
import 'package:service_pro_provider/Provider/chat_user_provider.dart';
import 'package:service_pro_provider/Provider/get_service_request.dart';
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Color tabColor = Colors.black;

  final List<Color> tabColors = [
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.grey, // Color for canceled tab
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 5, vsync: this); // Updated length to 5
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          tabColor = tabColors[_tabController.index];
        });
      }
    });
    fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final chatUserProvider =
        Provider.of<ChatUserProvider>(context, listen: false);
    final getServiceRequest =
        Provider.of<GetServiceRequest>(context, listen: false);
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);

    await chatUserProvider.getChatUser(context);
    await getServiceRequest.getServiceRequest(context);
    await serviceProvider.getServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text('Pending',
                  style: TextStyle(
                      color: Colors.orange)), // Specific color for this tab
            ),
            Tab(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('Accepted', style: TextStyle(color: Colors.green)),
              ), // Specific color for this tab
            ),
            Tab(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('Completed',
                    style: TextStyle(
                      color: Colors.blue,
                    )),
              ), // Specific color for this tab
            ),
            Tab(
              child: Text('Rejected',
                  style: TextStyle(
                      color: Colors.red)), // Specific color for this tab
            ),
            Tab(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('Canceled',
                    style: TextStyle(
                      color: Colors.grey,
                    )),
              ), // Specific color for this tab
            ),
          ],
          indicatorColor: tabColor,
        ),
      ),
      body: Consumer4<ChatUserProvider, GetServiceRequest, ServiceProvider,
          LoginLogoutProvider>(
        builder: (context, chatUserProvider, getServiceRequest, serviceProvider,
            loginLogoutProvider, child) {
          final userData = chatUserProvider.users;
          final requestData = getServiceRequest.serviceRequests;
          final serviceData = serviceProvider.service;
          final token = loginLogoutProvider.token;

          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          final id = decodedToken['id'];

          List getFilteredRequests(String status) {
            return requestData
                .where((request) =>
                    request['ProviderId'] == id && request['Status'] == status)
                .toList();
          }

          return TabBarView(
            controller: _tabController,
            children: [
              RequestList(
                  requests: getFilteredRequests('pending'),
                  status: 'pending',
                  userData: userData,
                  serviceData: serviceData,
                  fetchData: fetchData),
              RequestList(
                  requests: getFilteredRequests('accepted'),
                  status: 'accepted',
                  userData: userData,
                  serviceData: serviceData,
                  fetchData: fetchData),
              RequestList(
                  requests: getFilteredRequests('completed'),
                  status: 'completed',
                  userData: userData,
                  serviceData: serviceData,
                  fetchData: fetchData),
              RequestList(
                  requests: getFilteredRequests('rejected'),
                  status: 'rejected',
                  userData: userData,
                  serviceData: serviceData,
                  fetchData: fetchData),
              RequestList(
                  requests: getFilteredRequests('cancelled'),
                  status: 'cancelled',
                  userData: userData,
                  serviceData: serviceData,
                  fetchData: fetchData),
            ],
          );
        },
      ),
    );
  }
}

class RequestList extends StatelessWidget {
  final List requests;
  final String status;
  final List userData;
  final List serviceData;
  final Future<void> Function() fetchData;

  const RequestList({
    Key? key,
    required this.requests,
    required this.status,
    required this.userData,
    required this.serviceData,
    required this.fetchData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchData,
      child: requests.isEmpty
          ? Center(child: Text('No $status requests'))
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) => RequestCard(
                request: requests[index],
                userData: userData,
                serviceData: serviceData,
              ),
            ),
    );
  }
}

class RequestCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final List userData;
  final List serviceData;

  const RequestCard({
    Key? key,
    required this.request,
    required this.userData,
    required this.serviceData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = userData.firstWhere(
      (user) =>
          user['_id'] ==
          request[
              'UserId'], //request ma vako user id ra user ma vako user id match hunxa vani user ko data pathauni natra unknown dhekauni
      orElse: () => {'Name': 'Unknown'},
    );
    final service = serviceData.firstWhere(
      (service) => service['_id'] == request['ServiceId'],
      orElse: () => {'Name': 'Unknown'},
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User: ${user['Name']}',
                    ),
                    Text(
                      'Service: ${service['Name']}',
                    ),
                    Text(
                      'Address: ${user['Address']}',
                    ),
                    Text(
                      DateFormat('MMM d h:mm a').format(DateTime.parse(request[
                              'updatedAt']) //kaile request pathako tesko time haru mention gareko ho
                          .toUtc()
                          .add(Duration(hours: 5, minutes: 45))),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return Scaffold(
                        appBar: AppBar(),
                        body: Center(
                          child: CachedNetworkImage(
                            fit: BoxFit.contain,
                            imageUrl: request['Image'] ?? ''.toString(),
                          ),
                        ),
                      );
                    }));
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: request['Image'].toString(),
                    ),
                  ),
                )
              ],
            ),
            if (request['Status'] == 'pending')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: () => _showConfirmationDialog(
                        context, 'Accept', request['_id']),
                    child: const Text(
                      'Accept',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _showConfirmationDialog(
                        context, 'Reject', request['_id']),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text(
                      'Reject',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String action, String requestId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$action Request'),
        content: Text(
            'Are you sure you want to $action this request?'), //action var ma accept or reject store vaxa
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final getServiceRequest =
                  Provider.of<GetServiceRequest>(context, listen: false);
              if (action == 'Accept') {
                await getServiceRequest.acceptRequest(context, requestId);
              } else {
                await getServiceRequest.rejectRequest(context, requestId);
              }
              Navigator.pop(context);
            },
            child: Text(action),
          ),
        ],
      ),
    );
  }
}
