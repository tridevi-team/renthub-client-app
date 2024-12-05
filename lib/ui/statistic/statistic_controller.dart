import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/statistical_model.dart';
import 'package:rent_house/services/statistic_service.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/dialog_util.dart';
import 'package:rent_house/utils/response_error_util.dart';

class StatisticsController extends BaseController with GetTickerProviderStateMixin {
  String _roomId = "";
  StatisticalModel statisticData = StatisticalModel();
  RxList<BarChartGroupData> barChartGroupData = <BarChartGroupData>[].obs;
  double highestPayment = -double.infinity;
  String highestMonth = "";
  double lowestPayment = double.infinity;
  String lowestMonth = "";
  late TabController tabController;
  RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    _roomId = UserSingleton.instance.getUser().roomId ?? "";
    tabController = TabController(length: 3, vsync: this);
    getChartByRoom(isRefresh: true);
    super.onInit();
  }

  Future<void> getChartByRoom({bool isRefresh = false}) async {
    _resetMinMaxPayment();
    try {
      if (isRefresh) {
        selectedTab.value = 0;
        viewState.value = ViewState.loading;
      } else {
        viewState.value = ViewState.init;
        DialogUtil.showLoading();
      }

      String startTime = _getStartDateByTab(selectedTab.value);
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final response = await StatisticService.getChartByRoom(_roomId, startTime, today);
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (decodedResponse["data"] == null || decodedResponse["data"] == {}) {
        viewState.value = ViewState.noData;
        return;
      }
      if (response.statusCode == 200) {
        statisticData = StatisticalModel.fromJson(decodedResponse["data"]);
        findLowestAndHighestPayment();
        barChartGroupData.value = generateBarChartData();
        viewState.value = ViewState.complete;
        DialogUtil.hideLoading();
      } else {
        ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
        DialogUtil.hideLoading();
      }
    } catch (e) {
      DialogUtil.hideLoading();
      AppUtil.printDebugMode(type: 'fetch chart', message: "$e");
      viewState.value = ViewState.notFound;
    }
  }

  List<BarChartGroupData> generateBarChartData() {
    return List.generate(statisticData.serviceCompare?.data?.length ?? 0, (index) {
      final data = statisticData.serviceCompare?.data?[index];
      final services = data?.services ?? {};
      final totalServices = services.values.fold(0, (sum, value) => sum + value) / 1000000.0;

      return BarChartGroupData(
        x: index,
        barsSpace: 8,
        barRods: <BarChartRodData>[
          BarChartRodData(
            toY: totalServices,
            color: Colors.blue,
            width: (statisticData.serviceCompare?.data?.length ?? 0) < 6 ? 30 : 20,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(2), topLeft: Radius.circular(1)),
          ),
        ],
      );
    });
  }

  String getMonthTitle(double value) {
    int index = value.toInt();
    if (index >= 0 && index < (statisticData.serviceCompare?.data?.length ?? 0)) {
      String month = statisticData.serviceCompare?.data?[index].month ?? "";
      return month.split('/')[0];
    }
    return '';
  }

  void findLowestAndHighestPayment() {
    if (statisticData.serviceCompare?.data?.isEmpty ?? true) {
      _resetMinMaxPayment();
      return;
    }

    for (var data in statisticData.serviceCompare!.data!) {
      final totalPayment = (data.services?.values.fold(0, (sum, value) => sum + value) ?? 0) / 1000000.0;
      final month = data.month ?? '';

      if (totalPayment < lowestPayment) {
        lowestPayment = totalPayment;
        lowestMonth = month;
      }
      if (totalPayment > highestPayment) {
        highestPayment = totalPayment;
        highestMonth = month;
      }
    }
  }

  void changeTab(int index) {
    if (selectedTab.value == index) return;
    selectedTab.value = index;
    getChartByRoom();
  }

  String _getStartDateByTab(int tabIndex) {
    int monthsAgo;
    switch (tabIndex) {
      case 1:
        monthsAgo = 6;
        break;
      case 2:
        monthsAgo = 12;
        break;
      default:
        monthsAgo = 3;
        break;
    }
    return _getStartDate(monthsAgo);
  }

  String _getStartDate(int monthsAgo) {
    DateTime currentDate = DateTime.now();
    int yearAdjustment = (currentDate.month - monthsAgo) < 1 ? -1 : 0;
    int adjustedMonth = (currentDate.month - monthsAgo) % 12;
    if (adjustedMonth <= 0) {
      adjustedMonth += 12;
    }

    DateTime startDate = DateTime(currentDate.year + yearAdjustment, adjustedMonth, 1);
    return DateFormat('yyyy-MM-dd').format(startDate);
  }

  Map<String, dynamic> calculateFeeChange(int lastMonthFee, int thisMonthFee) {
    if (lastMonthFee < thisMonthFee) {
      final percentageIncrease = ((thisMonthFee - lastMonthFee) / lastMonthFee) * 100;
      return {
        "color": AppColors.red,
        "content": "Tăng ${percentageIncrease.toStringAsFixed(0)}%",
      };
    } else if (lastMonthFee > thisMonthFee) {
      final percentageDecrease = ((lastMonthFee - thisMonthFee) / lastMonthFee) * 100;
      return {
        "color": AppColors.green,
        "content": "Giảm ${percentageDecrease.toStringAsFixed(0)}%",
      };
    } else {
      return {
        "color": AppColors.blue,
        "content": "Không thay đổi",
      };
    }
  }

  List<String> getServiceName(String key) {
    String label = statisticData.serviceCompare?.config?.configItems?[key]?.label ?? "";
    String color = statisticData.serviceCompare?.config?.configItems?[key]?.color?.replaceFirst("#", "0xFF") ?? "";
    return [label, color];
  }

  void _resetMinMaxPayment() {
    highestPayment = -double.infinity;
    highestMonth = "";
    lowestPayment = double.infinity;
    lowestMonth = "";
  }
}
