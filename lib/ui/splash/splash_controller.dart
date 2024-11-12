import 'dart:convert';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/singleton/province_singleton.dart';
import 'package:rent_house/constants/singleton/token_singleton.dart';
import 'package:rent_house/models/province/city.dart';
import 'package:rent_house/services/home_service.dart';
import 'package:rent_house/ui/account/customer/customer_controller.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_navigation_bar.dart';
import 'package:rent_house/ui/onboarding/onboarding_screen.dart';
import 'package:rent_house/untils/app_util.dart';
import 'package:rent_house/untils/response_error_util.dart';
import 'package:rent_house/untils/shared_pref_helper.dart';
import 'package:rent_house/untils/toast_until.dart';

class SplashController extends BaseController {

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _fetchProvinces();

      Get.lazyPut(() => BottomNavBarController());
      Get.lazyPut(() => CustomerController());

      String token = SharedPrefHelper.instance.getString(ConstantString.prefAccessToken) ?? '';

      if (token.isNotEmpty && !JwtDecoder.isExpired(token)) {
        TokenSingleton.instance.setAccessToken(token);
        await _initializeUserData();
        Get.off(() => BottomNavigationBarView());
      } else {
        await AppUtil.logout();
        Get.off(() => const OnboardingScreen());
      }
    } catch (e) {
      ToastUntil.toastNotification(description: "Error during initialization: $e", status: ToastStatus.error);
    }
  }

  Future<void> _initializeUserData() async {
    try {
      final CustomerController customerController = Get.find();
      final BottomNavBarController bottomNavController = Get.find();

      await customerController.getCustomerInfo();
      bottomNavController.checkIsLogin();
    } catch (e) {
      ToastUntil.toastNotification(description: "Error initializing user data: $e", status: ToastStatus.error);
    }
  }

  Future<void> _fetchProvinces() async {
    try {
      final response = await HomeService.fetchProvinces();

      final message = ResponseErrorUtil.handleErrorResponse(response.statusCode, response.body);
      if (message?.isNotEmpty ?? false) {
        ToastUntil.toastNotification(description: message!, status: ToastStatus.error);
        return;
      }

      final List<dynamic> decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      if (decodedResponse.isNotEmpty) {
        final provinces = decodedResponse.map((json) => City.fromJson(json)).toList();
        ProvinceSingleton.instance.setProvinces(provinces);
      }
    } catch (e) {
      ToastUntil.toastNotification(description: "Error fetching provinces: $e", status: ToastStatus.error);
    }
  }
}
