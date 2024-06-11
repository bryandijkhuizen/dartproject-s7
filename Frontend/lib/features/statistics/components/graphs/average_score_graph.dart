import 'package:darts_application/features/statistics/stores/statistics_store.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AverageScoreGraph extends StatelessWidget {
  final bool isShowingMainData;
  final List<FlSpot> player1AverageScores;
  final List<FlSpot> player2AverageScores;

  AverageScoreGraph({
    super.key,
    required this.isShowingMainData,
    required this.player1AverageScores,
    required this.player2AverageScores,
  });

  final StatisticsStore _statisticsStore = StatisticsStore(
      Supabase.instance.client, UserStore(Supabase.instance.client));

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? mainData() : LineChartData(),
      duration: const Duration(milliseconds: 250),
    );
  }

  FlTitlesData get titlesData1 => const FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, interval: 5),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
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
      maxX: player1AverageScores.length.toDouble() - 1.round(),
      minY: _statisticsStore
              .findLowestAverage(player1AverageScores, player2AverageScores)
              .reduce((a, b) => a.y < b.y ? a : b)
              .y -
          10,
      maxY: _statisticsStore
          .findHighestAverage(player1AverageScores, player2AverageScores)
          .reduce((a, b) => a.y > b.y ? a : b)
          .y,
      lineBarsData: [
        LineChartBarData(
          spots: player1AverageScores,
          isCurved: true,
          color: Colors.blue,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(show: true),
        ),
        LineChartBarData(
          spots: player2AverageScores,
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
}
