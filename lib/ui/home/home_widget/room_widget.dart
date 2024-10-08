import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/room_model.dart';

class RoomWidget extends StatelessWidget {

  final void Function()? onTap;
  final Room room;

  const RoomWidget({super.key, this.onTap, required this.room});


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
                    imageUrl: room.images?[0] ?? '',
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
                  Text(room.name ?? '', style: ConstantFont.semiBoldText),
                  const SizedBox(height: 8),

                  Text.rich(
                    style: ConstantFont.lightText.copyWith(fontSize: 16, color: AppColors.primary1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    TextSpan(
                      text: '${room.price}',
                      children: const [
                        TextSpan(
                          text: 'đ',
                          style: TextStyle(fontSize: 12, fontFeatures: [FontFeature.superscripts()]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text('tối đa: ${room.maxRenters}',
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
