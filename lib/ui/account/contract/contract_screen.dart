import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/models/contract_model.dart';
import 'package:rent_house/ui/account/contract/contract_controller.dart';
import 'package:rent_house/ui/account/contract/detail/contract_detail_screen.dart';
import 'package:rent_house/ui/webview/webview_screen.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:rent_house/widgets/errors/network_error_widget.dart';
import 'package:rent_house/widgets/loading/loading_widget.dart';
import 'package:rent_house/widgets/refresh/smart_refresh.dart';

class CustomerContractScreen extends StatelessWidget {
  CustomerContractScreen({super.key});

  final controller = Get.put(CustomerContractController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(label: "Quản lý hợp đồng"),
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
                    : _buildContractList(),
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
      tabs: controller.contractTabs,
      controller: controller.contractTabController,
      isScrollable: true,
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

  Widget _buildContractList() {
    return SmartRefreshWidget(
      controller: controller.contractRefreshCtrl,
      scrollController: ScrollController(),
      onRefresh: () async {
        controller.getContractHistoryTab(isRefresh: true);
      },
      onLoadingMore: controller.getContractHistoryTab,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.contracts.length,
          itemBuilder: (_, index) => _buildIssueWidget(controller.contracts[index]),
        ),
      ),
    );
  }

  Widget _buildIssueWidget(ContractModel contract) {
    return InkWell(
      onTap: () async {
        Get.to(() => ContractDetailScreen(), arguments: {"contractId": contract.id});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: const Border.fromBorderSide(BorderSide(color: AppColors.neutralCCCAC6, width: 1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hợp đồng thuê nhà",
                  style: ConstantFont.mediumText,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: _getStatusColor('${contract.approvalStatus}'),
                  ),
                  child: Text(
                    controller.getStatusName('${contract.approvalStatus}'),
                    style: ConstantFont.regularText.copyWith(color: AppColors.white, fontSize: 10),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "${FormatUtil.formatToDayMonthYear(
                contract.rentalStartDate.toString(),
              )} - ${FormatUtil.formatToDayMonthYear(
                contract.rentalEndDate.toString(),
              )}",
              style: ConstantFont.regularText.copyWith(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return AppColors.yellow;
      case 'APPROVED':
        return AppColors.green;
      case 'REJECTED':
        return AppColors.red;
      default:
        return AppColors.yellow;
    }
  }
}
