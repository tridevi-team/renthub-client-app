import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/issue_model.dart';
import 'package:rent_house/services/issue_service.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/response_error_util.dart';

class IssueTrackingController extends BaseController with GetTickerProviderStateMixin {
  final List<Tab> issueTabs = <Tab>[
    const Tab(text: 'Chờ xử lý'),
    const Tab(text: 'Đang xử lý'),
    const Tab(text: 'Đã xử lý'),
    const Tab(text: 'Đã đóng'),
  ];

  List<String> statusList = ["OPEN", "IN_PROGRESS", "DONE", "CLOSED"];

  late TabController issueTabController;
  RefreshController issueRefreshCtrl = RefreshController();
  int currentIssueTabIndex = 0;
  int prevIssueTabIndex = 0;
  String _houseId = "";
  String _roomId = "";
  int currentPage = 1;
  List<IssueModel> issueList = [];

  @override
  void onInit() {
    super.onInit();
    _houseId = UserSingleton.instance.getUser().houseId ?? "";
    _roomId = UserSingleton.instance.getUser().roomId ?? "";
    getHistoryOfIssueTab(isRefresh: true);
    issueTabController = TabController(length: issueTabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void changeTab(int tabIndex) {
    if (tabIndex != currentIssueTabIndex && viewState.value != ViewState.loading) {
      prevIssueTabIndex = currentIssueTabIndex;
      currentIssueTabIndex = tabIndex;
      issueTabController.animateTo(tabIndex, duration: const Duration(milliseconds: 0));
      getHistoryOfIssueTab(isRefresh: true);
    }
  }

  Future<void> getHistoryOfIssueTab({bool isRefresh = false}) async {
    viewState.value = ViewState.init;
    if (isRefresh) {
      currentPage = 1;
      issueList.clear();
      viewState.value = ViewState.loading;
    } else {
      currentPage++;
    }

    String currentStatus = statusList[currentIssueTabIndex];
    String sort = '''sort[]={
     "field": "issues.createdAt",
     "direction": "desc"
    }''';

    String filters = '''filter[]={
     "field": "issues.status",
     "operator": "eq",
     "value": "$currentStatus"
    }&filter[]={
     "field": "rooms.id",
     "operator": "eq",
     "value": "$_roomId"
    }&''';

    try {
      final response = await IssueService.fetchAllIssues(
          sort: sort, filters: filters, page: currentPage, houseId: _houseId);

      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

      if (decodedResponse['data'] == null ||
          decodedResponse['data']['results'] == null ||
          (decodedResponse['data']['results'] is List &&
              (decodedResponse['data']['results'] as List).isEmpty)) {
        issueRefreshCtrl.loadNoData();
        if (issueList.isEmpty) {
          viewState.value = ViewState.noData;
        } else {
          viewState.value = ViewState.complete;
        }
        return;
      }

      if (response.statusCode == 200) {
        final newIssues = (decodedResponse['data']['results'] as List)
            .map((i) => IssueModel.fromJson(i))
            .toList();

        if (isRefresh) {
          issueList = newIssues;
        } else {
          issueList.addAll(newIssues);
        }
        issueRefreshCtrl.loadComplete();
        viewState.value = ViewState.complete;
      } else {
        ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
        viewState.value = ViewState.notFound;
      }
    } catch (e) {
      viewState.value = ViewState.notFound;
      AppUtil.printDebugMode(type: 'fetch issue', message: '$e');
    }
  }

  String getStatus() {
    if (currentIssueTabIndex == 1) return "Đang xử lý";
    if (currentIssueTabIndex == 2) return "Đã xử lý";
    if (currentIssueTabIndex == 3) return "Đã đóng";
    return "Chờ xử lý";
  }
}
