import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/home/home_screen/home_controller.dart';
import 'package:rent_house/ui/notification/notification_controller.dart';
import 'package:rent_house/ui/notification/notification_screen.dart';

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
                    onTap: () {},
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
                                style: ConstantFont.mediumText.copyWith(fontSize: 12, color: AppColors.neutral8F8D8A),
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
                      Get.to(() => const NotificationScreen());
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
                      Get.to(() => const NotificationScreen());
                    },
                    child: Badge(
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

  final notificationController = Get.find<NotificationController>();
}
