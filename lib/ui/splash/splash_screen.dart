import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/ui/splash/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        alignment: Alignment.center,
          color: AppColors.primary1,
        child: Image.asset("assets/images/rent_logo.png", width: Get.width / 3),
      )
    );
  }
}
