import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/home/home_explore/home_explore_item.dart';
import 'package:rent_house/ui/home/home_screen/home_controller.dart';

class HomeExplore extends StatelessWidget {
  const HomeExplore({super.key});


  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return controller.exploreList.isEmpty
        ? const SizedBox.shrink()
        : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Khám phá', style: ConstantFont.boldText.copyWith(fontSize: 16)),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                height: 200,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return HomeExploreItem(explore: controller.exploreList[index]
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemCount: controller.exploreList.length),
              ),
                const SizedBox(height: 16),
              const Divider(height: 1, color: AppColors.neutralF5F5F5),
                const SizedBox(height: 16),
            ]),
        );
  }
}