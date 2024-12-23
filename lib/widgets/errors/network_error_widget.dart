import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/widgets/buttons/custom_elevated_button.dart';

class NetworkErrorWidget extends StatelessWidget {
  NetworkErrorWidget({super.key, required this.viewState, this.onRefresh});

  final ViewState viewState;
  final void Function()? onRefresh;

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
    if (viewState == ViewState.noInternetConnection) {
      image = statusWidgets[0]['image']!;
      content = statusWidgets[0]['content']!;
    } else if (viewState == ViewState.notFound) {
      image = statusWidgets[1]['image']!;
      content = statusWidgets[1]['content']!;
    } else if (viewState == ViewState.serverError) {
      image = statusWidgets[2]['image']!;
      content = statusWidgets[2]['content']!;
    } else {
      image = statusWidgets[1]['image']!;
      content = statusWidgets[1]['content']!;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: Get.width,
            ),
            const SizedBox(height: 20),
            Text(
              content,
              style: ConstantFont.mediumText.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (onRefresh != null) ...[
              CustomElevatedButton(
                label: 'Thử lại',
                onTap: onRefresh!.call,
                width: Get.width / 2,
                isReverse: true,
              )
            ]
          ],
        ),
      ),
    );
  }
}
