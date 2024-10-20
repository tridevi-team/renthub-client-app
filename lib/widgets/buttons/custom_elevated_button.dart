import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_house/constants/constant_font.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final String? iconPath;
  final VoidCallback onTap;
  final Color? bgColor;
  final Color? textColor;

  const CustomElevatedButton(
      {super.key,
      required this.label,
      required this.onTap,
      this.bgColor = Colors.white,
      this.textColor = const Color(0xFF4B7BE5), this.iconPath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
          onPressed: onTap,
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(bgColor!),
              side: WidgetStateProperty.all<BorderSide>(
                  const BorderSide(color: Color(0xFF4B7BE5), width: 1)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ))),
          child: iconPath?.isNotEmpty == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(iconPath!, width: 24),
                    const SizedBox(width: 10),
                    Text(label, style: ConstantFont.boldText.copyWith(color: textColor))
                  ],
                )
              : Text(label, style: ConstantFont.boldText.copyWith(color: textColor))),
    );
  }
}