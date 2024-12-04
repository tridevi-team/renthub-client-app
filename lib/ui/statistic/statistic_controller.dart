import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/statistical_model.dart';
import 'package:rent_house/services/statistic_service.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/dialog_util.dart';
import 'package:rent_house/utils/response_error_util.dart';

class StatisticsController extends BaseController with GetTickerProviderStateMixin {
  String _roomId = "";
  List<StatisticalModel> statisticData = [];
  RxList<BarChartGroupData> barChartGroupData = <BarChartGroupData>[].obs;
  double highestPayment = 0;
  String highestMonth = "";
  double lowestPayment = 1000;
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
      DialogUtil.hideLoading();

      if (response.statusCode == 200) {
        statisticData.assignAll((decodedResponse["data"] as List)
            .map((statistic) => StatisticalModel.fromJson(statistic))
            .toList());
        barChartGroupData.value = generateBarChartData();
        findLowestAndHighestPayment();
        viewState.value = ViewState.complete;
      } else {
        ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      }
    } catch (e) {
      DialogUtil.hideLoading();
      AppUtil.printDebugMode(type: 'fetch chart', message: "$e");
      viewState.value = ViewState.notFound;
    }
  }

  List<BarChartGroupData> generateBarChartData() {
    return List.generate(statisticData.length, (index) {
      final data = statisticData[index];
      return BarChartGroupData(
        x: index,
        barsSpace: 8,
        barRods: <BarChartRodData>[
          BarChartRodData(
            toY: (data.totalPrice ?? 0) / 1000000.0,
            color: Colors.blue,
            width: statisticData.length < 6 ? 30 : 20,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(2), topLeft: Radius.circular(1)),
          ),
        ],
      );
    });
  }

  String getMonthTitle(double value) {
    int index = value.toInt();
    if (index >= 0 && index < statisticData.length) {
      String month = statisticData[index].month ?? "";
      return month.split('/')[0];
    }
    return '';
  }

  void findLowestAndHighestPayment() {
    if (statisticData.isEmpty) {
      highestPayment = 0;
      lowestPayment = 0;
      lowestMonth = '';
      highestMonth = '';
      return;
    }

    highestPayment = 0;
    lowestPayment = double.infinity;
    lowestMonth = '';
    highestMonth = '';

    for (var data in statisticData) {
      final payment = (data.totalPrice ?? 0) / 1000000.0;
      final month = data.month ?? '';
      if (payment < lowestPayment) {
        lowestPayment = payment;
        lowestMonth = month;
      }
      if (payment > highestPayment) {
        highestPayment = payment;
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
}
