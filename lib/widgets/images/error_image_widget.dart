import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorImageWidget extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ErrorImageWidget({
    super.key,
    this.imagePath = 'assets/images/image.png',
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: width ?? Get.width,
      height: height ?? 300,
      fit: fit,
    );
  }
}
