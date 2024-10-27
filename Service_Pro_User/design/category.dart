import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Models/category_model.dart';
import 'package:service_pro_user/Provider/category_provider.dart';
import 'package:service_pro_user/UI/home_screen/widgets/service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  void initState() {
    super.initState();
    Provider.of<CategoryProvider>(context, listen: false).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.categories.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final categoryData = categoryProvider.categories;
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Categories',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categoryData.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final categories = categoryData[index];
                    String image = categories.image.toString();
                    image = image.replaceFirst('localhost', '20.52.185.247');

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Service(category: categories),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: 180,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                  imageUrl: image,
                                  placeholder: (context, url) => Lottie.asset(
                                      'assets/lotties_animation/loading.json'),
                                  errorWidget: (context, url, error) =>
                                      Lottie.asset(
                                          'assets/lotties_animation/error.json'),
                                  cacheManager: CacheManager(
                                    Config(
                                      'customCacheKey',
                                      stalePeriod: Duration(days: 7),
                                      maxNrOfCacheObjects: 100,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            categories.name.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
