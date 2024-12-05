import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewInAppController extends BaseController {
  WebViewController? webViewController;
  String? url;
  String? htmlContent;
  RxBool isLoading = true.obs;
  RxDouble progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();
    String userAgent = Platform.isAndroid ? "Android" : "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1";
    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setUserAgent(userAgent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progressValue) {
            progress.value = (progressValue / 100);
            isLoading.value = progressValue < 100;
          },
          onPageStarted: (String url) {
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            isLoading.value = false;
            progress.value = 0;
          },
          onWebResourceError: (WebResourceError error) {
            isLoading.value = false;
            progress.value = 0;
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('appvne://openapp') || request.url.contains('fr.playsoft.vnexpress')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    webViewController = controller;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (htmlContent != null) {
        webViewController?.loadHtmlString('''
        <!DOCTYPE html>
        <html lang="vi">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <body>
            $htmlContent
          </body>
        </html>''');
      } else {
        webViewController?.loadRequest(Uri.parse(url ?? ''));
      }
    });
  }
}
