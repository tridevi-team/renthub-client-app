import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/statistic/statistic_controller.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final StatisticsController controller = Get.find();

    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData()),
        minY: 0,
        maxY: controller.highestPayment + 0.5,
        barGroups: controller.barChartGroupData,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 0.5,
              getTitlesWidget: (value, meta) => Text(
                value.toStringAsFixed(1),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  controller.getMonthTitle(value),
                  style: const TextStyle(fontSize: 12),
                );
              },
              interval: 1,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: true, border: const Border(bottom: BorderSide(width: 1), left: BorderSide(width: 1))),
        gridData: const FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: false, horizontalInterval: 0.5),
      ),
    );
  }
}
