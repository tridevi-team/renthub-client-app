import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/user_model.dart';
import 'package:rent_house/ui/account/customer_info/nfc_screen.dart';
import 'package:rent_house/ui/qr_scan/qr_scan_screen.dart';
import 'package:rent_house/untils/dialog_util.dart';
import 'package:rent_house/untils/format_util.dart';
import 'package:rent_house/untils/toast_until.dart';

class CustomerInfoController extends BaseController {
  TextEditingController citizenIdCtrl = TextEditingController();
  TextEditingController fullNameCtrl = TextEditingController();
  TextEditingController dateOfBirthCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  RxBool isVisible = true.obs;
  UserModel user = UserSingleton.instance.getUser();

  @override
  void onInit() {
    citizenIdCtrl.text = user.citizenId ?? '';
    fullNameCtrl.text = user.name ?? '';
    dateOfBirthCtrl.text = FormatUtil.formatToDayMonthYear(user.birthday) ?? '';
    addressCtrl.text = user.address.toString() ?? '';
    super.onInit();
  }

  void useNFC() {
    Get.to(() => const NfcScreen());
  }

  Future<void> useScanQR() async {
    final scannedData = await Get.to(() => QrScanScreen());

    if (scannedData == null) {
      return;
    }

    List<String> parts = scannedData.split("||");
    if (parts.length < 2) {
      ToastUntil.toastNotification(description: 'Dữ liệu được quét không đầy đủ', status: ToastStatus.error);
      return;
    }

    citizenIdCtrl.text = parts[0];

    List<String> infoParts = parts[1].split("|");

    fullNameCtrl.text = infoParts.isNotEmpty ? infoParts[0] : "Tên không rõ";
    dateOfBirthCtrl.text = infoParts.length > 1 ? infoParts[1] : "Ngày sinh không rõ";
    addressCtrl.text = infoParts.length > 2 ? infoParts[2] : "Địa chỉ không xác định";

    isVisible.value = false;
    isVisible.value = true;
  }

  void confirmResidenceRegistration({int? closeDialogRoute = 1}) {
    if (user.tempReg == 1) {
      return;
    }
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
}