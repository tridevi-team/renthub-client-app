import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/account/customer/customer_screen.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:rent_house/ui/home/home_screen/home_screen.dart';
import 'package:rent_house/ui/notification/notification_controller.dart';

class BottomNavigationBarView extends StatelessWidget {
  BottomNavigationBarView({super.key});

  //controller
  final bottomNavController = Get.put(BottomNavBarController());
  final notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: bottomNavController.pageController,
        onPageChanged: (value) {
          bottomNavController.selectedIndex.value = value;
        },
        children: [
          HomeScreen(),
          HomeScreen(),
          HomeScreen(),
          CustomerScreen(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            selectedFontSize: 0,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(icon: SvgPicture.asset(AssetSvg.iconHome), label: 'Gợi ý'),
              BottomNavigationBarItem(icon: SvgPicture.asset(AssetSvg.iconChart), label: 'Thống kê'),
              BottomNavigationBarItem(icon: SvgPicture.asset(AssetSvg.iconChat), label: 'Tin nhắn'),
              BottomNavigationBarItem(icon: SvgPicture.asset(AssetSvg.iconPerson), label: 'Tôi'),
            ],
            currentIndex: bottomNavController.selectedIndex.value,
            selectedItemColor: AppColors.primary1,
            selectedIconTheme: const IconThemeData(),
            onTap: bottomNavController.onItemTapped,
            selectedLabelStyle: ConstantFont.mediumText.copyWith(fontSize: 10),
            unselectedLabelStyle: ConstantFont.mediumText.copyWith(fontSize: 10),
            backgroundColor: AppColors.white,
          )
      ),
    );
  }
}
