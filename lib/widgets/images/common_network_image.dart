import 'package:flutter/material.dart';
import 'package:rent_house/constants/asset_svg.dart';

class CommonNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double width;
  final double borderRadius;
  final BoxFit fit;
  final String placeholderAsset;

  const CommonNetworkImage({
    super.key,
    required this.imageUrl,
    this.height = 60,
    this.width = 60,
    this.borderRadius = 6,
    this.fit = BoxFit.cover,
    this.placeholderAsset = AssetSvg.imgLogoApp,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl ?? '',
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, __, ___) => Image.asset(
          placeholderAsset,
          height: height,
          width: width,
          fit: fit,
        ),
      ),
    );
  }
}
