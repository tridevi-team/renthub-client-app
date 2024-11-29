import 'dart:convert';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/singleton/province_singleton.dart';
import 'package:rent_house/constants/singleton/token_singleton.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/province/city.dart';
import 'package:rent_house/models/user_model.dart';
import 'package:rent_house/services/customer_service.dart';
import 'package:rent_house/services/home_service.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_navigation_bar.dart';
import 'package:rent_house/ui/onboarding/onboarding_screen.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/shared_pref_helper.dart';
import 'package:rent_house/utils/toast_until.dart';

class SplashController extends BaseController {

  bool isCustomer = false;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _fetchProvinces();
      if (ProvinceSingleton.instance.isProvincesEmpty) {
        ToastUntil.toastNotification(description: ConstantString.restartAppMessage, status: ToastStatus.error);
        return;
      }
      String token = SharedPrefHelper.instance.getString(ConstantString.prefAccessToken) ?? '';

      if (token.isNotEmpty && !JwtDecoder.isExpired(token)) {
        TokenSingleton.instance.setAccessToken(token);
        await _initializeUserData();
        Get.offAll(() => BottomNavigationBarView(isCustomer: isCustomer));
      } else {
        await AppUtil.logout();
        bool isFirstLogin = SharedPrefHelper.instance.getInt(ConstantString.prefFirstLogin) != 1;
        if (isFirstLogin) {
          SharedPrefHelper.instance.saveInt(ConstantString.prefFirstLogin, 1);
          Get.off(() => const OnboardingScreen());
          return;
        }
        ToastUntil.toastNotification(description: ConstantString.sessionTimeoutMessage, status: ToastStatus.error);
        Get.off(() => BottomNavigationBarView());
      }
    } catch (e) {
      ToastUntil.toastNotification(description: "Error during initialization: $e", status: ToastStatus.error);
    }
  }

  Future<void> _initializeUserData() async {
    try {
      isCustomer = await fetchCustomerInfo();
    } catch (e) {
      ToastUntil.toastNotification(description: "Error initializing user data: $e", status: ToastStatus.error);
    }
  }

  Future<bool> fetchCustomerInfo() async {
    try {
      final response = await CustomerService.getCustomerInfo();
      if (response.statusCode != 200) {
        ToastUntil.toastNotification(
          description: ConstantString.accountNotFoundMessage,
          status: ToastStatus.error,
        );
        UserSingleton.instance.resetUser();
        AppUtil.signOutWithGoogle();
        return false;
      }
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      UserModel userModel = UserModel.fromJson(decodedResponse['data']);
      UserSingleton.instance.setUser(userModel);
      return true;
    } catch (e) {
      ToastUntil.toastNotification(description: ConstantString.tryAgainMessage, status: ToastStatus.error);
      AppUtil.printDebugMode(type: 'Error fetchCustomerInfo', message: '$e');
      return false;
    }
  }

  Future<void> _fetchProvinces() async {
    try {
      final response = await HomeService.fetchProvinces();

      if ([500, 408, 502].contains(response.statusCode)) {
        ToastUntil.toastNotification(description: response.body, status: ToastStatus.error);
      } else if (response.statusCode >= 300) {
        ToastUntil.toastNotification(description: ConstantString.restartAppMessage, status: ToastStatus.error);
        return;
      }

      final List<dynamic> decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      if (decodedResponse.isNotEmpty) {
        final provinces = decodedResponse.map((json) => City.fromJson(json)).toList();
        ProvinceSingleton.instance.setProvinces(provinces);
      }
    } catch (e) {
      ToastUntil.toastNotification(description: ConstantString.restartAppMessage, status: ToastStatus.error);
    }
  }
}
