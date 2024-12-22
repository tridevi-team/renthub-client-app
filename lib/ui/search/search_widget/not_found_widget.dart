import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({super.key, this.title, this.content});

  final String? title;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AssetSvg.iconNoResult,
            color: AppColors.primary1,
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 32),
          Text(
            title != null ? title! : 'Rất tiếc, hiện không có phòng nào phù hợp với tìm kiếm của bạn.',
            style: ConstantFont.semiBoldText.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            content != null ? content! :'Hãy thử tìm kiếm một căn phòng khác hoặc quay lại trang chủ.',
            style: ConstantFont.regularText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
