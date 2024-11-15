import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/ui/house_renter/house_renter_controller.dart';
import 'package:rent_house/ui/house_renter/widgets/rss_item.dart';
import 'package:rent_house/widgets/errors/network_error_widget.dart';
import 'package:rent_house/widgets/loading/loading_widget.dart';

class HouseRenterScreen extends StatelessWidget {
  HouseRenterScreen({super.key});

  final HouseRenterController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(
        () {
          if (controller.viewState.value == ViewState.loading) {
            return const LoadingWidget();
          } else if (controller.viewState.value == ViewState.complete) {
            return Visibility(
              visible: controller.isVisible.value,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      "https://imageupscaler.com/wp-content/uploads/2024/07/maple-leaf-enlarged.jpg",
                      height: Get.height / 3,
                      width: Get.width,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        AssetSvg.imgLogoApp,
                        height: Get.height / 3,
                        width: Get.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phòng 101",
                            style: ConstantFont.boldText.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Tin tức",
                                  style: ConstantFont.boldText.copyWith(fontSize: 16),
                                ),
                              ),
                              /// ui see more
                              /*GestureDetector(
                                  onTap: () {
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'Xem thêm',
                                        style: ConstantFont.regularText.copyWith(fontSize: 12),
                                      ),
                                      const SizedBox(width: 2),
                                      SvgPicture.asset(
                                        AssetSvg.iconChevronForward,
                                        width: 16,
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                ),*/
                            ],
                          ),

                          if (controller.rssList.isNotEmpty) ...[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: controller.rssList.take(10).map((item) {
                                return RssItem(item: item);
                              }).toList(),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return NetworkErrorWidget(
              viewState: controller.viewState.value,
              onRefresh: controller.onRefreshData,
            );
          }
        }
      ),
    );
  }
}
