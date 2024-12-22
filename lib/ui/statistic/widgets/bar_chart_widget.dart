import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/statistic/statistic_controller.dart';
import 'package:rent_house/utils/format_util.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final StatisticsController controller = Get.find();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tiền phòng hàng tháng (triệu đồng)", style: ConstantFont.mediumText),
          const SizedBox(height: 30),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData()),
                minY: controller.barChartGroupData.isNotEmpty ? 0 : 0,
                maxY: controller.highestPayment,
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
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMinMaxWidget("Tháng ít nhất", controller.lowestMonth, (controller.lowestPayment * 1000000).toInt()),
              const SizedBox(width: 10),
              _buildMinMaxWidget("Tháng nhiều nhất", controller.highestMonth, (controller.highestPayment * 1000000).toInt()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMinMaxWidget(String title, String content, int amount) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: const Border.fromBorderSide(
            BorderSide(width: 1, color: AppColors.neutralE9e9e9),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: ConstantFont.mediumText),
            const SizedBox(height: 4),
            Text(content, style: ConstantFont.regularText),
            const SizedBox(height: 10),
            Text(
              FormatUtil.formatCurrency(amount),
              style: ConstantFont.regularText.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

}
