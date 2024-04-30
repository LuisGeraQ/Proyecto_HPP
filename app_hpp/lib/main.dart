import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(MatrixApp());
}

class MatrixApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSV Chart Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('CSV Chart Example'),
        ),
        body: ChartWidget(),
      ),
    );
  }
}

class ChartWidget extends StatefulWidget {
  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  List<List<dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  Future<void> loadCSV() async {
    final String csvData = await rootBundle.loadString('assets/data.csv');
    setState(() {
      data = CsvToListConverter().convert(csvData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: data.isEmpty ? CircularProgressIndicator() : buildChart(),
    );
  }

  Widget buildChart() {
    // Extracting data for X and Y axes
    List<charts.Series<dynamic, num>> series = [
      charts.Series(
        id: 'Data',
        data: data.map((row) {
          // Assuming the first column is X and the second is Y
          return charts.SeriesDatum(row[0], row[1]);
        }).toList(),
        domainFn: (datum, _) => datum.x,
        measureFn: (datum, _) => datum.y,
      )
    ];

    return Container(
      width: 300,
      height: 300,
      child: charts.ScatterPlotChart(
        series,
        animate: true,
      ),
    );
  }
}
