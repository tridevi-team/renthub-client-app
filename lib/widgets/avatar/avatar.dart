
import 'package:flutter/material.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';

class AvatarWidget extends StatelessWidget {
  final String name;
  final double height;
  final double width;
  const AvatarWidget({super.key, required this.name, this.height = 60, this.width = 60});

  @override
  Widget build(BuildContext context) {
    String lastName = name.split(' ').last;
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: const Border.fromBorderSide(BorderSide(width: 1, color: AppColors.neutralF0F0F0)),
        color: getRandomColor(lastName[0]),
      ),
      child: Text(lastName[0], style: ConstantFont.boldText.copyWith(color: AppColors.white, fontSize: 20)),
    );
  }

  Color getRandomColor(String char) {
      int number = char.codeUnitAt(0);
      return (number % 2 != 0) ? AppColors.primary2 : AppColors.primary1;
  }
}
