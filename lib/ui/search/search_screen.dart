import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/home/home_app_bar.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:rent_house/widgets/textfield/text_input_widget.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 3,
          shadowColor: AppColors.neutralCCCAC6,
          title: Row(
            children: [
              GestureDetector(
                onTap: Get.back,
                  child: SvgPicture.asset(AssetSvg.iconChevronBack, height: 30)),
              const SizedBox(width: 10),
              const Expanded(child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: TextInputWidget(isSearch: true, height: 40, colorBorder: Colors.transparent, backgroundColor: AppColors.neutralF5F5F5,))),
            ],
          )),
      body: Column(),
    );
  }
}
