import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  final bool noti;
  final double? elevationDouble;
  final VoidCallback? onTap;
  final VoidCallback? onTapShare;
  final VoidCallback? onBack;
  final bool isShared;
  final bool isTransparent;
  final PreferredSizeWidget? bottomWidget;

  const CustomAppBar({
    super.key,
    this.label = "",
    this.noti = false,
    this.elevationDouble,
    this.onTap,
    this.onTapShare,
    this.isShared = false,
    this.isTransparent = false,
    this.bottomWidget,
    this.onBack,
  });

  Widget _buildIconButton({required String iconAsset, VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: isTransparent ? const EdgeInsets.all(6) : EdgeInsets.zero,
        decoration: isTransparent
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              )
            : null,
        child: SvgPicture.asset(
          iconAsset,
          color: isTransparent ? null : AppColors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: elevationDouble ?? 10,
      forceMaterialTransparency: isTransparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildIconButton(iconAsset: AssetSvg.iconChevronBack, onPressed: onBack ?? Get.back),
          const SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                label,
                style: ConstantFont.boldText.copyWith(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (noti)
          _buildIconButton(
            iconAsset: AssetSvg.iconNotification,
            onPressed: onTap,
          ),
        if (isShared)
          _buildIconButton(
            iconAsset: AssetSvg.iconShare,
            onPressed: onTapShare,
          ),
        SizedBox(width: isShared || noti ? 20 : 34)
      ],
      bottom: bottomWidget,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
