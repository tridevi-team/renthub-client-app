import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/constants/enums/enums.dart';

class NetworkErrorWidget extends StatelessWidget {
  NetworkErrorWidget({super.key, required this.viewState});

  final ViewState viewState;

  final List<Map<String, String>> statusWidgets = [
    {
      'image': AssetSvg.imgNoInternet,
      'content': "Không có kết nối internet. Vui lòng kiểm tra mạng của bạn.",
    },
    {
      'image': AssetSvg.imgServerNotFound,
      'content': "Không tìm thấy máy chủ. Vui lòng thử lại sau.",
    },
    {
      'image': AssetSvg.imgServerInternal,
      'content': "Lỗi máy chủ nội bộ. Vui lòng thử lại sau.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    String image = '';
    String content = '';

    if (viewState == ViewState.notFound) {
      image = statusWidgets[1]['image']!;
      content = statusWidgets[1]['content']!;
    } else if (viewState == ViewState.serverError) {
      image = statusWidgets[2]['image']!;
      content = statusWidgets[2]['content']!;
    } else {
      image = statusWidgets[0]['image']!;
      content = statusWidgets[0]['content']!;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(image, width: Get.width,),
            const SizedBox(height: 20),
            Text(
              content,
              style: ConstantFont.mediumText.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
