import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';

class CustomerContractController extends BaseController with GetTickerProviderStateMixin {

  final List<Tab> contractTabs = <Tab>[
    const Tab(text: 'Chờ phê duyệt'),
    const Tab(text: 'Đã phê duyệt'),
    const Tab(text: 'Đã từ chối'),
  ];

  late TabController contractTabController;
  int currentContractTabIndex = 0;


  @override
  void onInit() {
    super.onInit();
    contractTabController = TabController(length: contractTabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });

  }

  void changeTab(int tabIndex) {
    contractTabController.animateTo(tabIndex, duration: const Duration(milliseconds: 0));
    currentContractTabIndex = tabIndex;
    onChangeContractHistoryTab();
  }

  Future<void> onChangeContractHistoryTab() async {

  }
}