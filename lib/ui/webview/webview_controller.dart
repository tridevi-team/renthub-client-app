import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewInAppController extends BaseController {
  WebViewController? webViewController;
  String url = "";
  RxBool isLoading = true.obs;
  RxDouble progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
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
      webViewController?.loadRequest(Uri.parse(url));
    });
  }

}