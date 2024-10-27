import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/service_provider/service_provider.dart';
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddRemoveService extends StatefulWidget {
  final List<String> selectedServiceIds;

  AddRemoveService({required this.selectedServiceIds});

  @override
  _AddRemoveServiceState createState() => _AddRemoveServiceState();
}

class _AddRemoveServiceState extends State<AddRemoveService> {
  List<String> _selectedServices = [];

  @override
  void initState() {
    super.initState();
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    serviceProvider.getServices();
    _selectedServices = List.from(widget.selectedServiceIds);
  }

  void _updateSelectedServices(bool selected, String serviceId) {
    setState(() {
      if (selected) {
        _selectedServices.add(serviceId);
      } else {
        _selectedServices.remove(serviceId);
      }
    });
  }

  Future<void> _updateUserServices(BuildContext context) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    final response = await http.put(
      Uri.parse('http://20.52.185.247:8000/user/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'Services': _selectedServices,
      }),
    );

    if (response.statusCode == 200) {
      print('Services updated successfully with ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Services updated successfully')),
      );
    } else {
      print(
          'Failed to update services: ${response.statusCode}, ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update services')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Add/Remove Service'),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                _updateUserServices(context);
              },
              child: Row(
                children: [
                  Text('Update'),
                  Icon(
                    Icons.upload,
                  )
                ],
              ))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.1)
            ],
          ),
        ),
        child: Consumer<ServiceProvider>(
          builder: (context, serviceProvider, child) {
            return ListView.builder(
              itemCount: serviceProvider.service.length,
              itemBuilder: (context, index) {
                final service = serviceProvider.service[index];
                final image = service['Image']
                        ?.toString()
                        .replaceAll('localhost', '20.52.185.247') ??
                    'https://via.placeholder.com/150';
                return ListTile(
                  title: Text(service['Name'].toString()),
                  subtitle: Text(service['Description'].toString()),
                  leading: Checkbox(
                    value: _selectedServices.contains(service['_id']),
                    onChanged: (bool? value) {
                      _updateSelectedServices(value!, service['_id']);
                    },
                  ),
                  trailing: Container(
                    child: Image.network(image,
                        width: 50, height: 50), //network baata image taanxa
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
