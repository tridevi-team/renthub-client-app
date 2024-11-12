import 'dart:convert';

import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/services/notification_service.dart';
import 'package:rent_house/untils/toast_until.dart';

class NotificationController extends BaseController {
  RxInt notificationsCount = 0.obs;

  Future<void> getNotificationsCount() async {
    try {
      viewState.value = ViewState.loading;
      final response = await NotificationService.fetchNotificationCount();
      if (response.statusCode != 200) {
        viewState.value = ViewState.error;
        return;
      }
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      notificationsCount.value = decodedResponse["data"]['unread'];
      viewState.value = ViewState.complete;
    } catch (e) {
      viewState.value = ViewState.error;
      ToastUntil.toastNotification(description: 'Có lỗi xảy ra. Vui lòng thử lại.', status: ToastStatus.error);
    }
  }
}
