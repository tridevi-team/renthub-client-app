import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/ui/account/contract/detail/contract_detail_controller.dart';
import 'package:rent_house/widgets/buttons/custom_elevated_button.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContractDetailScreen extends StatelessWidget {
  ContractDetailScreen({super.key});

  final controller = Get.put(ContractDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(
          label: "Thông tin hợp đồng",
        ),
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Platform.isAndroid
              ? _buildWebView()
              : WebViewWidget(controller: controller.webViewController!),
        ),
        bottomNavigationBar: Obx(() => controller.contract.value.status == "PENDING"
            ? _buildBottomNavBar()
            : const SizedBox.shrink()));
  }

  Widget _buildWebView() {
    return WebViewWidget(
      controller: controller.webViewController!,
    );
  }

  Widget _buildBottomNavBar() {
    return Material(
      elevation: 10,
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(10),
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomElevatedButton(
                label: 'Hủy hợp đồng',
                textColor: AppColors.red,
                onTap: () {
                  controller.updateStatusContract("REJECTED");
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomElevatedButton(
                label: 'Xác nhận ký',
                isReverse: true,
                onTap: () {
                  controller.updateStatusContract("APPROVED");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
