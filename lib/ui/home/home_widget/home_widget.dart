import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/house_data_model.dart';
import 'package:rent_house/untils/format_util.dart';
import 'package:rent_house/widgets/images/error_image_widget.dart';
import 'package:shimmer/shimmer.dart';

class HomeWidget extends StatelessWidget {
  final void Function()? onTap;
  final House house;

  const HomeWidget({super.key, this.onTap, required this.house});

  @override
  Widget build(BuildContext context) {
    final double imageWidth = Get.width / 4;
    final double imageHeight = 3 * Get.width / 8;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: house.thumbnail ?? '',
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.cover,
                placeholder: (_, __) => Shimmer.fromColors(
                  baseColor: AppColors.neutralF0F0F0,
                  highlightColor: AppColors.shimmerColor,
                  child: Container(
                    width: imageWidth,
                    height: imageHeight,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (_, __, ___) =>ErrorImageWidget(
                  width: imageWidth,
                  height: imageHeight,
                ),
              ),
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
                    style: ConstantFont.mediumText.copyWith(
                      fontSize: 16,
                      color: AppColors.primary1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${house.address?.street}, ${house.address?.ward}, ${house.address?.district}, ${house.address?.city}',
                    maxLines: 3,
                    style: ConstantFont.lightText.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    children: [
                      _buildFeatureRow(AssetSvg.iconBusiness, '${house.numOfRooms} phòng'),
                      _buildFeatureRow(
                        AssetSvg.iconCrop,
                        '${house.minRoomArea} - ${house.maxRoomArea} m',
                        hasSuperscript: true,
                      ),
                      _buildFeatureRow(
                        AssetSvg.iconMultiPeople,
                        '${(house.minRenters ?? 1) < 0 ? 1 : house.minRenters} - '
                            '${(house.maxRenters ?? -1) < 0 ? "Không giới hạn" : "${house.maxRenters} người"}'
                        ,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String iconPath, String text, {bool hasSuperscript = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SvgPicture.asset(iconPath),
        const SizedBox(width: 4),
        hasSuperscript
            ? Text.rich(
                TextSpan(
                  text: text,
                  style: ConstantFont.lightText.copyWith(fontSize: 12),
                  children: const [
                    TextSpan(
                      text: '2',
                      style: TextStyle(
                        fontSize: 12,
                        fontFeatures: [FontFeature.superscripts()],
                      ),
                    ),
                  ],
                ),
              )
            : Text(
                text,
                style: ConstantFont.lightText.copyWith(fontSize: 12),
              ),
      ],
    );
  }
}
