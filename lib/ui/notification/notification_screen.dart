import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/models/notification_model.dart';
import 'package:rent_house/ui/notification/notification_controller.dart';
import 'package:rent_house/ui/notification/widgets/notification_item_widget.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:rent_house/widgets/refresh/smart_refresh.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: "Thông báo",
      ),
      backgroundColor: AppColors.white,
      body: Obx(
        () => controller.viewState.value == ViewState.loading
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary1),
                ),
              )
            : SmartRefreshWidget(
                controller: controller.refreshCtrl,
                scrollController: controller.scrollCtrl,
                onRefresh: controller.refreshData,
                onLoadingMore: controller.loadMoreData,
                child: controller.notifications.isEmpty
                    ? const SizedBox.shrink()
                    : CustomScrollView(
                        physics: const ClampingScrollPhysics(),
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              addAutomaticKeepAlives: false,
                              (BuildContext context, int index) {
                                NotificationItem notificationItem = controller.notifications[index];
                                return NotificationItemWidget(
                                    notification: notificationItem,
                                    removeNotification: () {
                                      controller.removeNotification(index);
                                    });
                              },
                              childCount: controller.notifications.length,
                            ),
                          )
                        ],
                      ),
              ),
      ),
    );
  }
}
