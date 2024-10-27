import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/category_provider.dart';
import 'package:service_pro_user/Provider/search_provider/service_search_provider.dart';
import 'package:service_pro_user/UI/home_screen/widgets/service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:service_pro_user/UI/service_providers/service_providers.dart';

class CustomCacheManager extends CacheManager {
  static const key = "customCacheKey";

  CustomCacheManager()
      : super(Config(
          key,
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 1000,
        ));
}

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CategoryProvider>(context, listen: false).getCategories();
  }

  Future<void> showSearchResults(BuildContext context) async {
    final searchServiceData =
        Provider.of<SearchService>(context, listen: false).searchData;
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Search Results',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: searchServiceData.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No results found.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchServiceData.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ServiceProviders(
                                      serviceData: searchServiceData[index]),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.search),
                                  title: Text(
                                    searchServiceData[index]['Name'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    searchServiceData[index]['Description']
                                        .toString(),
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
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
          // Filter categories where Active is not false
          final activeCategoryData = categoryProvider.categories
              .where((category) => category.active != false)
              .toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text(
                          'CATEGORIES',
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10.0),
                              hintText: 'Search Services',
                              hintStyle: TextStyle(color: Colors.white54),
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.white),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send, color: Colors.white),
                                onPressed: () async {
                                  try {
                                    await Provider.of<SearchService>(context,
                                            listen: false)
                                        .setSearchService(
                                            context, searchController.text);
                                    await showSearchResults(context);
                                  } catch (e) {
                                    print('search failed: $e');
                                  }
                                  searchController.clear();
                                },
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activeCategoryData.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final categories = activeCategoryData[index];
                      String image = categories.image.toString();
                      image = image.replaceFirst('localhost', '20.52.185.247');
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Service(category: categories),
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
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: CachedNetworkImage(
                                        imageUrl: image,
                                        cacheManager: CustomCacheManager(),
                                        placeholder: (context, url) => Lottie.asset(
                                            'assets/lotties_animation/loading.json'),
                                        errorWidget: (context, url, error) =>
                                            Lottie.asset(
                                                'assets/lotties_animation/error.json')),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              categories.name.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          );
        }
      },
    );
  }
}
