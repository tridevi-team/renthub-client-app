import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/ui/webview/webview_controller.dart';
import 'package:rent_house/widgets/buttons/custom_elevated_button.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  WebViewScreen({
    super.key,
    this.title = 'Tin tức',
    this.url,
    this.htmlContent,
    this.statusContract, this.onTap,
  });

  final controller = Get.put(WebViewInAppController());
  final String? title;
  final String? url;
  final String? htmlContent;
  final String? statusContract;
  final void Function(String status)? onTap;

  @override
  Widget build(BuildContext context) {
    controller.url = url;
    controller.htmlContent = htmlContent;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        label: title ?? '',
        bottomWidget: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Obx(() {
            return controller.isLoading.value
                ? LinearProgressIndicator(
                    value: controller.progress.value,
                    backgroundColor: Colors.grey[200],
                    color: Colors.blueAccent,
                  )
                : const SizedBox.shrink();
          }),
        ),
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Platform.isAndroid ? _buildWebView() : WebViewWidget(controller: controller.webViewController ?? WebViewController()),
      ),
      bottomNavigationBar: (statusContract != null && statusContract == "PENDING") ? _buildBottomNavBar() : null,
    );
  }

  Widget _buildWebView() {
    return WebViewWidget(
      controller: controller.webViewController ?? WebViewController(),
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
                  onTap?.call("REJECTED");
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomElevatedButton(
                label: 'Xác nhận ký',
                isReverse: true,
                onTap: () {
                  onTap?.call("APPROVED");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
