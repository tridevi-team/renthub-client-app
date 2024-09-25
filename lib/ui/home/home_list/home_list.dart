import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/home/home_widget/home_widget.dart';

class HomeList extends StatelessWidget {
  const HomeList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      sliver: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Danh sách phòng', style: ConstantFont.boldText.copyWith(fontSize: 16)),
          const SizedBox(width: 20),
            SliverList.builder(itemBuilder: (context, index) {
              return const HomeWidget();
            }, addAutomaticKeepAlives: false, itemCount: 6,),
        ],
      ),
    );
  }
}
