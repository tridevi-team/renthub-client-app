import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:rent_house/ui/home/home_screen/home_controller.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/widgets/buttons/custom_elevated_button.dart';
import 'package:rent_house/widgets/loading/loading_widget.dart';
import 'package:rent_house/widgets/ratio/radio_option.dart';

class DialogUtil {
  DialogUtil._();

  static showDialogSelectLocation({
    String? content,
    bool isShowBottomSheet = false,
    required Function(bool isDistrict) onLocationTap,
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
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12)),
                      child: Image.asset("assets/images/image.png", width: 343, height: 208, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          controller.onSelectedCancel();
                          Get.back();
                        },
                        child: SvgPicture.asset(AssetSvg.iconClose),
                      ),
                    ),
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
                      onCityTap: () => onLocationTap(false),
                      onDistrictTap: () => onLocationTap(true),
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

  static showDialogConfirm({VoidCallback? onClose, required VoidCallback onConfirm, required String text, String title = ''}) {
    return Get.dialog(
      barrierDismissible: false,
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: 220,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (title != '') ...[
                Text(
                  title,
                  style: ConstantFont.semiBoldText.copyWith(fontSize: 16, color: AppColors.primary1),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Divider(
                  height: 1,
                  color: AppColors.neutralE9e9e9,
                ),
                const SizedBox(height: 10),
              ],
              Text(
                text,
                style: ConstantFont.mediumText,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomElevatedButton(label: 'Hủy', onTap: onClose ?? Get.back),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomElevatedButton(label: 'Xác nhận', textColor: AppColors.white, bgColor: AppColors.primary600, onTap: onConfirm),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> showSortBottomSheet({
    required int selectedOption,
    required List<String> options,
    required void Function(int index) onSelected,
  }) async {
    await Get.bottomSheet(
      Container(
        height: Get.height / 3,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sắp xếp theo',
                  style: ConstantFont.mediumText,
                ),
                GestureDetector(
                  onTap: Get.back,
                  child: SvgPicture.asset(AssetSvg.iconClose),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: AppColors.neutralF5F5F5),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: options.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return RadioOption(
                    label: options[index],
                    isSelected: index == selectedOption,
                    onSelected: () => onSelected(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
  }

  static Future<void> showFilterBottomSheet({
    Rx<RangeValues>? currentRange,
    ValueChanged<RangeValues>? onChanged,
    VoidCallback? onApply,
    double min = 0,
    double max = 0,
    int division = 1000000,
    bool isArea = false,
  }) async {
    await Get.bottomSheet(
      Container(
        height: Get.height / 3,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Bộ lọc",
                textAlign: TextAlign.center,
                style: ConstantFont.mediumText.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            if (currentRange != null) ...[
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RangeSlider(
                      values: currentRange.value,
                      min: min,
                      max: max,
                      divisions: (max - min) ~/ division,
                      inactiveColor: AppColors.neutralCCCAC6,
                      activeColor: AppColors.primary1,
                      onChanged: onChanged,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isArea ? "${currentRange.value.start.toInt()} m²" : FormatUtil.formatCurrency(currentRange.value.start.toInt()),
                          style: ConstantFont.mediumText,
                        ),
                        Text(
                          isArea ? "${currentRange.value.end.toInt()} m²" : FormatUtil.formatCurrency(currentRange.value.end.toInt()),
                          style: ConstantFont.mediumText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              Text(
                "Hãy chọn lọc theo khoảng giá hoặc diện tích",
                style: ConstantFont.mediumText.copyWith(fontSize: 16),
              ),
            ],
            if (onApply != null) ...[
              const Spacer(),
              CustomElevatedButton(
                onTap: onApply,
                label: "Áp dụng",
                textColor: AppColors.white,
                bgColor: AppColors.primary600,
              ),
            ]
          ],
        ),
      ),
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  static void showLoading({Rx<double>? uploadProgress}) {
    if (!Get.isDialogOpen!) {
      Get.dialog(
          PopScope(
            canPop: false,
            onPopInvoked: (value) => Future.value(false),
            child: Material(
              surfaceTintColor: Colors.transparent,
              color: Colors.transparent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LoadingWidget(),
                    if (uploadProgress != null) ...[
                      Obx(() => uploadProgress.value != 0
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  "${uploadProgress.toStringAsFixed(0)}%",
                                  textAlign: TextAlign.center,
                                  style: ConstantFont.mediumText.copyWith(color: AppColors.white, fontSize: 16),
                                )
                              ],
                            )
                          : const SizedBox())
                    ]
                  ],
                ),
              ),
            ),
          ),
          barrierDismissible: false);
    }
  }

  static void hideLoading() {
    try {
      if (Get.isDialogOpen!) {
        Get.close(1);
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "hide loading", message: "$e");
    }
  }

  static void showNFCAnimation() {
    Get.dialog(
      barrierDismissible: false,
      Dialog(insetPadding: EdgeInsets.zero, backgroundColor: Colors.transparent, child: SizedBox(
        height: Get.height * 0.5,
        child: Lottie.asset('assets/anim/nfc.json'),
      )),
    );
  }
}
