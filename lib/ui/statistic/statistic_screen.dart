import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/statistic/widgets/line_chart_widget.dart';
import 'package:rent_house/ui/statistic/widgets/pie_chart_widget.dart';
import 'package:rent_house/untils/format_util.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tổng quan', style: ConstantFont.semiBoldText.copyWith(fontSize: 20)),
                const SizedBox(height: 20),
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.primary400),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Hóa đơn", style: ConstantFont.mediumText.copyWith(fontSize: 18, color: AppColors.white)),
                          const SizedBox(width: 10),
                          Text(FormatUtil.formatCurrency(2800000), style: ConstantFont.mediumText.copyWith(fontSize: 18, color: AppColors.white)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('Sep 1 - Sep 20, 2024', style: ConstantFont.mediumText.copyWith(color: AppColors.white))
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text('Tiền thuê', style: ConstantFont.semiBoldText.copyWith(fontSize: 20)),
                const SizedBox(height: 20),
                const LineChartWidget(),
                const SizedBox(height: 20),
                Text('Dịch vụ', style: ConstantFont.semiBoldText.copyWith(fontSize: 20)),
                const SizedBox(height: 20),
                const PieChartWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
