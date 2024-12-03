import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/issue_model.dart';
import 'package:rent_house/ui/account/customer_issue/detail_issue/detail_issue_controller.dart';
import 'package:rent_house/ui/account/customer_issue/detail_issue/media_screen.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:rent_house/widgets/images/error_image_widget.dart';
import 'package:shimmer/shimmer.dart';

class DetailIssueScreen extends StatelessWidget {
  DetailIssueScreen({super.key});

  final controller = Get.put(DetailIssueController());

  @override
  Widget build(BuildContext context) {
    final issue = controller.issueModel;
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
                issue?.title ?? '',
                style: ConstantFont.mediumText.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${issue?.roomName ?? ''} - ${issue?.floorName ?? ''}',
                style: ConstantFont.regularText,
              ),
              const SizedBox(height: 8),
              _buildIssueInfoRow(issue),
              const SizedBox(height: 12),
              _buildDescriptionField(issue?.content),
              const SizedBox(height: 12),
              _buildMediaSection(
                title: "Hình ảnh",
                mediaList: issue?.files?.image,
                isMp4: false,
              ),
              const SizedBox(height: 12),
              _buildMediaSection(
                title: "Video",
                mediaList: issue?.files?.video,
                isMp4: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIssueInfoRow(IssueModel? issue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            text: 'Ngày tạo: ',
            style: ConstantFont.regularText.copyWith(
              color: AppColors.neutralCCCAC6,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: FormatUtil.formatToDayMonthYear(issue?.createdAt?.toString()),
                style: ConstantFont.regularText.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: AppUtil.getIssueStatusColor(issue?.status ?? ''),
          ),
          child: Text(
            getNameStatus(issue?.status ?? ''),
            style: ConstantFont.regularText.copyWith(
              color: AppColors.white,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(String? content) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 1, color: AppColors.neutralE9e9e9),
      ),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: content ?? '',
          hintStyle: ConstantFont.regularText,
          contentPadding: const EdgeInsets.all(10),
          border: InputBorder.none,
        ),
        maxLines: 10,
        style: ConstantFont.regularText,
      ),
    );
  }

  Widget _buildMediaSection({
    required String title,
    List<dynamic>? mediaList,
    required bool isMp4,
  }) {
    if (mediaList == null || mediaList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: ConstantFont.regularText),
        const SizedBox(height: 8),
        _buildMediaGrid(mediaList, isMp4),
      ],
    );
  }

  Widget _buildMediaGrid(List<dynamic> mediaList, bool isMp4) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: mediaList.map((media) {
          return GestureDetector(
            onTap: () {
              Get.to(() => MediaScreen(url: media, isMp4: isMp4));
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
                child: isMp4
                    ? SvgPicture.asset(
                  AssetSvg.iconPlay,
                  color: AppColors.neutral9E9E9E,
                )
                    : Image.network(
                  media,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: AppColors.neutralF0F0F0,
                      highlightColor: AppColors.shimmerColor,
                      child: Container(color: Colors.white),
                    );
                  },
                  errorBuilder: (_, __, ___) => const ErrorImageWidget(
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
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

