import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/models/notification_model.dart';
import 'package:rent_house/ui/notification/notification_controller.dart';
import 'package:rent_house/ui/notification/widgets/notification_item_widget.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:rent_house/widgets/errors/network_error_widget.dart';
import 'package:rent_house/widgets/loading/loading_widget.dart';
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
        () {
          if (controller.viewState.value == ViewState.noData) {
            return Center(
              child: Text(
                'Bạn chưa có thông báo nào',
                style: ConstantFont.mediumText.copyWith(fontSize: 16),
              ),
            );
          } else if (controller.viewState.value == ViewState.loading) {
            return const LoadingWidget();
          } else if (controller.viewState.value == ViewState.complete || controller.viewState.value == ViewState.init) {
            return SmartRefreshWidget(
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
            );
          } else {
            return NetworkErrorWidget(
              viewState: controller.viewState.value,
              onRefresh: controller.refreshData,
            );
          }
        },
      ),
    );
  }
}
