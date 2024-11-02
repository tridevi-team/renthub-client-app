import 'dart:convert';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/singleton/province_singleton.dart';
import 'package:rent_house/constants/singleton/token_singleton.dart';
import 'package:rent_house/models/province/city.dart';
import 'package:rent_house/services/home_service.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_navigation_bar.dart';
import 'package:rent_house/ui/onboarding/onboarding_screen.dart';
import 'package:rent_house/untils/response_error_util.dart';
import 'package:rent_house/untils/shared_pref_helper.dart';
import 'package:rent_house/untils/toast_until.dart';

class SplashController extends BaseController {

  String token = '';
  @override
  void onInit() {
    startAnimation();
    super.onInit();
  }

  Future<void> startAnimation() async {
    await initData();
    await Future.delayed(const Duration(seconds: 1));
    token = SharedPrefHelper.instance.getString(ConstantString.prefAccessToken) ?? '';
    if (token.isNotEmpty && !JwtDecoder.isExpired(token)) {
      TokenSingleton.instance.setAccessToken(token);
      Get.off(() => BottomNavigationBarView());
    } else {
      TokenSingleton.instance.setAccessToken('');
      SharedPrefHelper.instance.removeString(ConstantString.prefAccessToken);
      Get.off(() => const OnboardingScreen());
    }
  }

  Future<void> initData() async{
    await getListProvince();
    if (token.isNotEmpty) {
      //fetch info customer
    }
  }

  Future<void> getListProvince() async {
    try {
      final response = await HomeService.fetchProvinces();
      String? message = ResponseErrorUtil.handleErrorResponse(response.statusCode, response.body);
      if (message?.isNotEmpty ?? false) {
        ToastUntil.toastNotification(description: '$message', status: ToastStatus.error);
        return;
      }
      final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      if (decodedResponse.isNotEmpty) {
        final provinces = decodedResponse.map((json) => City.fromJson(json)).toList();
        ProvinceSingleton.instance.setProvinces(provinces);
      }
    } catch (e) {
      ToastUntil.toastNotification(description: e.toString(), status: ToastStatus.error);
      print("Error fetching provinces: $e");
    }
  }
}
