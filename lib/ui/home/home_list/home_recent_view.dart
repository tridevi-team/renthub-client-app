import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/house_data_model.dart';
import 'package:rent_house/ui/home/house_detail/house_detail_screen.dart';

class HomeRecentView extends StatelessWidget {
  const HomeRecentView({super.key, this.houseList});
  final List<House>? houseList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: houseList == null || houseList!.isEmpty
          ? const SizedBox.shrink()
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nhà xem gần đây', style: ConstantFont.boldText.copyWith(fontSize: 16)),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.centerLeft,
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              addAutomaticKeepAlives: false,
              itemBuilder: (context, index) {
                final house = houseList![index];
                return _buildRecentHouse(house);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: houseList!.length,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.neutralF5F5F5),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildRecentHouse(House house) {
    return GestureDetector(
      onTap: (){
        Get.to(
              () => HouseDetailScreen(),
          arguments: {'houseId': house.id},
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6)),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: '${house.thumbnail}',
                errorWidget: (_, __, ___) => Image.asset(
                  'assets/images/image.png',
                  width: Get.width / 3,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                width: Get.width / 3,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 8,
                right: 0,
                left: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text("${house.name}",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ConstantFont.semiBoldText.copyWith(fontSize: 12, color: AppColors.white)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
