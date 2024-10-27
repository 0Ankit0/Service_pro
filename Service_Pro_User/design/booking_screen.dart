import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = "02:30 PM";
  String location = "1108 Bottom Lane, Gasport City, NY\nNew York\n14067";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a date"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${selectedDate.month} ${selectedDate.day}, ${selectedDate.year}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Saturday",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                DateTime date = DateTime.now().add(Duration(days: index));
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          selectedDate == date ? Colors.orange : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Column(
                      children: [
                        Text(
                          "${date.day}",
                          style: TextStyle(
                            color: selectedDate == date
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${[
                            "Thu",
                            "Fri",
                            "Sat",
                            "Sun",
                            "Mon",
                            "Tue"
                          ][index]}",
                          style: TextStyle(
                            color: selectedDate == date
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 32),
            Text(
              "Select time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  ["02:30 PM", "06:00 PM", "08:30 PM", "10:00 PM"].map((time) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTime = time;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedTime == time ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Text(
                      time,
                      style: TextStyle(
                        color:
                            selectedTime == time ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 32),
            Text(
              "Location",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                location,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Confirm Booking"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
