import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/explore_model.dart';

class HomeExplore extends StatelessWidget {
  const HomeExplore({super.key, required this.exploreList});

  final List<Explore> exploreList;

  @override
  Widget build(BuildContext context) {
    return exploreList.isEmpty
        ? const SizedBox.shrink()
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                child: Text('Khám phá', style: ConstantFont.boldText.copyWith(fontSize: 16))),
            const SizedBox(width: 20),
            Container(
              alignment: Alignment.center,
              height: 150,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return exploreItem(
                      context: context,
                      image: exploreList[index].name,
                      title: 'Khám phá 1',
                      onTap: () {},
                      quantity: 50,
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 20),
                  itemCount: exploreList.length),
            )
          ]);
  }
}

Widget exploreItem({
  required BuildContext context,
  required String image,
  required String title,
  required VoidCallback onTap,
  required int quantity,
}) {
  return GestureDetector(
    child: Stack(
      children: [
        //CachedNetworkImage(imageUrl: 'assets/images/started.png'),
        Image.asset(
          'assets/images/started.png',
          width: 2 * Get.width / 5,
          height: 150,
          fit: BoxFit.contain,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  textAlign: TextAlign.center,
                  style: ConstantFont.semiBoldText.copyWith(fontSize: 12, color: AppColors.black)),
              Text('Xem ngay $quantity dự án',
                  textAlign: TextAlign.center,
                  style: ConstantFont.boldText.copyWith(fontSize: 10, color: AppColors.black))
            ],
          ),
        )
      ],
    ),
  );
}
