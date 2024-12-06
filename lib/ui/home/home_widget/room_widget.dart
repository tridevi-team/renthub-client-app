import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/models/room_model.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/widgets/images/error_image_widget.dart';
import 'package:shimmer/shimmer.dart';

class RoomWidget extends StatelessWidget {
  final void Function()? onTap;
  final Room room;

  const RoomWidget({super.key, this.onTap, required this.room});

  @override
  Widget build(BuildContext context) {
    bool status = room.status == ConstantString.statusAvailable;
    double width = Get.width * 0.4;
    return InkWell(
      onTap: () {
        if (!status) return;
        onTap?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: status ? AppColors.white : AppColors.neutralFAFAFA,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    room.images?[0].imageUrl ?? '',
                    width: width,
                    height: width,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Shimmer.fromColors(
                          baseColor: AppColors.neutralF0F0F0,
                          highlightColor: AppColors.shimmerColor,
                          child: Container(
                            width: width,
                            height: width,
                            color: Colors.white,
                          ));
                    },
                    errorBuilder: (_, __, ___) => ErrorImageWidget(
                      width: width,
                      height: width,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                          color: status ? AppColors.green : AppColors.red,
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        status ? "Khả dụng" : "Không khả dụng",
                        style:
                            ConstantFont.mediumText.copyWith(fontSize: 10, color: AppColors.white),
                      ),
                    ))
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
