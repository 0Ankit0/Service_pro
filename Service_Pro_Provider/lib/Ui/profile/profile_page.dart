import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/rating_and_reviews/get_reviews_provider.dart';
import 'package:service_pro_provider/Ui/profile/widget/add_remove_service.dart';
import '../../Provider/profile_provider.dart';
import '../../Provider/login_signup_provider/login_logout_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double averageRating = 0.0;

  @override
  void initState() {
    //yo page kholda yaa vako API lai load garni data haru pailai dhekaidinxa
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ProfileProvider>(context, listen: false)
          .userProfile(context);
      await showReviews(context);
    });
  }

  Future<void> showReviews(BuildContext context) async {
    final id = Provider.of<ProfileProvider>(context, listen: false).data['_id'];
    if (id == null) {
      print('Profile ID is null');
      return;
    }

    final reviewsProvider =
        Provider.of<GetReviewsProvider>(context, listen: false);
    await reviewsProvider.getReviews(context, id);
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
    return SingleChildScrollView(
      child: Consumer<ProfileProvider>(builder: (context, profile, child) {
        if (profile.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        Color activeColor = Colors.grey;
        final active = profile.data['Active'];
        if (active == false) {
          activeColor = Colors.red;
        } else if (active == true) {
          activeColor = Colors.green;
        }
        var user = profile.data;
        final profilePic = (user['ProfileImg'] ??
            'https://dudewipes.com/cdn/shop/articles/gigachad.jpg?v=1667928905&width=2048');
        final List<String> serviceIds =
            user['Services'] != null ? List<String>.from(user['Services']) : [];

        return Container(
          color: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF43cbac), Colors.white],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withOpacity(0.9),
                            spreadRadius: 5,
                            blurRadius: 3,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profilePic.toString()),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      color: Theme.of(context).primaryColor,
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ListTile(
                        title: Text(
                          user['Name'] ?? 'Invalid Name',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Services: ${(user['ServiceAnalytics']?['TotalServices'] ?? 0).toString()}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Completed Services: ${(user['ServiceAnalytics']?['CompletedServices'] ?? 0).toString()}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddRemoveService(
                                  selectedServiceIds: serviceIds,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Manage your Services',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Ratings & Reviews',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
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
                    Consumer<GetReviewsProvider>(
                      builder: (context, reviewsProvider, child) {
                        final reviews = reviewsProvider.getreviews;
                        if (reviews.isEmpty) {
                          return Center(child: Text('No reviews yet'));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
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
                                        reviews[index]['UserId']
                                                ['ProfileImg'] ??
                                            'https://dudewipes.com/cdn/shop/articles/gigachad.jpg?v=1667928905&width=2048')),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(reviews[index]['UserId']['Name'],
                                        style: TextStyle(color: Colors.white)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: buildStarWidgets(
                                          reviews[index]['Rating'].toDouble(),
                                          15),
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
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
