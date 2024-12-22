import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';

class RadioOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const RadioOption({super.key, required this.label, this.isSelected = false, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
            onTap: onSelected,
            child: SvgPicture.asset(isSelected ? AssetSvg.iconRadioOn : AssetSvg.iconRadioOff,
                color: isSelected ? AppColors.primary1 : AppColors.neutral9E9E9E)),
        const SizedBox(width: 4),
        Text(
          label,
          style: ConstantFont.regularText,
        ),
      ],
    );
  }
}
