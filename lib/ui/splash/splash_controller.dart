import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/access_token_singleton.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_navigation_bar.dart';
import 'package:rent_house/ui/onboarding/onboarding_screen.dart';
import 'package:rent_house/untils/shared_pref_helper.dart';

class SplashController extends BaseController {
  @override
  void onInit() {
    startAnimation();
    super.onInit();
  }

  Future<void> startAnimation() async {
    await Future.delayed(const Duration(seconds: 2));
    
    String token = SharedPrefHelper.instance.getString(ConstantString.prefToken) ?? '';
    if (token.isNotEmpty && JwtDecoder.isExpired(token)) {
      AccessTokenSingleton.instance.setToken(token);
      Get.off(() => BottomNavigationBarView());
    } else {
      Get.off(() => const OnboardingScreen());
    }
  }
}
