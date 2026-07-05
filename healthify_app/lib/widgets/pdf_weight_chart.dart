import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/chart_data.dart';

class PdfWeightChart extends StatelessWidget {

  final List<ChartData> data;

  const PdfWeightChart({
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

          LineSeries<ChartData,String>(

            dataSource: data,

            xValueMapper: (d,_) => d.x,

            yValueMapper: (d,_) => d.y,

          )

        ],

      ),

    );

  }

}