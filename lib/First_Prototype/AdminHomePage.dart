import 'package:flutter/material.dart';
import 'package:my_app/First_Prototype/AdminMapPage.dart';
import 'package:my_app/First_Prototype/WaterQualityWidget.dart';

import 'TelegramPostWidget.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Home Page')),
      body: Column(
        children: [
          Expanded(child: WaterQualityWidget()),
          Expanded(child: WaterAvailabilityWidget()),
          Expanded(child: TelegramPostWidget()),
        ],
      ),
    );
  }
}

class WaterAvailabilityWidget extends StatelessWidget {
  final String ruralStatus = 'High'; // Placeholder
  final String urbanStatus = 'Medium'; // Placeholder

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminMapPage()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Water Availability"),
            Text("Rural: $ruralStatus"),
            Text("Urban: $urbanStatus"),
          ],
        ),
      ),
    );
  }
}
