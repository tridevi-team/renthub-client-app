import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:rent_house/widgets/buttons/custom_elevated_button.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';

class PaymentResult extends StatelessWidget {
  final bool isSuccess;
  final String mainText;
  final String subText;

  const PaymentResult({
    super.key,
    required this.isSuccess,
    required this.mainText,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        isTransparent: true,
        onBack: () {
          Get.back();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              isSuccess ? AssetSvg.iconCheckMark : AssetSvg.iconClose,
              width: 50,
              color: isSuccess ? AppColors.green : AppColors.red,
            ),
            const SizedBox(height: 20),
            Text(
              mainText,
              style: ConstantFont.boldText.copyWith(
                fontSize: 16,
                color: isSuccess ? AppColors.green : AppColors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              subText,
              style: ConstantFont.mediumText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              label: "Về màn hình chính",
              onTap: () {
                final controller = Get.find<BottomNavBarController>();
                Get.until((route) => route.isFirst);
                controller.selectedIndex.value = 0;
                controller.pageController.jumpToPage(0);
              },
            ),
            const SizedBox(height: 10),
            CustomElevatedButton(
              label: isSuccess ? "Xem chi tiết hóa đơn" : "Thanh toán lại",
              onTap: () {
                Get.back(result: true);
              },
              isReverse: true,
            )
          ],
        ),
      ),
    );
  }
}
