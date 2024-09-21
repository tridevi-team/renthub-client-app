import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/notification/notification_controller.dart';
import 'package:rent_house/ui/notification/notification_screen.dart';
import 'package:rent_house/widgets/badge/badge_widget.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.find<NotificationController>();
    return Obx(() => Row(children: [
      Expanded(child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: Colors.transparent),
            color: AppColors.white
          ),
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(children: [
              SvgPicture.asset(AssetSvg.iconSearch),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tìm kiếm nhà thuê',
                  style: ConstantFont.mediumText.copyWith(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Get.to(() => const NotificationScreen());
                },
                child: BadgeWidget(child: SvgPicture.asset(AssetSvg.iconNotification,
                  height: 24, width: 24,
                  colorFilter: const ColorFilter.mode(AppColors.primary1, BlendMode.color),)),
              )
            ],),),
        ),
      ))
    ],));
  }
}
