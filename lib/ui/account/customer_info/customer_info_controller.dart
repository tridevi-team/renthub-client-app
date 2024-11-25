import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/address_model.dart';
import 'package:rent_house/models/user_model.dart';
import 'package:rent_house/services/customer_service.dart';
import 'package:rent_house/ui/account/customer_info/nfc_screen.dart';
import 'package:rent_house/ui/qr_scan/qr_scan_screen.dart';
import 'package:rent_house/untils/app_util.dart';
import 'package:rent_house/untils/dialog_util.dart';
import 'package:rent_house/untils/format_util.dart';
import 'package:rent_house/untils/response_error_util.dart';
import 'package:rent_house/untils/toast_until.dart';

class CustomerInfoController extends BaseController {
  TextEditingController citizenIdCtrl = TextEditingController();
  TextEditingController fullNameCtrl = TextEditingController();
  TextEditingController dateOfBirthCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  RxBool isVisible = true.obs;
  RxBool isEditInfo = false.obs;
  UserModel user = UserSingleton.instance.getUser();

  @override
  void onInit() {
    citizenIdCtrl.text = user.citizenId ?? '';
    fullNameCtrl.text = user.name ?? '';
    dateOfBirthCtrl.text = FormatUtil.formatToDayMonthYear(user.birthday);
    addressCtrl.text = user.address.toString();
    super.onInit();
  }

  void useNFC() {
    Get.to(() => const NfcScreen());
  }

  Future<void> useScanQR() async {
    final scannedData = await Get.to(() => QrScanScreen());

    if (scannedData == null || !scannedData.contains("||")) {
      ToastUntil.toastNotification(description: 'Dữ liệu không hợp lệ', status: ToastStatus.error);
      return;
    }

    final parts = scannedData.split("||");
    final infoParts = parts[1].split("|");

    citizenIdCtrl.text = parts[0];
    fullNameCtrl.text = infoParts.getOrDefault(0, "Tên không rõ");
    dateOfBirthCtrl.text = infoParts.getOrDefault(1, "Ngày sinh không rõ");
    addressCtrl.text = infoParts.getOrDefault(2, "Địa chỉ không xác định");

    isVisible.value = false;
    isVisible.value = true;
  }

  void confirmResidenceRegistration({int? closeDialogRoute = 1}) {
    if (user.tempReg == 1 || !isEditInfo.value) return;
    DialogUtil.showDialogConfirm(
      onConfirm: () {
        user.tempReg = 1;
        isVisible.value = false;
        isVisible.value = true;
        if (closeDialogRoute != null) {
          Get.close(closeDialogRoute);
        }
      },
      title: ConstantString.titleTempReg,
      text: ConstantString.descriptionTempReg,
    );
  }

  Future<void> updateCustomerInfo() async {
    try {
      final updatedUser = user.copyWith(
        name: fullNameCtrl.text,
        birthday: dateOfBirthCtrl.text,
        citizenId: citizenIdCtrl.text,
      );

      final response = await CustomerService.updateCustomerInfo(user.id ?? '', updatedUser.toJson());

      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);

      if (response.statusCode < 300) {
        user
          ..name = fullNameCtrl.text
          ..birthday = dateOfBirthCtrl.text
          ..citizenId = citizenIdCtrl.text;
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "Error updating customer", message: "$e");
    }
  }

  void onChangeBirthday(DateTime time) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(time);
    dateOfBirthCtrl.text = formattedDate;
    isVisible.value = false;
    isVisible.value = true;
  }


}