import 'package:flutter/material.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';

class BadgeWidget extends StatelessWidget {

  final bool isShowing;
  final Widget child;
  final String value;
  const BadgeWidget({super.key, required this.child, this.isShowing = false, this.value = '0'});


  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (isShowing)
          Positioned(
            right: -3,
            top: -3,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColors.white, strokeAlign: BorderSide.strokeAlignOutside),
                borderRadius: BorderRadius.circular(50),
                color: AppColors.red,
              ),
              child: Text(value, style: ConstantFont.boldText.copyWith(fontSize: 10, color: AppColors.white)),
            ),
          )
      ],
    );
  }
}
