import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/statistical_model.dart';
import 'package:rent_house/ui/statistic/statistic_controller.dart';
import 'package:rent_house/utils/format_util.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartWidget> {
  final StatisticsController controller = Get.find();
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 2,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Tháng ${controller.statisticData.serviceCompare?.data?.last.month}",
              style: ConstantFont.mediumText.copyWith(fontSize: 16),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: controller.statisticData.serviceConsumption?.map((service) {
                List<String> serviceLabel = controller.getServiceLabelAndColor(FormatUtil.formatToSlug(service.name ?? ""));
                String colorStr = serviceLabel[1];
                int colorValue = 0xFF000000;
                if (colorStr.isNotEmpty) {
                  colorValue = int.tryParse(colorStr, radix: 16) ?? 0xFF3C56C3;
                }
                return Indicator(
                  color: Color(colorValue),
                  text: serviceLabel[0],
                  isSquare: true,
                );
              }).toList() ??
                  [],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    int total = 0;
    List<String> serviceKey = [];
    ServiceCompareData currentData = controller.statisticData.serviceCompare?.data?.last ?? ServiceCompareData();

    currentData.services?.forEach((key, value) {
      serviceKey.add(key);
      total += value;
    });

    return List<PieChartSectionData>.generate(serviceKey.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 25.0 : 12.0;
      final radius = isTouched ? 80.0 : 60.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      int color = int.tryParse(controller.getServiceLabelAndColor(serviceKey[index])[1], radix: 16) ?? 0xFF3C56C3;

      int currentValue = currentData.services?[serviceKey[index]] ?? 0;

      double percentage = (total > 0) ? (currentValue / total) * 100 : 0;

      return PieChartSectionData(
        showTitle: isTouched ? true : false,
        color: Color(color),
        value: currentValue.toDouble(),
        title: '${percentage.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: ConstantFont.boldText.copyWith(
          fontSize: fontSize,
          color: AppColors.white,
          shadows: shadows,
        ),
      );
    });
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 14,
    this.textColor,
  });

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: ConstantFont.regularText.copyWith(color: textColor),
        )
      ],
    );
  }
}
