import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/ui/onboarding/onboarding_screen.dart';

class SplashController extends BaseController{

  @override
  void onInit() {
    startAnimation();
    super.onInit();
  }

  Future<void> startAnimation() async{
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const OnboardingScreen());
  }
}