import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartService {

  static List<FlSpot> buildWeightSpots(
      List<dynamic> weightHistory) {

    List<FlSpot> spots = [];

    for (int i = 0; i < weightHistory.length; i++) {

      spots.add(

        FlSpot(

          i.toDouble(),

          double.parse(
            weightHistory[i]['weight'].toString(),
          ),

        ),

      );

    }

    return spots;
  }
  static List<BarChartGroupData> buildCaloriesBars(
    List<dynamic> foodHistory) {

  List<BarChartGroupData> bars = [];

for (int i = 0; i < foodHistory.length; i++) {

  bars.add(

    BarChartGroupData(

      x: i,

      barRods: [

        BarChartRodData(

          toY: double.parse(
            foodHistory[i]['total_calories'].toString(),
          ),

          width: 18,

          color: const Color(0xFF00D9FF),

          borderRadius: BorderRadius.circular(8),

        ),

      ],

    ),

  );

}

  return bars;
}
}