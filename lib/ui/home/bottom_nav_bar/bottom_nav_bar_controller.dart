import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/ui/home/home_screen/home_controller.dart';

class BottomNavBarController extends FullLifeCycleController {
  late PageController pageController;
  RxInt selectedIndex = 0.obs;
  final homeController = Get.put(HomeController());

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: selectedIndex.value);
  }

  void onItemTapped(int value) => selectedIndex.value = value;
}