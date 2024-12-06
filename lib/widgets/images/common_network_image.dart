import 'package:cached_network_image/cached_network_image.dart';
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
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? '',
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => Image.asset(
          placeholderAsset,
          height: height,
          width: width,
          fit: fit,
        ),
        errorWidget: (context, url, error) => Image.asset(
          placeholderAsset,
          height: height,
          width: width,
          fit: fit,
        ),
      ),
    );
  }
}
