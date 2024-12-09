import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/models/error_input_model.dart';
import 'package:rent_house/models/room_model.dart';
import 'package:rent_house/services/home_service.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/dialog_util.dart';
import 'package:rent_house/utils/toast_until.dart';
import 'package:rent_house/utils/validate_util.dart';
import 'package:url_launcher/url_launcher.dart';

class RoomDetailController extends BaseController {
  RxBool isExpanded = false.obs;
  String? roomId;
  TextEditingController fullNameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  final Rx<ErrorInputModel> fullNameError = ErrorInputModel().obs;
  final Rx<ErrorInputModel> phoneError = ErrorInputModel().obs;

  @override
  void dispose() {
    fullNameCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  void makePhoneCall(String phone) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  Map<String, dynamic> getRoomStatusIconPath(String status) {
    String path = AssetSvg.iconOccupied;
    String description = "Đã cho thuê";
    Color color = AppColors.green;
    if (status == ConstantString.statusMaintain || status == ConstantString.statusPending) {
      path = AssetSvg.iconMaintain;
      description = "Đang bảo trì";
      color = AppColors.yellow;
    } else if (status == ConstantString.statusExpired) {
      path = AssetSvg.iconNotAvailable;
      description = "Không có sẵn";
      color = AppColors.red;
    } else if (status == ConstantString.statusAvailable) {
      path = AssetSvg.iconRent;
      description = "Đang có sẵn";
      color = AppColors.green;
    }
    return {
      'path': path,
      'description': description,
      'color': color,
    };
  }

  void onChangeInput(String value, Rx<ErrorInputModel> errorObj, bool Function(String) validate, String requiredMessage, String invalidMessage) {
    if (value.isEmpty) {
      _setError(errorObj, requiredMessage);
    } else if (validate(value)) {
      _clearError(errorObj);
    } else {
      _setError(errorObj, invalidMessage);
    }
  }

  void _setError(Rx<ErrorInputModel> errorObj, String message) {
    errorObj.value.isError = true;
    errorObj.value.message = message;
  }

  void _clearError(Rx<ErrorInputModel> errorObj) {
    errorObj.value.isError = false;
    errorObj.value.message = "";
  }

  void onChangeFullNameInput(String value) {
    onChangeInput(
      value,
      fullNameError,
      ValidateUtil.isValidName,
      "Đây là trường bắt buộc",
      "Dữ liệu nhập vào của bạn không đúng định dạng, vui lòng kiểm tra lại",
    );
  }

  void onChangePhoneInput(String value) {
    onChangeInput(
      value,
      phoneError,
      ValidateUtil.isValidPhone,
      "Đây là trường bắt buộc",
      "Dữ liệu nhập vào của bạn không đúng định dạng, vui lòng kiểm tra lại",
    );
  }

  Future<void> receiveRoomInformation() async {
    if (fullNameError.value.isError || phoneError.value.isError) return;

    try {
      DialogUtil.showLoading();
      final body = {'roomId': roomId, "fullName": fullNameCtrl.text, "phoneNumber": phoneCtrl.text};
      final response = await HomeService.signUpReceiveRoomInformation(body);
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (decodedResponse["code"] == "SIGNUP_RECORD_ALREADY_EXISTS") {
        ToastUntil.toastNotification(
          description: "Bạn đã đăng ký nhận thông tin này rồi. Vui lòng chờ thông tin từ quản lý.",
          status: ToastStatus.warning,
        );
        Get.close(1);
        return;
      }
      if (response.statusCode == 200) {
        ToastUntil.toastNotification(description: "Đăng ký thành công", status: ToastStatus.success);
        Get.close(1);
      } else {
        ToastUntil.toastNotification(description: ConstantString.tryAgainMessage, status: ToastStatus.error);
      }
      DialogUtil.hideLoading();
    } catch (e) {
      DialogUtil.hideLoading();
      AppUtil.printDebugMode(type: 'Receive Room Info', message: "$e");
    }
  }
}
