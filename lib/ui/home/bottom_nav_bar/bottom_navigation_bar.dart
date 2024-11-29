import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/account/customer/customer_screen.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:rent_house/ui/home/home_screen/home_screen.dart';
import 'package:rent_house/ui/house_renter/house_renter_screen.dart';
import 'package:rent_house/ui/notification/notification_controller.dart';
import 'package:rent_house/ui/notification/notification_screen.dart';
import 'package:rent_house/ui/statistic/statistic_screen.dart';

class BottomNavigationBarView extends StatelessWidget {
  BottomNavigationBarView({super.key, this.isCustomer = false});

  final bool isCustomer;

  //controller
  final bottomNavController = Get.put(BottomNavBarController());

  @override
  Widget build(BuildContext context) {
    bottomNavController.setCustomerLoginStatus(isCustomer);
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          bool value = await bottomNavController.onWillPop();
          if (value) {
            Get.back();
          }
        },
        child: Scaffold(
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: bottomNavController.pageController,
              onPageChanged: (value) {
                bottomNavController.selectedIndex.value = value;
              },
              children: [
                bottomNavController.isLogin.value ? HouseRenterScreen() : HomeScreen(),
                const StatisticScreen(),
                NotificationScreen(),
                CustomerScreen(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedFontSize: 0,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(AssetSvg.iconHome), label: 'Trang chủ'),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(AssetSvg.iconChart), label: 'Thống kê'),
                BottomNavigationBarItem(
                    icon: Badge(
                        label: Text('${Get.find<NotificationController>().notificationsCount}'),
                        child: SvgPicture.asset(AssetSvg.iconNotification)),
                    label: 'Thông báo'),
                BottomNavigationBarItem(icon: SvgPicture.asset(AssetSvg.iconPerson), label: 'Tôi'),
              ],
              currentIndex: bottomNavController.selectedIndex.value,
              selectedItemColor: AppColors.primary1,
              selectedIconTheme: const IconThemeData(),
              onTap: bottomNavController.onItemTapped,
              selectedLabelStyle: ConstantFont.mediumText.copyWith(fontSize: 10),
              unselectedLabelStyle: ConstantFont.mediumText.copyWith(fontSize: 10),
              backgroundColor: AppColors.white,
            )),
      ),
    );
  }
}
