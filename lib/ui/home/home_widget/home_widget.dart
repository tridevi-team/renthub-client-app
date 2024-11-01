import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/house_data_model.dart';
import 'package:rent_house/untils/format_util.dart';

class HomeWidget extends StatelessWidget {

  final void Function()? onTap;
  final House house;

  const HomeWidget({super.key, this.onTap, required this.house});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                  clipBehavior: Clip.hardEdge,
                  child: CachedNetworkImage(
                    imageUrl: house.thumbnail!,
                    width: Get.width / 4,
                    height: 3 * Get.width / 8,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Image.asset(
                      'assets/images/image.png',
                      width: Get.width / 4,
                      height: Get.width / 2,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(house.name ?? '', style: ConstantFont.semiBoldText),
                const SizedBox(height: 8),
                  Text(
                      '${FormatUtil.roundToMillion(house.minPrice!)} - ${FormatUtil.roundToMillion(house.maxPrice!)} triệu',
                      style: ConstantFont.mediumText
                          .copyWith(fontSize: 16, color: AppColors.primary1)),
                  const SizedBox(height: 2),
                /*Text.rich(
                    style: ConstantFont.lightText.copyWith(fontSize: 12),
                    const TextSpan(
                      text: '47 m',
                      children: [
                        TextSpan(
                          text: '2',
                          style: TextStyle(fontSize: 12, fontFeatures: [FontFeature.superscripts()]),
                        ),
                      ],
                    ),
                  ),*/
                const SizedBox(height: 2),
                Text(
                    '${house.address?.street}, ${house.address?.ward}, ${house.address?.district}, ${house.address?.city}',
                    maxLines: 3,
                    style: ConstantFont.lightText.copyWith(fontSize: 12)),
              ],),
            )
          ],
        ),
      ),
    );
  }
}
