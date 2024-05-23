import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AverageScoreGraph extends StatelessWidget {
  final bool isShowingMainData;
  final List<FlSpot> player1SetAverages;
  final List<FlSpot> player2SetAverages;

  const AverageScoreGraph({
    super.key,
    required this.isShowingMainData,
    required this.player1SetAverages,
    required this.player2SetAverages,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? mainData() : alternateData(),
      duration: const Duration(milliseconds: 250),
    );
  }

  List<FlSpot> convertAveragesToInts(List<FlSpot> averages) {
    // every valuble in the list is a FlSpot object and that contains a x and y value
    // convert to int, round to have 0 decimal places and return a new list of FlSpot objects
    return averages
        .map((average) => FlSpot(average.x, average.y.roundToDouble()))
        .toList();
  }

  List<FlSpot> findLowestAverage() {
    double player1Average =
        player1SetAverages.map((average) => average.y).reduce((a, b) => a + b) /
            player1SetAverages.length;
    double player2Average =
        player2SetAverages.map((average) => average.y).reduce((a, b) => a + b) /
            player2SetAverages.length;
    // every valuble in the list is a FlSpot object and that contains a x and y value
    // we want to convert the y value to an int and return a new list of FlSpot objects

    if (player1Average < player2Average) {
      return convertAveragesToInts(player1SetAverages);
    } else {
      return convertAveragesToInts(player2SetAverages);
    }
  }

  List<FlSpot> findHighestAverage() {
    double player1Average =
        player1SetAverages.map((average) => average.y).reduce((a, b) => a + b) /
            player1SetAverages.length;
    double player2Average =
        player2SetAverages.map((average) => average.y).reduce((a, b) => a + b) /
            player2SetAverages.length;
    // every valuble in the list is a FlSpot object and that contains a x and y value
    // we want to convert the y value to an int and return a new list of FlSpot objects

    if (player1Average > player2Average) {
      return convertAveragesToInts(player1SetAverages);
    } else {
      return convertAveragesToInts(player2SetAverages);
    }
  }

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: // amount of sets played
                player1SetAverages.length.toDouble() - 1.round(),
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 40,
            reservedSize: 40,
            //
          ),
        ),
      );

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: const LineTouchData(
        handleBuiltInTouches: true,
      ),
      gridData: const FlGridData(show: true),
      titlesData: titlesData1,
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: 0,
      maxX: player1SetAverages.length.toDouble() - 1.round(),
      minY: findLowestAverage().reduce((a, b) => a.y < b.y ? a : b).y,
      maxY: findHighestAverage().reduce((a, b) => a.y > b.y ? a : b).y,
      lineBarsData: [
        LineChartBarData(
          spots: player1SetAverages,
          isCurved: true,
          color: Colors.blue,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(show: true),
        ),
        LineChartBarData(
          spots: player2SetAverages,
          isCurved: true,
          color: Colors.red,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  LineChartData alternateData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: const FlGridData(show: false),
      titlesData: titlesData1,
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: 0,
      maxX: player1SetAverages.length.toDouble() - 1,
      minY: 0,
      maxY: 180,
      lineBarsData: [
        LineChartBarData(
          spots: player1SetAverages,
          isCurved: true,
          color: Colors.blue.withOpacity(0.5),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData:
              BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
        ),
        LineChartBarData(
          spots: player2SetAverages,
          isCurved: true,
          color: Colors.red.withOpacity(0.5),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData:
              BarAreaData(show: true, color: Colors.red.withOpacity(0.3)),
        ),
      ],
    );
  }
}
