import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/explore_model.dart';

class HomeExploreItem extends StatelessWidget {
  const HomeExploreItem({super.key, required this.explore});

  final Explore explore;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6)),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: 'assets/images/started.png',
              errorWidget: (_, __, ___) => Image.asset(
                'assets/images/image.png',
                width: Get.width / 3,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              width: Get.width / 3,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 8,
              right: 0,
              left: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(explore.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ConstantFont.semiBoldText.copyWith(fontSize: 12, color: AppColors.white)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text('Xem ngay ${explore.quantity} dự án',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: ConstantFont.boldText.copyWith(fontSize: 10, color: AppColors.white)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );

  }
}
