import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/models/issue_model.dart';
import 'package:rent_house/ui/account/customer_issue/detail_issue/detail_issue_screen.dart';
import 'package:rent_house/ui/account/customer_issue/issue_tracking_controller.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:rent_house/widgets/errors/network_error_widget.dart';
import 'package:rent_house/widgets/loading/loading_widget.dart';
import 'package:rent_house/widgets/refresh/smart_refresh.dart';

class IssueTrackingScreen extends StatelessWidget {
  IssueTrackingScreen({super.key});

  final controller = Get.put(IssueTrackingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(label: "Quản lý báo cáo"),
      backgroundColor: AppColors.white,
      body: Obx(() {
        if (controller.viewState.value == ViewState.loading) {
          return const LoadingWidget();
        }
        if ([ViewState.complete, ViewState.init, ViewState.noData]
            .contains(controller.viewState.value)) {
          return Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: controller.viewState.value == ViewState.noData
                    ? _buildNoDataView()
                    : _buildIssueList(),
              ),
            ],
          );
        }

        return NetworkErrorWidget(
          viewState: controller.viewState.value,
        );
      }),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      tabs: controller.issueTabs,
      controller: controller.issueTabController,
      isScrollable: true,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      indicatorColor: AppColors.primary1,
      labelColor: AppColors.primary1,
      unselectedLabelColor: AppColors.black,
      labelStyle: ConstantFont.mediumText.copyWith(color: AppColors.primary1),
      tabAlignment: TabAlignment.start,
      overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
      onTap: controller.changeTab,
    );
  }

  Widget _buildNoDataView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AssetSvg.iconNoResult,
          color: AppColors.primary1,
          height: 100,
          width: 100,
        ),
        const SizedBox(height: 10),
        Text(
          "Không có dữ liệu",
          style: ConstantFont.mediumText.copyWith(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildIssueList() {
    return SmartRefreshWidget(
      controller: controller.issueRefreshCtrl,
      scrollController: ScrollController(),
      onRefresh: () async {
        controller.getHistoryOfIssueTab(isRefresh: true);
      },
      onLoadingMore: controller.getHistoryOfIssueTab,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.issueList.length,
        itemBuilder: (_, index) => _buildIssueWidget(controller.issueList[index]),
      ),
    );
  }

  Widget _buildIssueWidget(IssueModel issue) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.neutralFAFAFA, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${issue.title}",
                style: ConstantFont.mediumText,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => DetailIssueScreen(issueModel: issue));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Xem chi tiết",
                      style: ConstantFont.mediumText.copyWith(
                        color: AppColors.neutralCCCAC6,
                        fontSize: 12,
                      ),
                    ),
                    SvgPicture.asset(
                      AssetSvg.iconChevronForward,
                      color: AppColors.neutralCCCAC6,
                      width: 18,
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Ngày tạo: ',
                  style: ConstantFont.mediumText
                      .copyWith(color: AppColors.neutralCCCAC6, fontSize: 12),
                  children: [
                    TextSpan(
                      text: FormatUtil.formatToDayMonthYear(issue.createdAt.toString()),
                      style: ConstantFont.mediumText.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppUtil.getIssueStatusColor('${issue.status}'),
                ),
                child: Text(
                  controller.getStatus(),
                  style: ConstantFont.regularText.copyWith(color: AppColors.white, fontSize: 10),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _getIssueStatusColor(int index) {
    switch (index) {
      case 0:
        return AppColors.blue;
      case 1:
        return AppColors.yellow;
      case 2:
        return AppColors.green;
      case 3:
        return AppColors.red;
      default:
        return AppColors.blue;
    }
  }
}
