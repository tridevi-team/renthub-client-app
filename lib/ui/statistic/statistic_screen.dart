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
                              Text("Tiền phòng hàng tháng (triệu đồng)", style: ConstantFont.mediumText),
                              const SizedBox(height: 30),
                              const SizedBox(height: 250, child: BarChartWidget()),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildMinMaxWidget("Tháng ít nhất ${controller.lowestMonth}", (controller.lowestPayment * 1000000).toInt()),
                                  const SizedBox(width: 10),
                                  _buildMinMaxWidget("Tháng nhiều nhất ${controller.highestMonth}", (controller.highestPayment * 1000000).toInt()),
                                ],
                              ),
                              const SizedBox(height: 30),
                              //SizedBox(height: 200, child: PieChartWidget(staticsData: controller.statisticData,)),
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

  Widget _buildMinMaxWidget(String title, int amount) {
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
          return _buildAnalyticItem(
            serviceName: serviceKey,
            serviceFee: currentValue,
            serviceTrend: data["content"],
            color: data["color"],
          );
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
                  child: Text(controller.getServiceName(serviceName)[0], style: ConstantFont.mediumText),
                ),
                const SizedBox(width: 6),
                Text(
                  FormatUtil.formatCurrency(serviceFee),
                  style: ConstantFont.mediumText,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              serviceTrend,
              style: ConstantFont.regularText.copyWith(
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
