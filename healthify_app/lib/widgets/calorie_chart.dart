import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CalorieChart extends StatelessWidget {

  final List<BarChartGroupData> bars;

  const CalorieChart({
    super.key,
    required this.bars,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      height: 250,

      child: BarChart(

        BarChartData(
  gridData: FlGridData(
    show: true,
    drawVerticalLine: false,
    horizontalInterval: 200,
    getDrawingHorizontalLine: (value) {
      return FlLine(
        color: Colors.white12,
        strokeWidth: 1,
      );
    },
  ),

  borderData: FlBorderData(show: false),

titlesData: FlTitlesData(

  topTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),

  rightTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),

  leftTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: 45,

      getTitlesWidget: (value, meta) {
        return Text(
          value.toInt().toString(),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        );
      },
    ),
  ),

  bottomTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,

      getTitlesWidget: (value, meta) {
        return Text(
          value.toInt().toString(),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        );
      },
    ),
  ),
),

  barGroups: bars,
)

      ),

    );

  }
}