import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/ui/account/payment/checkout/payment_controller.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/widgets/buttons/custom_elevated_button.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:rent_house/widgets/errors/network_error_widget.dart';
import 'package:rent_house/widgets/images/error_image_widget.dart';
import 'package:rent_house/widgets/loading/loading_widget.dart';
import 'package:shimmer/shimmer.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});

  final controller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(label: "Chi tiết hóa đơn"),
      backgroundColor: AppColors.white,
      body: Obx(
        () {
          if (controller.viewState.value == ViewState.loading) {
            return const LoadingWidget();
          } else if (controller.viewState.value == ViewState.complete || controller.viewState.value == ViewState.init) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${controller.bill?.title}",
                            style: ConstantFont.semiBoldText.copyWith(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 4),
                        _buildStatus()
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Thời gian: ${FormatUtil.formatToDayMonthYear(controller.bill?.startDate)} - ${FormatUtil.formatToDayMonthYear(controller.bill?.endDate)}",
                      style: ConstantFont.regularText,
                    ),
                    const SizedBox(height: 10),
                    if (controller.bill?.status == "PAID") ...[
                      Text(
                        "Đã thanh toán: ${FormatUtil.formatToDayMonthYearTime(controller.bill?.paymentDate)}",
                        style: ConstantFont.regularText,
                      ),
                    ],
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: AppColors.neutralE9e9e9),
                    const SizedBox(height: 20),
                    Text(
                      "Tài khoản người nhận",
                      style: ConstantFont.semiBoldText,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: const Border.fromBorderSide(
                          BorderSide(
                            width: 1,
                            color: AppColors.neutralE9e9e9,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Chủ tài khoản: ${controller.bill?.accountName}", style: ConstantFont.regularText),
                                const SizedBox(height: 6),
                                Text("Số tài khoản: ${controller.bill?.accountNumber}", style: ConstantFont.regularText),
                                const SizedBox(height: 6),
                                Text("Ngân hàng: ${controller.bill?.bankName}", style: ConstantFont.regularText),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              controller.getImageUrlBank(),
                              fit: BoxFit.cover,
                              height: 60,
                              width: 60,
                              loadingBuilder: (_, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Shimmer.fromColors(
                                    baseColor: AppColors.neutralF0F0F0,
                                    highlightColor: AppColors.shimmerColor,
                                    child: Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.white,
                                ));
                              },
                              errorBuilder: (_, __, ___) => const ErrorImageWidget(
                                height: 60,
                                width: 60,
                                imagePath: AssetSvg.imgLogoApp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Chi tiết",
                      style: ConstantFont.semiBoldText,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: const Border.fromBorderSide(
                          BorderSide(
                            width: 1,
                            color: AppColors.neutralE9e9e9,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.bill?.services?.map((service) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${service.name} x${service.amount}",
                                        style: ConstantFont.regularText,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      FormatUtil.formatCurrency(service.unitPrice ?? 0),
                                      style: ConstantFont.regularText.copyWith(color: AppColors.red),
                                    ),
                                    if (service.oldValue != null && service.oldValue! >= 0 && service.newValue != null && service.newValue! > 0) ...[
                                      Text(
                                        "Chỉ số cũ: ${FormatUtil.formatCurrency(service.oldValue!)}",
                                        style: ConstantFont.regularText,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Chỉ số mới: ${FormatUtil.formatCurrency(service.newValue!)}",
                                        style: ConstantFont.regularText,
                                      ),
                                    ]
                                  ],
                                ),
                              );
                            }).toList() ??
                            [],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng thanh toán: ',
                            style: ConstantFont.semiBoldText,
                          ),
                          Text(
                            FormatUtil.formatCurrency(controller.bill?.amount ?? 0),
                            style: ConstantFont.semiBoldText,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return NetworkErrorWidget(
              viewState: controller.viewState.value,
            );
          }
        },
      ),
      bottomNavigationBar: Obx(() => controller.isCheckout.value
          ? Container(
              padding: const EdgeInsets.all(10),
              child: CustomElevatedButton(
                label: "Thanh toán",
                isReverse: true,
                onTap: controller.checkout,
              ),
            )
          : const SizedBox()),
    );
  }

  Widget _buildStatus() {
    String statusName = "";
    Color color = AppColors.primary1;
    switch (controller.bill?.status) {
      case "PAID":
        statusName = "Đã thanh toán";
        color = AppColors.green;
      case "UNPAID":
        statusName = "Chưa thanh toán";
        color = AppColors.blue;
      case "IN_DEBT":
        statusName = "Đang nợ";
        color = AppColors.yellow;
      case "OVERDUE":
        statusName = "Quá hạn";
        color = AppColors.orange;
      case "CANCELLED":
        statusName = "Đã hủy";
        color = AppColors.red;
      default:
        statusName = "Không xác định";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color,
      ),
      child: Text(
        statusName,
        style: ConstantFont.regularText.copyWith(color: AppColors.white, fontSize: 12),
      ),
    );
  }
}
