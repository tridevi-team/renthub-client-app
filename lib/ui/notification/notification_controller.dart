import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/models/notification_model.dart';
import 'package:rent_house/services/notification_service.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/response_error_util.dart';
import 'package:rent_house/utils/toast_until.dart';

class NotificationController extends BaseController {
  RxInt notificationsCount = 0.obs;
  int currentPage = 1;
  int totalPage = 1;
  List<NotificationItem> notifications = [];
  RefreshController refreshCtrl = RefreshController();
  ScrollController scrollCtrl = ScrollController();

  Future<void> getNotificationsCount() async {
    try {
      viewState.value = ViewState.loading;
      final response = await NotificationService.fetchNotificationCount();
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      if (response.statusCode < 300) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        notificationsCount.value = decodedResponse["data"]['unread'];
        viewState.value = ViewState.complete;
      }
    } catch (e) {
      viewState.value = ViewState.notFound;
      ToastUntil.toastNotification(description: ConstantString.tryAgainMessage, status: ToastStatus.error);
    }
  }

  Future<void> getAllNotifications({bool isLoadMore = false}) async {
    try {
      if (isLoadMore == false) {
        currentPage = 1;
        notifications.clear();
      }
      viewState.value = ViewState.loading;
      String sort = '''{
       "field": "notifications.createdAt",
          "direction": "asc"
        }''';
      final response = await NotificationService.getAllNotifications(sort: sort, page: currentPage);
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode, );
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (decodedResponse["data"] == {}) {
        viewState.value = ViewState.noData;
        return;
      }
      if (response.statusCode < 300) {
        NotificationModel notificationModel = NotificationModel.fromJson(decodedResponse["data"]);
        totalPage = notificationModel.page ?? 1;
        notifications.addAll(notificationModel.results ?? []);
        await getNotificationsCount();
        viewState.value = ViewState.complete;
      }
    } catch (e) {
      viewState.value = ViewState.notFound;
      ToastUntil.toastNotification(description: ConstantString.tryAgainMessage, status: ToastStatus.error);
    }
  }

  Future<void> removeNotification(int index) async {
    if (index < 0 || index >= notifications.length) return;
    try {
      final params = {
        "ids": [notifications[index].id.toString()]
      };
      final response = await NotificationService.removeNotification(params);
      if (response.statusCode != 200) {
        ToastUntil.toastNotification(description: ConstantString.tryAgainMessage, status: ToastStatus.error);
        return;
      }
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      bool isSuccess = decodedResponse["success"];
      if (isSuccess) {
        ToastUntil.toastNotification(description: 'Xóa thông báo thành công', status: ToastStatus.success);
      } else {
        ToastUntil.toastNotification(description: 'Có lỗi xảy ra. Xóa thông báo thất bại.', status: ToastStatus.error);
      }
    } catch (e) {
      ToastUntil.toastNotification(description: ConstantString.tryAgainMessage, status: ToastStatus.error);
    }
  }

  Future<void> markAsReadNotification(int index) async {
    try {
      final params = {
        "ids": [notifications[index].id.toString()],
        "status": "read"
      };
      final response = await NotificationService.removeNotification(params);
      if (response.statusCode != 200) {
        return;
      }
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      AppUtil.printDebugMode(type: "MarkAsReadNotification", message: '$e');
    }
  }

  void refreshData() async {
    await getAllNotifications();
    refreshCtrl.requestRefresh();
  }

  void loadMoreData() {
    if (currentPage < totalPage) {
      currentPage++;
      getAllNotifications(isLoadMore: true);
    }
  }

  void resetNotificationCount() => notificationsCount.value = 0;
}
