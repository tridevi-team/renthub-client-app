import 'package:flutter/material.dart';
import 'package:rent_house/constants/constant_font.dart';


class TitleInputWidget extends StatelessWidget {
  final String title;
  final Color? color;
  final bool isRequired;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? edgeInsetsGeometry;

  const TitleInputWidget({super.key, required this.title, this.color, this.edgeInsetsGeometry, this.isRequired = false, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: edgeInsetsGeometry != null ? edgeInsetsGeometry! : const EdgeInsets.all(0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: ConstantFont.fontLexendDeca,
              fontWeight: fontWeight ?? FontWeight.w500,
              color: color ?? Colors.black,
              fontSize: 14,
            ),
          ),
          isRequired ? Text(" *", style: TextStyle(fontFamily: ConstantFont.fontLexendDeca,
              fontWeight: fontWeight ?? FontWeight.w500, color: const Color(0xffF62323), fontSize: 14))
              : const SizedBox()
        ],
      ),
    );
  }
}
