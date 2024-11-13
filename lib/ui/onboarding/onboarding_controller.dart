import 'package:rent_house/base/base_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/singleton/province_singleton.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_navigation_bar.dart';
import 'package:rent_house/ui/signin/signin_screen.dart';
import 'package:rent_house/untils/toast_until.dart';

class OnboardingController extends BaseController {
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  void updatePageIndicator(index) => currentPageIndex.value = index;

  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  void nextPage() {
    if (currentPageIndex.value == 2) {
      moveToPage();
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  void previousPage() {
    if (currentPageIndex.value != 0) {
      int page = currentPageIndex.value - 1;
      pageController.jumpToPage(page);
    }
  }

  void skipPage() => moveToPage();

  void moveToPage() {
    if (!ProvinceSingleton.instance.isProvincesEmpty) {
      Get.off(() => BottomNavigationBarView());
    } else {
      ToastUntil.toastNotification(description: "Có lỗi xảy ra. Vui lòng khởi động lại ứng dụng.", status: ToastStatus.error);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}