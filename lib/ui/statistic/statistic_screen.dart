import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/models/statistical_model.dart';
import 'package:rent_house/ui/search/search_widget/not_found_widget.dart';
import 'package:rent_house/ui/statistic/statistic_controller.dart';
import 'package:rent_house/ui/statistic/widgets/bar_chart_widget.dart';
import 'package:rent_house/ui/statistic/widgets/pie_chart_widget.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/widgets/errors/network_error_widget.dart';
import 'package:rent_house/widgets/loading/loading_widget.dart';
import 'package:rent_house/widgets/refresh/smart_refresh.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  late final StatisticsController controller;

  @override
  void initState() {
    controller = Get.put(StatisticsController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Obx(
          () {
            if (controller.viewState.value == ViewState.loading) {
              return const LoadingWidget();
            } else if (controller.viewState.value == ViewState.complete || controller.viewState.value == ViewState.init || controller.viewState.value == ViewState.noData) {
              return SmartRefreshWidget(
                scrollController: ScrollController(),
                controller: RefreshController(),
                enablePullUp: false,
                onRefresh: () {
                  controller.getChartByRoom(isRefresh: true);
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    child: controller.viewState.value == ViewState.noData
                        ? SizedBox(height: Get.height - 100, child: const NotFoundWidget(title: ConstantString.messageNoData, content: ConstantString.messageContentNoData))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tổng quan', style: ConstantFont.semiBoldText.copyWith(fontSize: 20)),
                              const SizedBox(height: 10),
                              _buildAnalyticsView(),
                              const SizedBox(height: 20),
                              Text('Thống kê', style: ConstantFont.semiBoldText.copyWith(fontSize: 20)),
                              const SizedBox(height: 20),
                              // Toggle Buttons
                              Obx(
                                () => SizedBox(
                                  child: ToggleButtons(
                                    constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 36) / 3, minHeight: 40),
                                    borderRadius: BorderRadius.circular(8),
                                    isSelected: [
                                      controller.selectedTab.value == 0,
                                      controller.selectedTab.value == 1,
                                      controller.selectedTab.value == 2,
                                    ],
                                    onPressed: (index) {
                                      controller.changeTab(index);
                                    },
                                    fillColor: Colors.blue,
                                    selectedColor: AppColors.white,
                                    textStyle: ConstantFont.mediumText,
                                    children: const [
                                      Text('3 tháng'),
                                      Text('6 tháng'),
                                      Text('12 tháng'),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              const BarChartWidget(),
                              const SizedBox(height: 30),
                              const PieChartWidget(),
                              const SizedBox(height: 30),
                            ],
                          ),
                  ),
                ),
              );
            } else {
              return NetworkErrorWidget(
                viewState: controller.viewState.value,
                onRefresh: () {
                  controller.getChartByRoom(isRefresh: true);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildAnalyticsView() {
    List<ServiceCompareData> serviceData = controller.statisticData.serviceCompare?.data ?? [];

    if (serviceData.isEmpty || serviceData[0].services == null) {
      return const SizedBox();
    }

    ServiceCompareData currentData = serviceData.last;
    ServiceCompareData? previousData = serviceData.length > 1 ? serviceData[serviceData.length - 2] : null;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        String serviceKey = currentData.services!.keys.elementAt(index);
        int currentValue = currentData.services![serviceKey]!;

        if (previousData != null) {
          int previousValue = previousData.services?[serviceKey] ?? 0;
          Map<String, dynamic> data = controller.calculateFeeChange(previousValue, currentValue);
          return _buildAnalyticItem(serviceName: serviceKey, serviceFee: currentValue, serviceTrend: data["content"], color: data["color"], prevServiceFee: previousValue);
        }

        return _buildAnalyticItem(
          serviceName: serviceKey,
          serviceFee: currentValue,
        );
      },
      itemCount: currentData.services!.keys.length,
    );
  }

  Widget _buildAnalyticItem({
    required String serviceName,
    String serviceTrend = "",
    Color? color,
    required int serviceFee,
    int? prevServiceFee,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.neutralFAFAFA,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(controller.getServiceLabelAndColor(serviceName)[0], style: ConstantFont.mediumText),
                ),
                if (prevServiceFee != null && serviceTrend != "Không thay đổi") ...[
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: RichText(
                          text: TextSpan(
                            text: "Tháng trước: ",
                            style: ConstantFont.mediumText,
                            children: [
                              TextSpan(
                                text: FormatUtil.formatCurrency(prevServiceFee),
                                style: ConstantFont.mediumText.copyWith(color: color),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    serviceTrend,
                    style: ConstantFont.regularText.copyWith(
                      fontSize: 12,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  FormatUtil.formatCurrency(serviceFee),
                  style: ConstantFont.mediumText,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
