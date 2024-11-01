import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'AdminMapPage.dart';

class WaterQualityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder data for WQI. Replace this with actual data from your API.
    Map<String, double> wqiData = {
      "Good": 40,
      "Moderate": 35,
      "Poor": 25,
    };

    return GestureDetector(
      onTap: () {
        // Navigate to map page for adding/removing pins
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminMapPage()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Water Quality Monitoring"),
            PieChart(
              dataMap: wqiData,
              chartRadius: 100,
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
