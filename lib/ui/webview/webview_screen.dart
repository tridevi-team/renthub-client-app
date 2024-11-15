import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/ui/webview/webview_controller.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  WebViewScreen({super.key, this.title = 'Tin tức', required this.url});

  final controller = Get.put(WebViewInAppController());
  final String? title;
  final String url;

  @override
  Widget build(BuildContext context) {
    controller.url = url;
    return Scaffold(
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
    );
  }

  Widget _buildWebView() {
    return WebViewWidget(
      controller: controller.webViewController ?? WebViewController(),
    );
  }
}
