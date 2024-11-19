import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/room_model.dart';
import 'package:rent_house/models/user_model.dart';
import 'package:rent_house/ui/house_renter/house_renter_controller.dart';
import 'package:rent_house/ui/house_renter/widgets/rss_item.dart';
import 'package:rent_house/widgets/avatar/avatar.dart';
import 'package:rent_house/widgets/errors/network_error_widget.dart';
import 'package:rent_house/widgets/images/common_network_image.dart';
import 'package:rent_house/widgets/loading/loading_widget.dart';
import 'package:rent_house/widgets/refresh/smart_refresh.dart';

class HouseRenterScreen extends StatelessWidget {
  HouseRenterScreen({super.key});

  final HouseRenterController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() {
        switch (controller.viewState.value) {
          case ViewState.loading:
            return const LoadingWidget();
          case ViewState.noInternetConnection:
            return NetworkErrorWidget(
              viewState: controller.viewState.value,
              onRefresh: controller.onRefreshData,
            );
          case ViewState.complete:
          case ViewState.init:
            return _buildContent();
          default:
            return const SizedBox();
        }
      }),
    );
  }

  Widget _buildContent() {
    return Visibility(
      visible: controller.isVisible.value,
      child: SmartRefreshWidget(
        key: UniqueKey(),
        controller: RefreshController(),
        scrollController: controller.scrollController,
        onRefresh: controller.onRefreshData,
        enablePullUp: false,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            CommonNetworkImage(
              imageUrl: controller.room.images?.isNotEmpty == true ? controller.room.images![0].imageUrl : '',
              height: Get.height / 3,
              width: Get.width,
              borderRadius: 0,
            ),
            const SizedBox(height: 10),
            _buildRoomInfo(),
            const SizedBox(height: 10),
            _buildNewsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${controller.room.name} - ${controller.room.house?.floor?.name}",
            style: ConstantFont.boldText.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Thành viên",
                style: ConstantFont.boldText.copyWith(fontSize: 16),
              ),
              if (UserSingleton.instance.getUser().represent == 1)
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'Chỉnh sửa',
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
                ),
            ],
          ),
          const SizedBox(height: 10),
          _buildMemberList(),
          const SizedBox(height: 10),
          Text(
            "Dịch vụ",
            style: ConstantFont.boldText.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 10),
          _buildServiceList()
        ],
      ),
    );
  }

  Widget _buildServiceList() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 3,
      ),
      padding: const EdgeInsets.all(0),
      itemCount: controller.room.services?.length,
      itemBuilder: (context, index) {
        ServiceModel service = controller.room.services?[index] ?? ServiceModel();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.neutralFAFAFA,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(AssetSvg.iconPerson),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        "${service.name}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ConstantFont.regularText.copyWith(fontSize: 12),
                      ),
                    ),
                    Text(
                      "${service.unitPrice}",
                      style: ConstantFont.regularText.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildMemberList() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2,
      ),
      padding: const EdgeInsets.all(0),
      itemCount: controller.memberList.length,
      itemBuilder: (context, index) {
        UserModel user = controller.memberList[index];
        bool isSelf = user.id == UserSingleton.instance.getUser().id;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.neutralFAFAFA,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AvatarWidget(
                name: user.name ?? 'Unknown',
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            isSelf ? "Bạn" : user.name ?? 'Unknown',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ConstantFont.regularText.copyWith(fontSize: 12),
                          ),
                        ),
                        if (user.represent == 1) ...[
                          const SizedBox(width: 4),
                          SvgPicture.asset(
                            AssetSvg.iconVerify,
                            color: AppColors.green,
                          )
                        ]
                      ],
                    ),
                    Text(
                      "${user.phoneNumber}",
                      style: ConstantFont.regularText.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tin tức",
                style: ConstantFont.boldText.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (controller.rssList.isNotEmpty)
            Column(
              children: controller.rssList.take(10).map((item) {
                return RssItem(item: item);
              }).toList(),
            ),
        ],
      ),
    );
  }
}
