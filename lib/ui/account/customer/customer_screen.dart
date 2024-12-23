import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/account/contract/contract_screen.dart';
import 'package:rent_house/ui/account/customer/customer_controller.dart';
import 'package:rent_house/ui/account/customer_info/customer_info.dart';
import 'package:rent_house/ui/account/customer_issue/issue_tracking_screen.dart';
import 'package:rent_house/ui/account/payment/payment_history_screen.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_navigation_bar.dart';
import 'package:rent_house/ui/notification/notification_controller.dart';
import 'package:rent_house/ui/webview/webview_screen.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/widgets/avatar/avatar.dart';
import 'package:rent_house/widgets/images/common_network_image.dart';

class CustomerScreen extends StatelessWidget {
  CustomerScreen({super.key});

  final customerController = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: MediaQuery
            .of(context)
            .padding
            .top),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return InkWell(
                onTap: () {
                  Get.to(() => CustomerInfo());
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: CommonNetworkImage(
                    imageUrl: 'imageUrl',
                    height: 60,
                    width: 60,
                    errorWidget: AvatarWidget(name: customerController.nameUser.value),
                  ),
                  title: Text(
                    customerController.nameUser.value,
                    style: ConstantFont.boldText.copyWith(fontSize: 18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'Xem thông tin',
                    style: ConstantFont.regularText.copyWith(color: AppColors.neutral8F8D8A),
                  ),
                  trailing:
                  SvgPicture.asset(AssetSvg.iconChevronForward, color: AppColors.neutralCCCAC6),
                ),
              );
            }),
            const SizedBox(height: 10),
            const Divider(height: 1, color: AppColors.neutralF5F5F5),
            const SizedBox(height: 30),
            Text('Tổng quát', style: ConstantFont.boldText.copyWith(fontSize: 18)),
            const SizedBox(height: 10),
            _buildListTile(
                leadingAsset: AssetSvg.iconPerson,
                titleText: 'Hợp đồng phòng',
                trailingAsset: AssetSvg.iconChevronForward,
                onTap: () {
                  Get.to(() => CustomerContractScreen());
                }),
            _buildListTile(
                leadingAsset: AssetSvg.iconCard,
                titleText: 'Lịch sử thanh toán',
                trailingAsset: AssetSvg.iconChevronForward,
                onTap: () {
                  Get.to(() => PaymentHistoryScreen());
                }),
            _buildListTile(
              leadingAsset: AssetSvg.iconLock,
              titleText: 'Điều khoản',
              trailingAsset: AssetSvg.iconChevronForward,
            ),
            _buildListTile(
                leadingAsset: AssetSvg.iconLock,
                titleText: 'Chính sách bảo mật',
                trailingAsset: AssetSvg.iconChevronForward,
                onTap: () {
                  Get.to(() =>
                      WebViewScreen(title: "Chính sách bảo mật",
                          url:
                          "https://www.freeprivacypolicy.com/live/2ab662e0-312e-4350-8ed0-af2174976af4"));
                }),
            const SizedBox(height: 20),
            Text('Trung tâm trợ giúp', style: ConstantFont.boldText.copyWith(fontSize: 18)),
            const SizedBox(height: 10),
            _buildListTile(
                trailingAsset: AssetSvg.iconChevronForward,
                leadingAsset: AssetSvg.iconMailOpen,
                titleText: 'Quản lý phản ánh',
                onTap: () {
                  Get.to(() => IssueTrackingScreen());
                }),
            const SizedBox(height: 20),
            Text('Quản lý tài khoản', style: ConstantFont.boldText.copyWith(fontSize: 18)),
            const SizedBox(height: 10),
            _buildListTile(
                leadingAsset: AssetSvg.iconLogout,
                titleText: 'Đăng xuất',
                onTap: () async {
                  Get.find<NotificationController>().resetNotificationCount();
                  AppUtil.logout();
                  await Get.find<BottomNavBarController>().refreshData();
                  Get.offAll(() => BottomNavigationBarView(isCustomer: false));
                }),
            const Spacer(),
            Align(
                alignment: Alignment.center,
                child: Text(
                  'v${customerController.version}',
                  style: ConstantFont.regularText
                      .copyWith(fontSize: 14, color: AppColors.neutral545453),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String leadingAsset,
    required String titleText,
    String? trailingAsset,
    Color? color,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          leading: SvgPicture.asset(leadingAsset, color: color ?? Colors.black),
          title: Text(titleText,
              style: ConstantFont.regularText.copyWith(color: color ?? AppColors.black)),
          trailing: trailingAsset != null
              ? SvgPicture.asset(trailingAsset, color: AppColors.neutralCCCAC6)
              : null,
          onTap: onTap,
        ),
        const Divider(height: 1, color: AppColors.neutralF5F5F5),
      ],
    );
  }
}
