import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/models/notification_model.dart';
import 'package:rent_house/services/notification_service.dart';
import 'package:rent_house/ui/account/customer_issue/detail_issue/detail_issue_screen.dart';
import 'package:rent_house/ui/account/payment/checkout/payment_screen.dart';
import 'package:rent_house/ui/webview/webview_screen.dart';
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
      final response = await NotificationService.fetchNotificationCount();
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      if (response.statusCode < 300) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        notificationsCount.value = decodedResponse["data"]['unread'];
        viewState.value = ViewState.complete;
        refreshCtrl.loadComplete();
      }
    } catch (e) {
      viewState.value = ViewState.notFound;
      ToastUntil.toastNotification(description: ConstantString.tryAgainMessage, status: ToastStatus.error);
    }
  }

  Future<void> getAllNotifications({bool isLoadMore = false}) async {
    viewState.value = ViewState.init;
    try {
      if (isLoadMore == false) {
        viewState.value = ViewState.loading;
        currentPage = 1;
        notifications.clear();
      }
      String sort = '''{
       "field": "notifications.createdAt",
          "direction": "asc"
        }''';
      final response = await NotificationService.getAllNotifications(sort: sort, page: currentPage);
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode, );
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if ((decodedResponse["data"]["results"] as List).isEmpty) {
        if (isLoadMore) {
          viewState.value = ViewState.noData;
        }
        viewState.value = ViewState.complete;
        refreshCtrl.loadNoData();
        return;
      }
      if (response.statusCode < 300) {
        NotificationModel notificationModel = NotificationModel.fromJson(decodedResponse["data"]);
        totalPage = notificationModel.page ?? 1;
        notifications.addAll(notificationModel.results ?? []);
        await getNotificationsCount();

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
        notifications.removeAt(index);
        ToastUntil.toastNotification(description: 'Xóa thông báo thành công', status: ToastStatus.success);
      } else {
        ToastUntil.toastNotification(description: 'Có lỗi xảy ra. Xóa thông báo thất bại.', status: ToastStatus.error);
      }
    } catch (e) {
      ToastUntil.toastNotification(description: ConstantString.tryAgainMessage, status: ToastStatus.error);
    }
  }

  Future<void> markAsReadNotification(int index) async {
    if (notifications[index].isRead) return;
    try {
      final params = {
        "ids": [notifications[index].id.toString()],
        "status": "read"
      };
      final response = await NotificationService.markNotificationAsRead(params);
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        refreshCtrl.loadComplete();
        if (decodedResponse['success']) {
          notifications[index].status = "read";
          if (notificationsCount.value > 0) {
            notificationsCount.value -= 1;
          } else {
            notificationsCount.value = 0;
          }
        }
      }
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
    } catch (e) {
      AppUtil.printDebugMode(type: "MarkAsReadNotification", message: '$e');
    }
  }

  void viewNotification(int index) {
    final notification = notifications[index];
    final data = notification.data;


    if (isValid(data?['billId'])) {
      Get.to(() => PaymentScreen(), arguments: {"billId": data?['billId']});
      return;
    } else if (isValid(data?['issueId'])) {
      Get.to(() => DetailIssueScreen(), arguments: {"issueId": data?['issueId']});
      return;
    } else if (isValid(data?[''])) {
      Get.to(() => WebViewScreen(), arguments: {"contractId": data?['contractId']});
    }
  }

  bool isValid(String? value) => value != null && value.isNotEmpty;

  void refreshData() async {
    await getAllNotifications();
    refreshCtrl.requestRefresh();
  }

  void loadMoreData() {
      currentPage++;
      getAllNotifications(isLoadMore: true);
  }

  void resetNotificationCount() => notificationsCount.value = 0;
}
