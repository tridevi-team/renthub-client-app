import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:rent_house/ui/home/home_screen/home_controller.dart';

class DialogUtil {
  DialogUtil._();

  static showDialogSelectLocation({
    String? content,
    bool isShowBottomSheet = false,
    Function? onCityTap,
    Function? onDistrictTap,
  }) {
    final controller = Get.find<BottomNavBarController>();
    final homeController = Get.find<HomeController>();
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12), topLeft: Radius.circular(12)),
                      child: Image.asset("assets/images/image.png",
                              width: 343, height: 208, fit: BoxFit.cover),
                    ),
                    Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: SvgPicture.asset(AssetSvg.iconClose)))
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 168),
                    _buildLocationSelection(
                      title: 'Để xem những căn hộ gần nơi bạn, xin vui lòng chọn địa điểm.',
                      cityLabel: controller.currentLabelCity,
                      districtLabel: controller.currentLabelDistrict,
                      isShowBottomSheet: isShowBottomSheet,
                      onCityTap: onCityTap,
                      onDistrictTap: onDistrictTap,
                      onConfirm: () {
                        Get.back();
                        homeController.onRefreshData();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildLocationSelection({
    required String title,
    required RxString cityLabel,
    required RxString districtLabel,
    required bool isShowBottomSheet,
    Function? onCityTap,
    Function? onDistrictTap,
    required VoidCallback onConfirm,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      width: 343,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: ConstantFont.regularText),
          const SizedBox(height: 20),
          _buildLocationTile(
            label: cityLabel,
            onTap: () => onCityTap?.call(),
            isShowBottomSheet: isShowBottomSheet,
          ),
          const SizedBox(height: 20),
          _buildLocationTile(
            label: districtLabel,
            onTap: () => onDistrictTap?.call(),
            isShowBottomSheet: isShowBottomSheet,
          ),
          const SizedBox(height: 20),
          _buildConfirmButton(onConfirm: onConfirm),
        ],
      ),
    );
  }

  static Widget _buildLocationTile({
    required RxString label,
    required VoidCallback onTap,
    required bool isShowBottomSheet,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1.5, color: const Color(0xFFF4F4F4)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Obx(() => Text(label.value, style: ConstantFont.regularText)),
              const Spacer(),
              SvgPicture.asset(
                isShowBottomSheet ? AssetSvg.iconChevronUp : AssetSvg.iconChevronDown,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildConfirmButton({required VoidCallback onConfirm}) {
    return GestureDetector(
      onTap: onConfirm,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.primary1,
          borderRadius: BorderRadius.all(Radius.circular(52)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            'Xác nhận',
            style: ConstantFont.regularText.copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
