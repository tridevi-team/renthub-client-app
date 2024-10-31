import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/account/customer/customer_controller.dart';
import 'package:rent_house/untils/app_util.dart';
import 'package:rent_house/widgets/avatar/avatar.dart';

class CustomerScreen extends StatelessWidget {
  CustomerScreen({super.key});

  final customerController = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: MediaQuery.of(context).padding.top),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: CachedNetworkImage(
                    imageUrl: 'imageUrl',
                    height: 60,
                    width: 60,
                    errorWidget: (context, url, error) => const AvatarWidget(lastName: 'Hoa'),
                  ),
                  title: Text(
                    'Lê Hòa',
                    style: ConstantFont.boldText.copyWith(fontSize: 18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'Show profile',
                    style: ConstantFont.regularText.copyWith(color: AppColors.neutral8F8D8A),
                  ),
                  trailing: SvgPicture.asset(AssetSvg.iconChevronForward, color: AppColors.neutralCCCAC6),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: AppColors.neutralE5E5E3),
                const SizedBox(height: 30),
                Text('Account settings', style: ConstantFont.boldText.copyWith(fontSize: 18)),
                const SizedBox(height: 10),
                _buildListTile(
                  leadingAsset: AssetSvg.iconPerson,
                  titleText: 'Personal Information',
                  trailingAsset: AssetSvg.iconChevronForward,
                ),
                _buildListTile(
                  leadingAsset: AssetSvg.iconPerson,
                  titleText: 'Payment method',
                  trailingAsset: AssetSvg.iconChevronForward,
                ),
                _buildListTile(
                  leadingAsset: AssetSvg.iconLock,
                  titleText: 'Privacy and sharing',
                  trailingAsset: AssetSvg.iconChevronForward,
                ),
                const SizedBox(height: 20),
                Text('Danger zone', style: ConstantFont.boldText.copyWith(fontSize: 18)),
                const SizedBox(height: 10),
                _buildListTile(
                  leadingAsset: AssetSvg.iconLogout,
                  titleText: 'Logout',
                  onTap: () async {
                    AppUtil.logout();
                  }
                ),
                _buildListTile(leadingAsset: AssetSvg.iconHand, titleText: 'Remove account', color: AppColors.red),
              ],
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  'v${customerController.version}',
                  style: ConstantFont.regularText.copyWith(fontSize: 14, color: AppColors.neutral545453),
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
          title: Text(titleText, style: ConstantFont.regularText.copyWith(color: color ?? AppColors.black)),
          trailing: trailingAsset != null ? SvgPicture.asset(trailingAsset, color: AppColors.neutralCCCAC6) : null,
          onTap: onTap,
        ),
        const Divider(height: 1, color: AppColors.neutralE5E5E3),
      ],
    );
  }
}
