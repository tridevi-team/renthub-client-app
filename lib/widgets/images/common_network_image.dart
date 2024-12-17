import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:shimmer/shimmer.dart';

class CommonNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double width;
  final double borderRadius;
  final BoxFit fit;
  final String placeholderAsset;
  final Widget? errorWidget;
  final Widget? placeholderWidget;

  const CommonNetworkImage({
    super.key,
    required this.imageUrl,
    this.height = 60,
    this.width = 60,
    this.borderRadius = 6,
    this.fit = BoxFit.cover,
    this.placeholderAsset = AssetSvg.imgLogoApp,
    this.errorWidget,
    this.placeholderWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: ExtendedImage.network(
        imageUrl ?? '',
        height: height,
        width: width,
        fit: fit,
        cache: true,
        cacheWidth: width.ceil(),
        compressionRatio: 0.9,
        loadStateChanged: (state) {
          return _buildLoadState(state);
        },
      ),
    );
  }

  Widget? _buildLoadState(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        return placeholderWidget ??
            Shimmer.fromColors(
              baseColor: AppColors.neutralF0F0F0,
              highlightColor: AppColors.shimmerColor,
              child: Container(
                width: width,
                height: height,
                color: Colors.white,
              ),
            );
      case LoadState.failed:
        return errorWidget ??
            Image.asset(
              placeholderAsset,
              height: height,
              width: width,
              fit: fit,
            );
      case LoadState.completed:
        return null;
    }
  }
}
