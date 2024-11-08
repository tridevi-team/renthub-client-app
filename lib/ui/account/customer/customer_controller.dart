import 'dart:convert';
import 'dart:developer';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/response_model.dart';
import 'package:rent_house/models/user_model.dart';
import 'package:rent_house/services/customer_service.dart';
import 'package:rent_house/untils/toast_until.dart';

class CustomerController extends BaseController {
  String version = '';
  UserModel? user;

  @override
  void onInit() {
    super.onInit();
    user = UserSingleton.instance.getUser();
    getCurrentVersion();
  }

  Future<void> getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  Future<void> getCustomerInfo() async {
    try {
      final response = await CustomerService.getCustomerInfo();
      if (response.statusCode != 200) {
        return;
      }
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      UserModel userModel = UserModel.fromJson(decodedResponse['data']);
      UserSingleton.instance.setUser(userModel);
    } catch (e) {
      ToastUntil.toastNotification(description: "Có lỗi xảy ra. Vui lòng thử lại.", status: ToastStatus.error);
      log("Error fetch: $e");
    }
  }
}