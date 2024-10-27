import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/category_and_service_provider/service_provider.dart';
import 'package:service_pro_user/Provider/chat_user_provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:service_pro_user/Provider/rating_and_reviews/reviews_provider.dart';
import 'package:service_pro_user/Provider/serviceRequest_provider/get_service_request_provider.dart';
import 'package:service_pro_user/Provider/serviceRequest_provider/serviceRequest_provider.dart';
import 'package:service_pro_user/UI/Request/payment/khalti_screen.dart';

class Booking extends StatefulWidget {
  const Booking({Key? key}) : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = getBothData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _dataFuture = getBothData();
    });
  }

  Future<Map<String, dynamic>> getBothData() async {
    final requestData =
        await Provider.of<GetServiceRequest>(context, listen: false)
            .getServiceRequest(context);
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['id'];
    final allData = await Provider.of<ServiceProvider>(context, listen: false)
        .getService(context);
    final providerData =
        await Provider.of<ChatUserProvider>(context, listen: false)
            .getChatUser(context);

    return {
      'requestData': requestData,
      'allData': allData,
      'userId': userId,
      'providerData': providerData,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final requestData =
              snapshot.data?['requestData'] as List<dynamic>? ?? [];
          final allData = snapshot.data?['allData'] as List<dynamic>? ?? [];
          final providerData =
              snapshot.data?['providerData'] as List<dynamic>? ?? [];
          final userId = snapshot.data?['userId'] as String? ?? '';

          // Categorize requests
          final pendingRequests = [],
              acceptedRequests = [],
              rejectedRequests = [],
              completedRequests = [],
              canceledRequests = [];
          for (var request in requestData) {
            if (request['UserId'] == userId) {
              switch (request['Status']) {
                case 'pending':
                  pendingRequests.add(request);
                  break;
                case 'accepted':
                  acceptedRequests.add(request);
                  break;
                case 'rejected':
                  rejectedRequests.add(request);
                  break;
                case 'completed':
                  completedRequests.add(request);
                  break;
                case 'cancelled':
                  canceledRequests.add(request);
                  break;
              }
            }
          }

          // Build UI for each category
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildSection('Pending', pendingRequests, Colors.orange,
                      allData, providerData),
                  _buildSection('Accepted', acceptedRequests, Colors.blue,
                      allData, providerData),
                  _buildSection('Rejected', rejectedRequests, Colors.red,
                      allData, providerData),
                  _buildSection('Completed', completedRequests, Colors.green,
                      allData, providerData),
                  _buildSection('Canceled', canceledRequests, Colors.grey,
                      allData, providerData),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildSection(String title, List<dynamic> requests, Color color,
      List<dynamic> allData, List<dynamic> providerData) {
    if (requests.isEmpty) return const SizedBox.shrink(); // Or show a message

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          color: color,
          child: Row(
            children: [
              Icon(
                _getIconForCategory(title),
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...requests
            .map((request) =>
                _buildRequestItem(request, allData, providerData, title))
            .toList(),
      ],
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'pending':
        return Icons.access_time;
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.close;
      case 'completed':
        return Icons.check;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.error_outline;
    }
  }

  Widget _buildRequestItem(dynamic request, List<dynamic> allData,
      List<dynamic> providerData, String sectionTitle) {
    var service = allData.firstWhere((s) => s['_id'] == request['ServiceId'],
        orElse: () => null);
    var provider = providerData.firstWhere(
        (p) => p['_id'] == request['ProviderId'],
        orElse: () => null);

    if (service == null || provider == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  service['Name'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  'Provider: ${provider['Name'] ?? ''}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Text(
              DateFormat('MMM d h:mm a').format(
                  DateTime.parse(request['updatedAt'])
                      .toUtc()
                      .add(Duration(hours: 5, minutes: 45))),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Status: ${request['Status']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: _getStatusColor(request['Status']),
                  ),
                ),
              ],
            ),
            if (sectionTitle == 'Accepted')
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Complete Task'),
                                content: const Text(
                                    'Are you sure you want to pay this task?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const KhaltiExampleApp()));
                                    },
                                    child: const Text('pay'),
                                  ),
                                ],
                              );
                            });
                      },
                      child: const Text('Pay Task'),
                    ),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Complete Task'),
                                  content: const Text(
                                      'Are you sure you want to complete this task?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await Provider.of<
                                                    ServiceRequestProvider>(
                                                context,
                                                listen: false)
                                            .completeRequest(
                                                context, request['_id'])
                                            .then((value) {
                                          // After completing, open rating and reviews dialog
                                          Navigator.of(context)
                                              .pop(); // Close previous dialog
                                          _showRatingReviewDialog(
                                              context,
                                              request['ProviderId'],
                                              request['ServiceId']);
                                        }).catchError((error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Failed to complete request: $error'),
                                            backgroundColor: Colors.red,
                                          ));
                                        });
                                      },
                                      child: const Text('Complete'),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Text('Complete Task'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Cancel Task'),
                                  content: const Text(
                                      'Are you sure you want to cancel this task?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await Provider.of<
                                                    ServiceRequestProvider>(
                                                context,
                                                listen: false)
                                            .cancelRequest(
                                                context, request['_id'])
                                            .then((value) {
                                          // After completing, open rating and reviews dialog
                                          Navigator.of(context)
                                              .pop(); // Close previous dialog
                                        }).catchError((error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Failed to cancel request: $error'),
                                            backgroundColor: Colors.red,
                                          ));
                                        });
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Text('Cancel Task'),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.green;
      case 'canceled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}

void _showRatingReviewDialog(
    BuildContext context, String providerId, String serviceId) {
  double rating = 0.0;
  TextEditingController commentController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Rating and Reviews'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Rating'),
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (ratingValue) {
                rating = ratingValue; // Update the rating based on selection
              },
            ),
            TextFormField(
              controller: commentController,
              decoration: const InputDecoration(labelText: 'Comment'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Add rating and reviews

              String comment = commentController.text;

              await Provider.of<RatingReview>(context, listen: false)
                  .addRatingReviews(context, serviceId, providerId,
                      rating.toString(), comment);

              Navigator.of(context).pop(); // Close dialog after submitting
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}
