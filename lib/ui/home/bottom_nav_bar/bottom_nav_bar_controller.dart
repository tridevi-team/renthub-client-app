import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/singleton/province_singleton.dart';
import 'package:rent_house/models/province/city.dart';
import 'package:rent_house/services/home_service.dart';
import 'package:rent_house/ui/home/home_screen/home_controller.dart';
import 'package:rent_house/untils/response_error_util.dart';
import 'package:rent_house/untils/toast_until.dart';

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

  Future<void> getListProvince() async {
    try {
      final response = await HomeService.fetchProvinces();
      ResponseErrorUtil.handleErrorResponse(response.statusCode, response.body);
      final decodedResponse = jsonDecode(response.body) as List<dynamic>;
      if (decodedResponse.isNotEmpty) {
        List<City> provinces = decodedResponse.map((json) => City.fromJson(json)).toList();
        ProvinceSingleton.instance.setProvinces(provinces);
      }
    } catch (e) {
      ToastUntil.toastNotification('Error fetching provinces', '$e', ToastStatus.error);
      print("Error fetching provinces: $e");
    }
  }
}