import 'package:flutter/material.dart';

class RatingAndReviewsScreen extends StatelessWidget {
  const RatingAndReviewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rating & Reviews',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            RatingBlock(),
            SizedBox(height: 20.0),
            RowReviewsCount(),
            SizedBox(height: 20.0),
            Column(
              children: [
                WriteAReviewButton(),
                SizedBox(height: 20.0),
                ReviewItem(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RatingBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class RowReviewsCount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class WriteAReviewButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit),
          SizedBox(width: 8.0),
          Text('Write a Review'),
        ],
      ),
    );
  }
}

class ReviewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void main() {
  runApp(MaterialApp(
    home: RatingAndReviewsScreen(),
  ));
}
