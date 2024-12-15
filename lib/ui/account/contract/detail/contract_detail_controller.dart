import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/models/contract_model.dart';
import 'package:rent_house/services/contract_service.dart';
import 'package:rent_house/ui/account/contract/contract_controller.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/dialog_util.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/utils/response_error_util.dart';
import 'package:rent_house/utils/toast_until.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContractDetailController extends BaseController {
  WebViewController? webViewController;
  String statusPayment = "PENDING";
  String htmlContent = '';
  Map<String, dynamic> keys = {};
  Rx<ContractModel> contract = ContractModel().obs;

  @override
  void onInit() async {
    super.onInit();
    String contractId = Get.arguments["contractId"];
    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();
    String userAgent = Platform.isAndroid
        ? "Android"
        : "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1";

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setUserAgent(userAgent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progressValue) {},
          onNavigationRequest: (NavigationRequest request) async {
            return NavigationDecision.navigate;
          },
        ),
      );

    webViewController = controller;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await getContractDetail(contractId);
        await webViewController?.loadHtmlString('''
          <!DOCTYPE html>
          <html lang="vi">
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
            <body>
              $htmlContent
            </body>
          </html>''');
      },
    );
  }

  Future<void> getContractDetail(String contractId) async {
    try {
      DialogUtil.showLoading();
      final response = await ContractService.getContractDetail(contractId: contractId);
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        contract.value = ContractModel.fromJson(decodedResponse["data"]["contract"]);
        keys = decodedResponse["data"]["keys"];
        htmlContent = replaceKeyHtml(decodedResponse["data"]["contract"]["content"]);
      }
      DialogUtil.hideLoading();
    } catch (e) {
      DialogUtil.hideLoading();
      AppUtil.printDebugMode(type: 'Contract detail', message: "$e");
    }
  }

  String replaceKeyHtml(String content) {
    keys.forEach((key, value) {
      if (key == "EQUIPMENT_LIST") {
        value = contract.value.equipment != null
            ? '''
        <table border="1" style="border-collapse: collapse; width: 100%;">
          <thead>
            <tr>
              <th style="text-align: left; padding: 8px;">Tên thiết bị</th>
              <th style="text-align: left; padding: 8px;">Số lượng</th>
              <th style="text-align: left; padding: 8px;">Trạng thái</th>
            </tr>
          </thead>
          <tbody>
            ${contract.value.equipment?.map((item) {
              String status = item.status == "NORMAL" ? "Bình thường" : "Hỏng";
              return '''
              <tr>
                <td style="text-align: left; padding: 8px;">${item.name}</td>
                <td style="text-align: left; padding: 8px;">x1</td>
                <td style="text-align: left; padding: 8px;">$status</td>
              </tr>
            ''';
        }).join('')}
          </tbody>
        </table>
      '''
            : '';
      } else if (key == "USE_SERVICES") {
        value = contract.value.services != null
            ? '''
        <table border="1" style="border-collapse: collapse; width: 100%;">
          <thead>
            <tr>
              <th style="text-align: left; padding: 8px;">Tên dịch vụ</th>
              <th style="text-align: left; padding: 8px;">Đơn giá</th>
            </tr>
          </thead>
          <tbody>
            ${contract.value.services?.map((service) => '''
              <tr>
                <td style="text-align: left; padding: 8px;">${service.name}</td>
                <td style="text-align: left; padding: 8px;">${FormatUtil.formatCurrency(service.unitPrice ?? 0)}</td>
              </tr>
            ''').join('')}
          </tbody>
        </table>
      '''
            : '';
      }

      content = content.replaceAll('{{$key}}', value.toString());
    });
    return content;
  }

  Future<void> updateStatusContract(String status) async {
    try {
      DialogUtil.showLoading();
      final response = await ContractService.updateContractStatus(
          contractId: contract.value.id ?? "", body: {"status": status});
      DialogUtil.hideLoading();
      if (response.statusCode == 200) {
        ToastUntil.toastNotification(
            description: "Cập nhật hợp đồng thành công", status: ToastStatus.success);
        Get.back();
        if (Get.isRegistered<CustomerContractController>()) {
          Get.find<CustomerContractController>().changeTab(1);
        }
        return;
      }
      ToastUntil.toastNotification(
          description: "Cập nhật hợp đồng thất bại. Vui lòng thử lại.", status: ToastStatus.error);
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
    } catch (e) {
      DialogUtil.hideLoading();
      AppUtil.printDebugMode(type: 'Contract Update Error', message: "$e");
    }
  }
}
