import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/home/house_detail/house_detail_controller.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';

class RoomDetailScreen extends StatelessWidget {
  RoomDetailScreen({super.key});

  final HouseDetailController controller = Get.find<HouseDetailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(isShared: true),
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CachedNetworkImage(
              imageUrl: controller.selectedRoom.images?[0].imageUrl ?? '',
              placeholder: (context, url) => Image.asset('assets/images/image.png',
                  width: Get.width, height: 200, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(controller.selectedRoom.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: ConstantFont.boldText.copyWith(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('${controller.selectedRoom.price}',
                      style: ConstantFont.mediumText.copyWith(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Đống Đa, Hà Nội',
                      maxLines: 2, overflow: TextOverflow.ellipsis, style: ConstantFont.lightText),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SvgPicture.asset(AssetSvg.iconLocation,
                          width: 18, height: 18, color: AppColors.primary1),
                      const SizedBox(width: 4),
                      Text(
                        'Xem trên bản đồ',
                        style: ConstantFont.regularText.copyWith(color: AppColors.primary1),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: Container(color: AppColors.neutralF5F5F5, height: 5)),
          SliverToBoxAdapter(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Thông tin chi tiết', style: ConstantFont.boldText.copyWith(fontSize: 18)),
                const SizedBox(height: 10),
                ExpandablePanel(
                  theme: const ExpandableThemeData(
                    hasIcon: false,
                    tapBodyToExpand: true,
                    tapBodyToCollapse: true,
                  ),
                  controller: controller.expandableController,
                  collapsed: Text(
                    controller.selectedRoom.description ?? '',
                    softWrap: true,
                    maxLines: 5,
                    textDirection: TextDirection.ltr,
                    overflow: TextOverflow.ellipsis,
                    style: ConstantFont.regularText,
                  ),
                  expanded: Text(
                    controller.selectedRoom.description ?? '',
                    softWrap: true,
                    style: ConstantFont.regularText,
                    textDirection: TextDirection.ltr,
                  ),
                  builder: (_, collapsed, expanded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        collapsed,
                        ExpandableButton(
                          child: Row(
                            children: [
                              Text(
                                controller.expandableController.expanded ? 'Ẩn bớt' : 'Xem thêm',
                                style: ConstantFont.regularText.copyWith(color: AppColors.primary1),
                              ),
                              Icon(
                                controller.expandableController.expanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: AppColors.primary1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: AppColors.neutralF5F5F5),
                const SizedBox(height: 20),
                Text('Ảnh căn phòng', style: ConstantFont.semiBoldText.copyWith(fontSize: 16)),
                const SizedBox(height: 20),
                if (controller.selectedRoom.images != null &&
                    controller.selectedRoom.images!.isNotEmpty)
                  CarouselSlider(
                      items: controller.selectedRoom.images?.map((image) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                              imageUrl: image.imageUrl ?? '',
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 150,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        viewportFraction: 0.8,
                        aspectRatio: 16 / 9,
                      ))
                else
                  const SizedBox.shrink()
              ],
            ),
          )),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        shadowColor: AppColors.neutral9E9E9E,
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.green,
              ),
              child: SvgPicture.asset(AssetSvg.iconCall, color: AppColors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primary1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AssetSvg.iconHome, width: 24, color: AppColors.white),
                    const SizedBox(width: 10),
                    Text(
                      'Đăng ký nhận thông tin',
                      style: ConstantFont.mediumText.copyWith(color: AppColors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
