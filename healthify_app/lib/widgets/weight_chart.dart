import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeightChart extends StatelessWidget {

  final List<FlSpot> spots;

  const WeightChart({
    super.key,
    required this.spots,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      height: 250,

      child: LineChart(
  LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: 10,
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
      reservedSize: 40,

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

    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        color: const Color(0xFF00D9FF),

        barWidth: 4,

        dotData: FlDotData(
          show: true,
        ),

        belowBarData: BarAreaData(
          show: true,
          color: const Color(0xFF00D9FF).withValues(alpha:0.15),
        ),
      ),
    ],
  ),
),

    );

  }

}