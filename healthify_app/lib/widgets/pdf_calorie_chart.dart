import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/chart_data.dart';

class PdfCalorieChart extends StatelessWidget {

  final List<ChartData> data;

  const PdfCalorieChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      height: 300,

      child: SfCartesianChart(

        primaryXAxis: CategoryAxis(),

        series: [

          ColumnSeries<ChartData,String>(

            dataSource: data,

xValueMapper: (ChartData d, _) => d.x,

yValueMapper: (ChartData d, _) => d.y,

          )

        ],

      ),

    );

  }

}