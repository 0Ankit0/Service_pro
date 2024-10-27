// import 'package:flutter/material.dart';
// import 'package:service_provide_app/models/category_model.dart';

// class CategoryService extends StatefulWidget {
//   final CategoryModel categoryData;
//   const CategoryService({Key? key, required this.categoryData})
//       : super(key: key);

//   @override
//   State<CategoryService> createState() => _CategoryServiceState();
// }

// class _CategoryServiceState extends State<CategoryService> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.categoryData.Name),
//       ),
//       body: ListView.builder(
//           itemCount: widget.categoryData.Services.length,
//           itemBuilder: (context, index) {
//             final serviceData = widget.categoryData.Services[index];
//             return ListTile(
//               title: Text(serviceData.Name),
//               trailing: Text('Rs ${serviceData.Price}'),
//             );
//           }),
//     );
//   }
// }
