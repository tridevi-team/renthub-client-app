import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:rent_house/ui/notification/notification_controller.dart';
import 'package:rent_house/ui/notification/notification_screen.dart';
import 'package:rent_house/ui/search/search_screen.dart';
import 'package:rent_house/untils/dialog_util.dart';

class HomeAppBar extends AppBar {
  HomeAppBar({super.key})
      : super(
            automaticallyImplyLeading: false,
            titleSpacing: 10,
            elevation: 0,
            surfaceTintColor: AppColors.white,
            title: SizedBox(
              height: 56,
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Get.to(() => SearchScreen());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 1, color: AppColors.neutralE5E5E3),
                          color: AppColors.neutralF0F0F0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Row(
                          children: [
                            SvgPicture.asset(AssetSvg.iconSearch, color: AppColors.neutral8F8D8A),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Tìm kiếm nhà thuê',
                                style: ConstantFont.mediumText
                                    .copyWith(fontSize: 12, color: AppColors.neutral8F8D8A),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      DialogUtil.showDialogSelectLocation(onLocationTap: (isDistrict) {
                        Get.find<BottomNavBarController>()
                            .onTapOpenCityList(isDistrict: isDistrict);
                      });
                    },
                    child: SvgPicture.asset(
                      AssetSvg.iconLocation,
                      height: 28,
                      width: 28,
                      color: AppColors.primary1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (!Get.find<BottomNavBarController>().isLogin.value) {
                        Get.find<BottomNavBarController>().redirectToLogin();
                      }
                      Get.to(() => const NotificationScreen());
                    },
                    child: Badge(
                      label: Text('${Get.find<NotificationController>().notificationsCount}'),
                        child: SvgPicture.asset(
                      AssetSvg.iconNotification,
                      height: 28,
                      width: 28,
                      color: AppColors.primary1,
                    )),
                  )
                ],
              ),
            ));

}
