// class Category extends StatefulWidget {
//   const Category({super.key});

//   @override
//   State<Category> createState() => _CategoryState();
// }

// class _CategoryState extends State<Category> {
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<CategoryProvider>(context, listen: false).getCategories();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Categories'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SearchScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Consumer<CategoryProvider>(
//         builder: (context, categoryProvider, child) {
//           if (categoryProvider.categories.isEmpty) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             final categoryData = categoryProvider.categories;
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(height: 10),
//                   GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: categoryData.length,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 10,
//                     ),
//                     itemBuilder: (context, index) {
//                       final categories = categoryData[index];
//                       String image = categories.image.toString();
//                       image = image.replaceFirst('localhost', '20.52.185.247');
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   Service(category: categories),
//                             ),
//                           );
//                         },
//                         child: Column(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 width: 180,
//                                 height: 150,
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(5),
//                                   child: FittedBox(
//                                     fit: BoxFit.fill,
//                                     child: CachedNetworkImage(
//                                       imageUrl: image,
//                                       placeholder: (context, url) =>
//                                           Lottie.asset(
//                                         'assets/lotties_animation/loading.json',
//                                       ),
//                                       errorWidget: (context, url, error) =>
//                                           Lottie.asset(
//                                         'assets/lotties_animation/error.json',
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               categories.name.toString(),
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
