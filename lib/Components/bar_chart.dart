// ignore_for_file: deprecated_member_use
import 'package:delivoo_stores/Provider/insight_provider.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';

class BarChartDetails extends StatefulWidget {
  BarChartDetails({
    Key? key,
  }) : super(key: key);

  _BarChartDetailsState createState() => _BarChartDetailsState();
}

class _BarChartDetailsState extends State<BarChartDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final seriesData = context.watch<InsightProvider>().seriesData;
    return Container(
      child: Center(
        child: charts.BarChart(
          seriesData!,
          animate: true,
          barGroupingType: charts.BarGroupingType.grouped,
          behaviors: [new charts.SeriesLegend()],
          animationDuration: Duration(seconds: 1),
        ),
      ),
    );
  }
}
