// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:provider/provider.dart';
// import 'package:service_provide_app/models/category_model.dart';
// import 'package:service_provide_app/provider/api_provider.dart';
// import 'carousel_slider.dart';
// import 'category_service.dart';

// class CustomerPortal extends StatefulWidget {
//   final Color textColor;
//   const CustomerPortal({Key? key, this.textColor = Colors.black})
//       : super(key: key);

//   @override
//   State<CustomerPortal> createState() => _CustomerPortalState();
// }

// class _CustomerPortalState extends State<CustomerPortal> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 10, right: 10),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Carousel Slider Widget
//             CarouselSlider(),

//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 color: Theme.of(context).primaryColor,
//               ),
//               child: const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'Categories',
//                       style: TextStyle(fontSize: 20, color: Colors.white),
//                     ),
//                   )),
//             ),
//             const SizedBox(height: 10),
//             // Consumer Widget for fetching categories
//             Consumer<ApiProvider>(builder: (context, apiProvider, child) {
//               final categories = apiProvider.categories;
//               return MasonryGridView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: categories.length,
//                   gridDelegate:
//                       const SliverSimpleGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                   ),
//                   itemBuilder: (context, index) {
//                     final categoryData = categories[index];
//                     String image = categoryData.Image;
//                     image = image.replaceFirst('localhost', '10.0.2.2');
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => CategoryService(
//                                       categoryData: categoryData,
//                                     )));
//                       },
//                       child: Column(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(2),
//                             child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(5),
//                                 child: Image.network(image)),
//                           ),
//                           Text(
//                             categoryData.Name,
//                             style: TextStyle(
//                                 color: widget.textColor,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     );
//                   });
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }
