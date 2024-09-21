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
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            AppColors.primary1,
            AppColors.primary2
          ], begin: Alignment.centerLeft, end: Alignment.centerRight)
        ),
        child: SvgPicture.asset("assets/images/img_rent_house.svg",
            color: Colors.white, width: 2 * Get.width / 3),
      )
    );
  }
}
