import 'package:rent_house/base/base_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      //Get.offAll(page);
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

  void skipPage() {
    //Get.offAll();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}