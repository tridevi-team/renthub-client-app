import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/room_model.dart';
import 'package:rent_house/ui/home/room_detail/room_detail_controller.dart';
import 'package:rent_house/untils/format_util.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:rent_house/widgets/images/error_image_widget.dart';

class RoomDetailScreen extends StatelessWidget {
  RoomDetailScreen({super.key, required this.selectedRoom, this.address = ''});

  final controller = Get.put(RoomDetailController());
  final Room selectedRoom;
  final String? address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(isShared: true, isTransparent: true),
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          _buildRoomImage(),
          _buildRoomDetails(),
          _buildDivider(),
          _buildRoomInfo(),
        ],
      ),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildRoomImage() {
    return SliverToBoxAdapter(
      child: CachedNetworkImage(
        imageUrl: selectedRoom.images?.first.imageUrl ?? '',
        width: Get.width,
        height: 300,
        fit: BoxFit.cover,
         errorWidget: (_, __, ___) => const ErrorImageWidget(),
      ),
    );
  }

  Widget _buildRoomDetails() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedRoom.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: ConstantFont.boldText.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              FormatUtil.formatCurrency(selectedRoom.price ?? 0),
              style: ConstantFont.mediumText.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              address ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: ConstantFont.lightText,
            ),
            const SizedBox(height: 10),
            _buildMapLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapLink() {
    return Row(
      children: [
        SvgPicture.asset(
          AssetSvg.iconLocation,
          width: 18,
          height: 18,
          color: AppColors.primary1,
        ),
        const SizedBox(width: 4),
        Text(
          'Xem trên bản đồ',
          style: ConstantFont.regularText.copyWith(color: AppColors.primary1),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return SliverToBoxAdapter(
      child: Container(color: AppColors.neutralF5F5F5, height: 5),
    );
  }

  Widget _buildRoomInfo() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thông tin chi tiết', style: ConstantFont.boldText.copyWith(fontSize: 18)),
            const SizedBox(height: 10),
            _buildExpandableDescription(),
            const SizedBox(height: 10),
            const Divider(height: 1, color: AppColors.neutralF5F5F5),
            const SizedBox(height: 20),
            _buildService(),
            const SizedBox(height: 10),
            Text('Ảnh căn phòng', style: ConstantFont.semiBoldText.copyWith(fontSize: 16)),
            const SizedBox(height: 20),
            if (selectedRoom.images != null && selectedRoom.images!.isNotEmpty) _buildImageCarousel()
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableDescription() {
    return Obx(
      () {
        bool isExpanded = controller.isExpanded.value;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: ConstrainedBox(
                  constraints: isExpanded ? const BoxConstraints() : const BoxConstraints(maxHeight: 70),
                  child: Text(
                    selectedRoom.description ?? '',
                    style: const TextStyle(fontSize: 16),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ))),
          isExpanded
              ? InkWell(
                  onTap: controller.toggleExpanded,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text('Thu gọn', style: ConstantFont.mediumText.copyWith(color: AppColors.primary1)), const SizedBox(width: 4), SvgPicture.asset(AssetSvg.iconChevronUp, color: AppColors.primary1)],
                  ))
              : InkWell(
                  onTap: controller.toggleExpanded,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text('Xem thêm', style: ConstantFont.mediumText.copyWith(color: AppColors.primary1)), const SizedBox(width: 4), SvgPicture.asset(AssetSvg.iconChevronDown, color: AppColors.primary1)],
                  ),
                )
        ]);
      },
    );
  }

  Widget _buildService() {
    List<ServiceModel> services = selectedRoom.services ?? [];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danh sách dịch vụ',
          style: ConstantFont.semiBoldText.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 10),
        if (services.isNotEmpty) ...[
          Column(
            children: services.map((service) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AssetSvg.iconCheckMark,
                      color: AppColors.primary300,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${service.name}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    if (service.unitPrice != null && service.unitPrice! > 0)
                      Text(
                        controller.formatServiceUnit(service.unitPrice!, service.type ?? ''),
                        style: ConstantFont.regularText,
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ] else ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Không có dịch vụ nào.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImageCarousel() {
    return CarouselSlider(
      items: selectedRoom.images?.map((image) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: image.imageUrl ?? '',
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => const ErrorImageWidget(height: 150,),
          ),
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
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      elevation: 10,
      shadowColor: AppColors.neutral9E9E9E,
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCallButton(),
            const SizedBox(width: 10),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCallButton() {
    return InkWell(
      onTap: controller.makePhoneCall,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.green,
        ),
        child: SvgPicture.asset(AssetSvg.iconCall, color: AppColors.white),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Expanded(
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
            ),
          ],
        ),
      ),
    );
  }
}
