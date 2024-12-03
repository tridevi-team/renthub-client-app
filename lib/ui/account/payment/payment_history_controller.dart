import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/bill_model.dart';
import 'package:rent_house/services/bill_service.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/response_error_util.dart';

class PaymentHistoryController extends BaseController with GetTickerProviderStateMixin {
  final List<Widget> issueTabs = <Widget>[
    const Tab(text: 'Chờ thanh toán'),
    const Tab(text: 'Đã thanh toán'),
    const SizedBox(width: 80, child: Tab(text: 'Đang nợ')),
    const SizedBox(width: 80, child: Tab(text: 'Quá hạn')),
    const SizedBox(width: 80, child: Tab(text: 'Đã hủy')),
  ];

  List<String> statusList = ["UNPAID", "PAID", "IN_DEBT", "OVERDUE", "CANCELLED"];

  late TabController paymentTabController;
  RefreshController paymentRefreshCtrl = RefreshController();
  int currentPaymentTabIndex = 0;
  int prevPaymentTabIndex = 0;
  int currentPage = 1;
  String? _houseId;
  String? _roomId;
  List<BillModel> bills = [];

  @override
  void onInit() {
    super.onInit();
    _houseId = UserSingleton.instance.getUser().houseId ?? "";
    _roomId = UserSingleton.instance.getUser().roomId ?? "";
    paymentTabController = TabController(length: issueTabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    fetchPaymentHistoryByStatus(isRefresh: true);
  }

  void changeTab(int tabIndex) {
    if (tabIndex != currentPaymentTabIndex && viewState.value != ViewState.loading) {
      prevPaymentTabIndex = currentPaymentTabIndex;
      currentPaymentTabIndex = tabIndex;
      paymentTabController.animateTo(tabIndex, duration: const Duration(milliseconds: 0));
      fetchPaymentHistoryByStatus(isRefresh: true);
    }
  }

  Future<void> fetchPaymentHistoryByStatus({bool isRefresh = false}) async {
    String sort = '''sort[]={
      "field": "bills.created_at",
      "direction": "desc"
    }''';

    String filters = '''filter[]={
      "field": "bills.room_id",
      "operator": "eq",
      "value": "$_roomId"
    }&filter[]={
      "field": "bills.status",
      "operator": "eq",
      "value": "${statusList[currentPaymentTabIndex]}"
    }&''';

    try {
      viewState.value = ViewState.init;
      if (isRefresh) {
        currentPage = 1;
        bills.clear();
        viewState.value = ViewState.loading;
      } else {
        currentPage++;
      }
      final response = await BillService.fetchBillList(
          sort: sort, filters: filters, page: currentPage, houseId: "$_houseId");
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

      if (decodedResponse['data'] == null ||
          decodedResponse['data']['results'] == null ||
          (decodedResponse['data']['results'] is List &&
              (decodedResponse['data']['results'] as List).isEmpty)) {
        paymentRefreshCtrl.loadNoData();
        if (bills.isEmpty) {
          viewState.value = ViewState.noData;
        } else {
          viewState.value = ViewState.complete;
        }
        return;
      }

      if (response.statusCode == 200) {
        final newBills =
            (decodedResponse['data']['results'] as List).map((i) => BillModel.fromJson(i)).toList();

        if (isRefresh) {
          bills = newBills;
        } else {
          bills.addAll(newBills);
        }
        paymentRefreshCtrl.loadComplete();
        viewState.value = ViewState.complete;
      } else {
        ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
        viewState.value = ViewState.notFound;
      }
    } catch (e) {
      viewState.value = ViewState.notFound;
      AppUtil.printDebugMode(type: 'fetch bill', message: '$e');
    }
  }
}
