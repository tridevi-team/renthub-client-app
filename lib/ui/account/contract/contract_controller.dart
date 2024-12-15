import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/contract_model.dart';
import 'package:rent_house/services/contract_service.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/response_error_util.dart';

class CustomerContractController extends BaseController with GetTickerProviderStateMixin {
  final List<Widget> contractTabs = <Widget>[
    const Tab(text: 'Chờ phê duyệt'),
    const SizedBox(width: 80, child: Tab(text: 'Đã ký')),
    const Tab(text: 'Đã từ chối'),
  ];

  late TabController contractTabController;
  RefreshController contractRefreshCtrl = RefreshController();
  int currentContractTabIndex = 0;
  int prevContractTabIndex = 0;
  String _roomId = "";

  List<ContractModel> contracts = [];


 @override
  void onInit() {
    super.onInit();
    _roomId = UserSingleton.instance.getUser().roomId ?? "";
    contractTabController = TabController(length: contractTabs.length, vsync: this);
    getContractHistoryTab(isRefresh: true);
  }

  void changeTab(int tabIndex) {
    if (tabIndex != currentContractTabIndex) {
      prevContractTabIndex = currentContractTabIndex;
      currentContractTabIndex = tabIndex;
      contractTabController.animateTo(tabIndex, duration: const Duration(milliseconds: 0));
      getContractHistoryTab(isRefresh: true);
    }
  }

  Future<void> getContractHistoryTab({bool isRefresh = false}) async {
    viewState.value = ViewState.init;
    if (isRefresh) {
      contracts.clear();
      viewState.value = ViewState.loading;
    }
    try {
      viewState.value = ViewState.loading;
      final response = await ContractService.getAllContractInRoom(roomId: _roomId);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        if (decodedResponse["data"]["results"] != null && decodedResponse["data"]["results"] is List) {
          List<ContractModel> filteredContracts = (decodedResponse["data"]["results"] as List).map((contract) => ContractModel.fromJson(contract)).toList();

          switch (currentContractTabIndex) {
            case 0:
              filteredContracts = getContractsByStatus(filteredContracts, 'PENDING');
              break;
            case 1:
              filteredContracts = getContractsByStatus(filteredContracts, 'APPROVED');
              break;
            case 2:
              filteredContracts = getContractsByStatus(filteredContracts, 'REJECTED');
              break;
            default:
              filteredContracts = [];
          }

          contracts = filteredContracts;
          if (contracts.isEmpty) {
            viewState.value = ViewState.noData;
            return;
          } else {
            viewState.value = ViewState.complete;
            return;
          }
        }

        ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      }
    } catch (e) {
      viewState.value = ViewState.notFound;
      AppUtil.printDebugMode(type: 'Contract Error', message: "$e");
    }
  }

  List<ContractModel> getContractsByStatus(List<ContractModel> contractsList, String status) {
    return contractsList.where((contract) => contract.approvalStatus == status).toList();
  }

  String getStatusName(String contractStatus) {
    if (contractStatus == 'PENDING') return "Chờ phê duyệt";
    if (contractStatus == 'APPROVED') return "Đã ký";
    if (contractStatus == 'REJECTED') return "Đã từ chối";
    return "Chờ phê duyệt";
  }

}
