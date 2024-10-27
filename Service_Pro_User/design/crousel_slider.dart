// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dots_indicator/dots_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class CustomerPortal extends StatefulWidget {
//   final Color textColor;
//   const CustomerPortal({Key? key, this.textColor = Colors.black})
//       : super(key: key);

//   @override
//   State<CustomerPortal> createState() => _CustomerPortalState();
// }

// class _CustomerPortalState extends State<CustomerPortal> {
//   final sliderImg = [
//     "https://cdn.pixabay.com/photo/2023/08/22/10/52/city-8206042_640.png",
//     "https://cdn.pixabay.com/photo/2023/08/19/13/42/water-8200502_1280.jpg",
//     "https://cdn.pixabay.com/photo/2023/08/20/08/30/luis-i-bridge-8201941_640.jpg",
//     "https://cdn.pixabay.com/photo/2024/03/01/16/25/costa-rica-8606850_640.jpg",
//   ];
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 10, right: 10),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//               child: Stack(
//                 children: [
//                   CarouselSlider.builder(
//                     itemCount: sliderImg.length,
//                     itemBuilder: (context, index, realindex) {
//                       final sliderimages = sliderImg[index];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: CachedNetworkImage(
//                             imageUrl: sliderimages,
//                             placeholder: (context, url) =>
//                                 Center(child: CircularProgressIndicator()),
//                             errorWidget: (context, url, error) =>
//                                 Icon(Icons.error),
//                           ),
//                         ),
//                       );
//                     },
//                     options: CarouselOptions(
//                       viewportFraction: 0.8,
//                       autoPlay: true,
//                       height: 200,
//                       onPageChanged: (index, reason) {
//                         setState(() {
//                           _currentIndex = index;
//                         });
//                       },
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 5,
//                     right: 0,
//                     left: 0,
//                     child: DotsIndicator(
//                       dotsCount: sliderImg.length,
//                       position: _currentIndex.toDouble().toInt(),
//                       decorator: const DotsDecorator(
//                         color: Colors.grey,
//                         activeColor: Colors.blue,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
