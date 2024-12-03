import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/ui/statistic/statistic_controller.dart';
import 'package:rent_house/ui/statistic/widgets/line_chart_widget.dart';
import 'package:rent_house/ui/statistic/widgets/pie_chart_widget.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/widgets/errors/network_error_widget.dart';
import 'package:rent_house/widgets/loading/loading_widget.dart';
import 'package:rent_house/widgets/refresh/smart_refresh.dart';

class StatisticScreen extends StatefulWidget {
  StatisticScreen({super.key});

  late StatisticsController controller;

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  @override
  void initState() {
    widget.controller = Get.put(StatisticsController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Obx(
          () {
            if (widget.controller.viewState.value == ViewState.loading) {
              return const LoadingWidget();
            } else if (widget.controller.viewState.value == ViewState.complete ||
                widget.controller.viewState.value == ViewState.init ||
                widget.controller.viewState.value == ViewState.noData) {
              return SmartRefreshWidget(
                scrollController: ScrollController(),
                controller: RefreshController(),
                enablePullUp: false,
                onRefresh: widget.controller.getChartByRoom,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tổng quan', style: ConstantFont.semiBoldText.copyWith(fontSize: 20)),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.primary400),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Hóa đơn",
                                        style: ConstantFont.mediumText
                                            .copyWith(fontSize: 18, color: AppColors.white)),
                                    const SizedBox(width: 10),
                                    Text(FormatUtil.formatCurrency(2800000),
                                        style: ConstantFont.mediumText
                                            .copyWith(fontSize: 18, color: AppColors.white)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text('Sep 1 - Sep 20, 2024',
                                    style: ConstantFont.mediumText.copyWith(color: AppColors.white))
                              ],
                            ),
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
              );
            }
            return NetworkErrorWidget(viewState: widget.controller.viewState.value);
          },
        ),
      ),
    );
  }
}
