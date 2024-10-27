import 'package:flutter/material.dart';
import 'package:service_pro_user/UI/home_screen/widgets/Image_slider.dart';
import 'package:service_pro_user/UI/home_screen/widgets/category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ImageSlider(),
            Category(),
          ],
        ),
      ),
    );
  }
}
