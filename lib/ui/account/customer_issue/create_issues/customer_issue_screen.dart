import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/room_model.dart';
import 'package:rent_house/ui/account/customer_issue/create_issues/customer_issue_controller.dart';
import 'package:rent_house/widgets/buttons/custom_elevated_button.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:rent_house/widgets/textfield/text_input_widget.dart';

class CustomerIssueScreen extends StatelessWidget {
  CustomerIssueScreen({super.key, this.equipment});

  final CustomerIssueController controller = Get.put(CustomerIssueController());
  final EquipmentModel? equipment;

  @override
  Widget build(BuildContext context) {
    controller.titleCtrl.text = equipment != null ? "${equipment?.name} - ${equipment?.code}" : "";
    controller.equipment = equipment;
    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        if (controller.uploadProgress.value == 100 || controller.uploadProgress.value == 0.0) {
          Future.microtask(() {
            if (Get.context != null) {
              Get.back();
            }
          });
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(label: "Báo cáo vấn đề"),
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInputWidget(
                      controller: controller.titleCtrl,
                      hintText: 'Tiêu đề',
                      enable: equipment != null ? false : true,
                      turnOffClearText: equipment != null ? true : false,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(width: 1, color: const Color(0xFF9C9C9C)),
                      ),
                      child: TextField(
                        controller: controller.contentCtrl,
                        decoration: InputDecoration(
                            hintText: "Mô tả",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: ConstantFont.fontLexendDeca,
                                fontWeight: FontWeight.w400),
                            contentPadding: const EdgeInsets.all(10),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            alignLabelWithHint: true,
                            counterText: ""),
                        maxLines: 10,
                        style: ConstantFont.regularText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Hình ảnh", style: ConstantFont.mediumText.copyWith(fontSize: 16)),
                    const SizedBox(height: 10),
                    _buildMediaGrid(controller.selectedImages, controller.pickImage,
                        controller.removeImage, AssetSvg.iconCamera, controller.selectedImages),
                    const SizedBox(height: 20),
                    Text("Videos", style: ConstantFont.mediumText.copyWith(fontSize: 16)),
                    const SizedBox(height: 10),
                    _buildMediaGrid(controller.videoThumbnails, controller.pickVideo,
                        controller.removeVideo, AssetSvg.iconVideo, controller.selectedVideos),
                    const SizedBox(height: 20),
                    CustomElevatedButton(label: 'Tạo báo cáo', onTap: controller.createIssue)
                  ],
                ),
              ),
            ),
            Obx(() {
              if (controller.uploadProgress.value == 0.0 ||
                  controller.uploadProgress.value >= 99.11) return const SizedBox.shrink();
              return Positioned.fill(
                child: Container(
                  color: AppColors.black.withOpacity(0.02),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            value: controller.uploadProgress / 100,
                            strokeWidth: 6,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary1),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${controller.uploadProgress.toStringAsFixed(0)}%",
                          textAlign: TextAlign.center,
                          style: ConstantFont.mediumText
                              .copyWith(color: AppColors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaGrid(
    List<dynamic> mediaList,
    VoidCallback onPickMedia,
    Function(int) onRemoveMedia,
    String iconAsset,
    List<dynamic> selectedList,
  ) {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              3,
              (index) => GestureDetector(
                onTap: onPickMedia,
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(4),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.neutral8F8D8A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: mediaList.length > index && mediaList[index] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.file(
                                mediaList[index],
                                fit: BoxFit.cover,
                              ),
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(iconAsset),
                            ),
                    ),
                    if (selectedList.length > index)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => onRemoveMedia(index),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8), topRight: Radius.circular(4)),
                              color: AppColors.neutralF0F0F0,
                            ),
                            child: SvgPicture.asset(AssetSvg.iconClose, color: AppColors.red),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
