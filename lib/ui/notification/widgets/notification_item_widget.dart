import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/notification_model.dart';
import 'package:rent_house/ui/notification/notification_controller.dart';
import 'package:rent_house/utils/dialog_util.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/widgets/images/common_network_image.dart';

class NotificationItemWidget extends StatelessWidget {
  const NotificationItemWidget(
      {super.key, required this.notification, required this.removeNotification});

  final NotificationItem notification;
  final void Function() removeNotification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, top: 10, right: 14),
      child: Dismissible(
          key: ValueKey(notification.id),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 10),
            color: Colors.white,
            child: SvgPicture.asset(AssetSvg.iconTrash),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (DismissDirection direction) async {
            if (direction == DismissDirection.startToEnd) {
              return false;
            } else if (direction == DismissDirection.endToStart) {
              DialogUtil.showDialogConfirm(
                  title: "Xóa thông báo",
                  text: "Bạn muốn xóa thông báo ${notification.title} ?",
                  onClose: () {
                    direction = DismissDirection.startToEnd;
                    Get.back();
                  },
                  onConfirm: removeNotification);
            }
            return false;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.neutralF5F5F5,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonNetworkImage(imageUrl: notification.imageUrl),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${notification.title}",
                            style: ConstantFont.boldText
                                .copyWith(color: AppColors.primary1, fontSize: 14),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${notification.content}",
                            style: ConstantFont.regularText.copyWith(fontSize: 12),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              FormatUtil.formatToDayMonthYearTime(
                                  notification.createdAt.toString()),
                              style: ConstantFont.regularText.copyWith(fontSize: 12),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Obx(() {
                  if (Get.find<NotificationController>().notificationsCount.value >= 0 &&
                      !notification.isRead) {
                    return Positioned(
                      right: 2,
                      top: 0,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                            color: AppColors.red, borderRadius: BorderRadius.circular(50)),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                })
              ],
            ),
          )),
    );
  }
}
