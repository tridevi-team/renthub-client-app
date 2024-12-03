import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/models/bill_model.dart';
import 'package:rent_house/ui/account/payment/checkout/payment_screen.dart';
import 'package:rent_house/ui/account/payment/payment_history_controller.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:rent_house/widgets/errors/network_error_widget.dart';
import 'package:rent_house/widgets/loading/loading_widget.dart';
import 'package:rent_house/widgets/refresh/smart_refresh.dart';

class PaymentHistoryScreen extends StatelessWidget {
  PaymentHistoryScreen({super.key});

  final controller = Get.put(PaymentHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(label: "Lịch sử thanh toán"),
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
                    : _buildPaymentHistoryList(),
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
      controller: controller.paymentTabController,
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

  Widget _buildPaymentHistoryList() {
    return SmartRefreshWidget(
      controller: controller.paymentRefreshCtrl,
      scrollController: ScrollController(),
      onRefresh: () async {

      },
      onLoadingMore: () {

      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.bills.length,
        itemBuilder: (_, index) => _buildPaymentHistoryWidget(controller.bills[index]),
      ),
    );
  }

  Widget _buildPaymentHistoryWidget(BillModel bill) {
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
                "${bill.title}",
                style: ConstantFont.mediumText,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => PaymentScreen(), arguments: {"billId": bill.id});
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
                      text: FormatUtil.formatToDayMonthYearTime(bill.createdAt.toString()),
                      style: ConstantFont.mediumText.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              text: 'Thanh toán: ',
              style: ConstantFont.mediumText
                  .copyWith(color: AppColors.neutralCCCAC6, fontSize: 12),
              children: [
                TextSpan(
                  text: FormatUtil.formatCurrency(bill.amount ?? 0),
                  style: ConstantFont.mediumText.copyWith(
                      fontSize: 12,
                      color: AppColors.red
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
