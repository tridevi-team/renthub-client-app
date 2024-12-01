import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/issue_model.dart';
import 'package:rent_house/ui/account/customer_issue/detail_issue/media_screen.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:rent_house/widgets/images/error_image_widget.dart';
import 'package:shimmer/shimmer.dart';

class DetailIssueScreen extends StatelessWidget {
  const DetailIssueScreen({super.key, r, required this.issueModel});

  final IssueModel issueModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(label: 'Chi tiết vấn đề'),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${issueModel.title}',
                style: ConstantFont.mediumText.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${issueModel.roomName} - ${issueModel.floorName}',
                style: ConstantFont.regularText,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Ngày tạo: ',
                      style: ConstantFont.regularText
                          .copyWith(color: AppColors.neutralCCCAC6, fontSize: 14),
                      children: [
                        TextSpan(
                          text: FormatUtil.formatToDayMonthYear(issueModel.createdAt.toString()),
                          style: ConstantFont.regularText.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppUtil.getIssueStatusColor('${issueModel.status}'),
                    ),
                    child: Text(
                      getNameStatus('${issueModel.status}'),
                      style:
                          ConstantFont.regularText.copyWith(color: AppColors.white, fontSize: 12),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 1, color: AppColors.neutralE9e9e9),
                ),
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: "${issueModel.content}",
                      hintStyle: ConstantFont.regularText,
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
              const SizedBox(height: 12),
              if (issueModel.files != null &&
                  issueModel.files!.image != null &&
                  issueModel.files!.image!.isNotEmpty) ...[
                Text("Hình ảnh", style: ConstantFont.regularText),
                const SizedBox(height: 8),
                _buildMediaGrid(
                  issueModel.files!.image!,
                  () {},
                ),
              ],
              const SizedBox(height: 12),
              if (issueModel.files != null &&
                  issueModel.files!.video != null &&
                  issueModel.files!.video!.isNotEmpty) ...[
                Text("Video", style: ConstantFont.regularText),
                const SizedBox(height: 8),
                _buildMediaGrid(issueModel.files!.video!, () {}, isMp4: true),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaGrid(List<dynamic> mediaList, VoidCallback onTap, {bool isMp4 = false}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          mediaList.length,
          (index) => GestureDetector(
            onTap: onTap,
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => MediaScreen(url: mediaList[index], isMp4: isMp4));
                  },
                  child: Container(
                      margin: const EdgeInsets.all(4),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.neutral8F8D8A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: !isMp4
                            ? Image.network(
                                mediaList[index],
                                fit: BoxFit.cover,
                                loadingBuilder: (_, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Shimmer.fromColors(
                                      baseColor: AppColors.neutralF0F0F0,
                                      highlightColor: AppColors.shimmerColor,
                                      child: Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.white,
                                  ));
                                },
                                errorBuilder: (_, __, ___) =>
                                    const ErrorImageWidget(
                                  width: 100,
                                  height: 100,
                                ),
                              )
                            : SvgPicture.asset(
                                AssetSvg.iconPlay,
                                color: AppColors.neutral9E9E9E,
                              ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getNameStatus(String status) {
    switch (status) {
      case "OPEN":
        return "Chờ xử lý";
      case "IN_PROGRESS":
        return "Đang xử lý";
      case "DONE":
        return "Đã xử lý";
      case "CLOSED":
        return "Đã đóng";
      default:
        return "Chờ xử lý";
    }
  }
}
