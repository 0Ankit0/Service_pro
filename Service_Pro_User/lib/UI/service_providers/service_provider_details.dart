import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/rating_and_reviews/get_reviews_provider.dart';
import 'package:service_pro_user/UI/chat/chat_screen.dart';

class ServiceProviderDetails extends StatefulWidget {
  final providerId;
  final providerName;
  final providerProfile;
  final providerAddress;
  final providerPhone;
  final providerEmail;
  final providerServiceTotal;
  final providerServiceCompleted;

  const ServiceProviderDetails({
    super.key,
    this.providerId,
    required this.providerName,
    this.providerProfile,
    required this.providerAddress,
    this.providerPhone,
    this.providerEmail,
    this.providerServiceTotal,
    this.providerServiceCompleted,
  });

  @override
  State<ServiceProviderDetails> createState() => _ServiceProviderDetailsState();
}

class _ServiceProviderDetailsState extends State<ServiceProviderDetails> {
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showReviews(context);
    });
  }

  Future<void> showReviews(BuildContext context) async {
    final reviewsProvider =
        Provider.of<GetReviewsProvider>(context, listen: false);
    await reviewsProvider.getReviews(context, widget.providerId);
    setState(() {
      averageRating = calculateAverageRating(reviewsProvider.getreviews);
    });
    print('Reviews: ${reviewsProvider.getreviews}');
  }

  double calculateAverageRating(List reviews) {
    if (reviews.isEmpty) return 0.0;
    double sum = reviews.fold(0, (prev, review) => prev + review['Rating']);
    return sum / reviews.length;
  }

  List<Widget> buildStarWidgets(double rating, double size) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      stars.add(Icon(
        Icons.star,
        color: i <= rating ? Colors.amber : Colors.grey,
        size: size,
      ));
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(widget.providerName),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).primaryColor, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 200.0,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(255, 125, 124, 124),
                            blurRadius: 50),
                      ],
                    ),
                    child: ListView.builder(
                      itemCount: widget.providerProfile?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(widget.providerProfile),
                        );
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  Positioned(
                    bottom: -50.0,
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: widget.providerProfile != null
                          ? NetworkImage(widget.providerProfile)
                          : null, // or some default image
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60.0),
              Container(
                child: Text(
                  widget.providerName,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Card(
                color: const Color(0xFF43cbac),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Address: ${widget.providerAddress}',
                        style: TextStyle(fontSize: 17.0, color: Colors.white),
                      ),
                      Text(
                        'Total Services: ${widget.providerServiceTotal}',
                        style: TextStyle(fontSize: 17.0, color: Colors.white),
                      ),
                      Text(
                        'Completed Services: ${widget.providerServiceCompleted}',
                        style: TextStyle(fontSize: 17.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            providerId: widget.providerId ?? '',
                            providerName: widget.providerName ?? '',
                            providerImage: widget.providerProfile ?? '',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('Chat'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF43cbac),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  // const SizedBox(width: 10.0),
                  // ElevatedButton.icon(
                  //   onPressed: () {},
                  //   icon: const Icon(Icons.book),
                  //   label: const Text('Request'),
                  //   style: ElevatedButton.styleFrom(
                  //     foregroundColor: Colors.white,
                  //     backgroundColor: const Color(0xFF43cbac),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(15.0),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              // const Divider(),
              // const Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Text(
              //     'About',
              //     style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16.0),
              //   child: Text(
              //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              //     'Vestibulum vehicula ex eu gravida luctus. Donec vitae arcu '
              //     'sed tortor facilisis consectetur.',
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Ratings & Reviews',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      '${averageRating.toStringAsFixed(1)}',
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buildStarWidgets(averageRating, 35),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // const Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Text(
              //     'Reviews',
              //     style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              //   ),
              // ),
              Consumer<GetReviewsProvider>(
                builder: (context, reviewsProvider, child) {
                  final reviews = reviewsProvider.getreviews;
                  if (reviews.isEmpty) {
                    return Center(child: Text('No reviews yet'));
                  }
                  return ListView.builder(
                    shrinkWrap: true, // Important to prevent infinite height
                    physics:
                        NeverScrollableScrollPhysics(), // Disables scrolling within the ListView
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color(0xFF43cbac),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 3.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                            leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    reviews[index]['UserId']['ProfileImg'] ??
                                        'https://via.placeholder.com/110')),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(reviews[index]['UserId']['Name'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18.0)),
                                Row(
                                  children: buildStarWidgets(
                                      reviews[index]['Rating'].toDouble() ?? '',
                                      20),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Service: ${reviews[index]['ServiceId']['Name']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Comment: ${reviews[index]['Comment']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.report),
        backgroundColor: const Color(0xFF43cbac),
      ),
    );
  }
}
