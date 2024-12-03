import 'dart:convert';

import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/bill_model.dart';
import 'package:rent_house/services/bill_service.dart';
import 'package:rent_house/utils/app_util.dart';
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

  Future<void> checkout() async {}
}
