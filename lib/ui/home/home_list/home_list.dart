import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/models/house_data_model.dart';
import 'package:rent_house/ui/home/home_widget/home_widget.dart';
import 'package:rent_house/ui/home/house_detail/house_detail_screen.dart';
import 'package:rent_house/widgets/divider/divider_custom.dart';

class HomeList extends StatelessWidget {
  const HomeList({super.key, this.houseList, this.addToRecentHouse});

  final List<House>? houseList;
  final void Function(House house)? addToRecentHouse;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      sliver: houseList != null && houseList!.isNotEmpty
          ? SliverList(
              delegate: SliverChildBuilderDelegate(
                addAutomaticKeepAlives: false,
                (BuildContext context, int index) {
                  return DividerCustom(
                    child: HomeWidget(
                        onTap: () {
                          addToRecentHouse?.call(houseList![index]);
                          Get.to(() => HouseDetailScreen(),
                              arguments: {'houseId': houseList![index].id});
                        },
                        house: houseList![index]),
                  );
                },
                childCount: houseList!.length,
              ),
            )
          : const SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }
}
