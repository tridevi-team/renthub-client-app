import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/models/house_data_model.dart';
import 'package:rent_house/ui/home/home_widget/room_widget.dart';
import 'package:rent_house/ui/home/house_detail/house_detail_controller.dart';
import 'package:rent_house/ui/home/room_detail/room_detail_screen.dart';
import 'package:rent_house/utils/response_error_util.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:rent_house/widgets/divider/divider_custom.dart';
import 'package:rent_house/widgets/errors/network_error_widget.dart';
import 'package:rent_house/widgets/loading/loading_widget.dart';

class HouseDetailScreen extends StatelessWidget {
  HouseDetailScreen({super.key});

  final houseDetailController = Get.put(HouseDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(label: 'Danh sách phòng'),
      backgroundColor: AppColors.white,
      body: Obx(() {
        if (houseDetailController.viewState.value == ViewState.loading) {
          return const LoadingWidget();
        } else if (houseDetailController.viewState.value == ViewState.complete) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (_, floorIndex) {
                      final floor = houseDetailController.currentHouse.floors![floorIndex];
                      ContactModel? contact = houseDetailController.currentHouse.contact;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${floor.name}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ...List.generate(floor.rooms!.length, (roomIndex) {
                            return DividerCustom(
                              child: RoomWidget(
                                room: floor.rooms![roomIndex],
                                onTap: () {
                                  final address =
                                      houseDetailController.currentHouse.address.toString();
                                  Get.to(() => RoomDetailScreen(
                                      selectedRoom: floor.rooms![roomIndex],
                                      address: address,
                                      contactModel: contact));
                                },
                              ),
                            );
                          }),
                        ],
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: houseDetailController.currentHouse.floors!.length,
                    shrinkWrap: true,
                  ),
                ),
              ],
            ),
          );
        } else {
          return NetworkErrorWidget(
            viewState: houseDetailController.viewState.value,
            onRefresh: houseDetailController.fetchHouseInformation,
          );
        }
      }),
    );
  }
}
