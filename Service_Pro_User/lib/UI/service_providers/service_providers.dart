import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:service_pro_user/UI/Request/service_request.dart';
import 'package:service_pro_user/UI/chat/chat_screen.dart';
import 'package:service_pro_user/UI/service_providers/service_provider_details.dart';

class ServiceProviders extends StatefulWidget {
  final dynamic serviceData;
  const ServiceProviders({Key? key, required this.serviceData})
      : super(key: key);

  @override
  State<ServiceProviders> createState() => _ServiceProvidersState();
}

class _ServiceProvidersState extends State<ServiceProviders> {
  List<dynamic> serviceProviders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchServiceData();
  }

  Future<void> fetchServiceData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(
          'http://20.52.185.247:8000/user/service/${widget.serviceData['_id']}'));
      if (response.statusCode == 200) {
        setState(() {
          serviceProviders = jsonDecode(response.body)['data'] as List;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load service data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Providers'),
        backgroundColor: const Color(0xFF43CBAC),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            )
          : serviceProviders.isEmpty
              ? const Center(
                  child: Text(
                    'No service providers found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: serviceProviders.length,
                  itemBuilder: (context, index) {
                    final providerId =
                        serviceProviders[index]['_id'].toString();
                    final providerName =
                        serviceProviders[index]['Name'].toString();
                    final providerAddress =
                        serviceProviders[index]['Address'].toString();
                    final providerPhone =
                        serviceProviders[index]['PhoneNo'].toString();
                    final providerEmail =
                        serviceProviders[index]['Email'].toString();
                    final providerServiceTotal = serviceProviders[index]
                            ['ServiceAnalytics']['TotalServices']
                        .toString();
                    final providerServiceCompleted = serviceProviders[index]
                            ['ServiceAnalytics']['CompletedServices']
                        .toString();
                    final providerProfile =
                        serviceProviders[index]['ProfileImg'].toString() ?? '';
                    if (serviceProviders[index]['Verified'] == true &&
                        serviceProviders[index]['Active'] == true) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceProviderDetails(
                                      providerId: providerId,
                                      providerName: providerName,
                                      providerAddress: providerAddress,
                                      providerPhone: providerPhone,
                                      providerEmail: providerEmail,
                                      providerServiceTotal:
                                          providerServiceTotal,
                                      providerServiceCompleted:
                                          providerServiceCompleted,
                                      providerProfile: providerProfile,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: providerProfile != null
                                        ? NetworkImage(providerProfile)
                                        : null, // or some default image
                                    radius: 40,
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          serviceProviders[index]['Name']
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              color: Colors.teal,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                serviceProviders[index]
                                                        ['Address']
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[700],
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.phone,
                                              color: Colors.teal,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              serviceProviders[index]['PhoneNo']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.email,
                                              color: Colors.teal,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                serviceProviders[index]['Email']
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[700],
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                  providerId: providerId ?? '',
                                                  providerName:
                                                      providerName ?? '',
                                                  providerImage:
                                                      providerProfile ?? '',
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Column(
                                            children: [
                                              SizedBox(height: 10),
                                              Icon(
                                                Icons.chat,
                                                color: Colors.white,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '  Chat ',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 5),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              10), // Add some space between the buttons
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ServiceRequest(
                                                  serviceData:
                                                      widget.serviceData,
                                                  providerId: providerId,
                                                  providerName: providerName,
                                                  providerAddress:
                                                      providerAddress,
                                                  providerPhone: providerPhone,
                                                  providerEmail: providerEmail,
                                                  providerServiceTotal:
                                                      providerServiceTotal,
                                                  providerServiceCompleted:
                                                      providerServiceCompleted,
                                                  providerProfile:
                                                      providerProfile
                                                          .toString(),
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Column(
                                            children: [
                                              SizedBox(height: 10),
                                              Icon(
                                                Icons
                                                    .assignment, // Changed icon to 'assignment'
                                                color: Colors.white,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Request',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 5),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
    );
  }
}
