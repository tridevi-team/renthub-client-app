import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/room_model.dart';
import 'package:rent_house/untils/format_util.dart';
import 'package:rent_house/widgets/images/error_image_widget.dart';

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
                    imageUrl: room.images?[0].imageUrl ?? '',
                    width: Get.width / 4,
                    height: 3 * Get.width / 8,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => ErrorImageWidget(
                      width: Get.width / 4,
                      height: Get.width / 2,
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
                  Text(
                    FormatUtil.formatCurrency(room.price ?? 0),
                    style: ConstantFont.lightText.copyWith(fontSize: 16, color: AppColors.primary1),
                  ),
                  const SizedBox(height: 2),
                  Text(
                      (room.maxRenters ?? -1) < 0
                          ? "Không giới hạn"
                          : "Tối đa: ${room.maxRenters} người",
                      maxLines: 3,
                      style: ConstantFont.lightText.copyWith(fontSize: 12)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
