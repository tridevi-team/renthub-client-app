import 'dart:convert';

import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/bill_model.dart';
import 'package:rent_house/services/bill_service.dart';
import 'package:rent_house/ui/account/payment/status/payment_result.dart';
import 'package:rent_house/ui/webview/webview_screen.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/dialog_util.dart';
import 'package:rent_house/utils/response_error_util.dart';

class PaymentController extends BaseController {
  BillModel? bill;
  String billId = "";
  int isRepresent = 0;
  RxBool isCheckout = false.obs;

  @override
  void onInit() {
    billId = Get.arguments['billId'];
    isRepresent = UserSingleton.instance.getUser().represent ?? 0;
    getBillDetails();
    super.onInit();
  }

  Future<void> getBillDetails() async {
    try {
      viewState.value = ViewState.loading;
      final response = await BillService.fetchBillDetail(billId);
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        bill = BillModel.fromJson(decodedResponse['data']);
        checkCheckoutStatus();
        viewState.value = ViewState.complete;
        return;
      }
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
    } catch (e) {
      viewState.value = ViewState.notFound;
      AppUtil.printDebugMode(type: "bill detail", message: "$e");
    }
  }

  void checkCheckoutStatus() {
    if (bill?.status == "PAID" || bill?.status == "CANCELLED") {
      isCheckout.value = false;
      return;
    }
    if (isRepresent == 0) {
      isCheckout.value = false;
      return;
    }
    isCheckout.value = true;
  }

  String getImageUrlBank() {
    String bank = bill?.bankName?.replaceAll(" ", "").toLowerCase() ?? "";
    String appLogo = ConstantString.bankApps.firstWhere(
          (bankApp) => bankApp["appName"]?.replaceAll(" ", "").toLowerCase().contains(bank),
          orElse: () => {},
        )["appLogo"] ??
        "";
    return appLogo;
  }

  Future<void> checkout() async {
    DialogUtil.showLoading();
    try {
      final response = await BillService.createPaymentLink({"billId": billId});
      DialogUtil.hideLoading();

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final paymentUrl = decodedResponse["data"]["paymentUrl"];

        viewState.value = ViewState.complete;

        final paymentResult = await Get.to(() => WebViewScreen(title: "Thanh toán", url: paymentUrl));

        await _handlePaymentResult(paymentResult);
      } else {
        ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      }
    } catch (e) {
      DialogUtil.hideLoading();
      AppUtil.printDebugMode(type: "checkout", message: "$e");
    }
  }

  Future<void> _handlePaymentResult(String? result) async {
    switch (result) {
      case "PAID":
      case "PROCESSING":
        await Get.to(() => const PaymentResult(
              isSuccess: true,
              mainText: "Thanh toán thành công",
              subText: "Thanh toán thành công. Bạn có thể xem hóa đơn hoặc điều hướng về màn hình chính.",
            ));
        await getBillDetails();
        break;

      case "CANCELLED":
        await Get.to(() => const PaymentResult(
              isSuccess: false,
              mainText: "Thanh toán thất bại",
              subText: "Có lỗi xảy ra. Vui lòng không hủy thanh toán và thực hiện thanh toán lại",
            ))?.then((repayment) async {
          if (!repayment) return;
          await checkout();
        });
        break;

      default:
        AppUtil.printDebugMode(type: "checkout", message: "Unhandled payment result: $result");
    }
  }
}
