import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/singleton/token_singleton.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_navigation_bar.dart';
import 'package:rent_house/ui/onboarding/onboarding_screen.dart';
import 'package:rent_house/untils/shared_pref_helper.dart';

class SplashController extends BaseController {

  final bottomController = Get.put(BottomNavBarController());

  @override
  void onInit() {
    startAnimation();
    super.onInit();
  }

  Future<void> startAnimation() async {
    await initData();
    String token = SharedPrefHelper.instance.getString(ConstantString.prefToken) ?? '';
    if (token.isNotEmpty && JwtDecoder.isExpired(token)) {
      TokenSingleton.instance.setAccessToken(token);
      Get.off(() => BottomNavigationBarView());
    } else {
      TokenSingleton.instance.setAccessToken('');
      Get.off(() => const OnboardingScreen());
    }
  }

  Future<void> initData() async {
    bottomController.getListProvince();
  }
}
