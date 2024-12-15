import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/models/house_data_model.dart';
import 'package:rent_house/models/room_model.dart';
import 'package:rent_house/ui/home/room_detail/room_detail_controller.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/widgets/buttons/custom_elevated_button.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:rent_house/widgets/images/error_image_widget.dart';
import 'package:rent_house/widgets/textfield/text_input_widget.dart';

class RoomDetailScreen extends StatelessWidget {
  RoomDetailScreen({super.key, required this.selectedRoom, this.address = '', this.contactModel});

  final controller = Get.put(RoomDetailController());
  final Room selectedRoom;
  final String? address;
  final ContactModel? contactModel;

  @override
  Widget build(BuildContext context) {
    controller.roomId = selectedRoom.id;
    controller.address = address;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(isTransparent: true),
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          _buildRoomImage(),
          _buildRoomDetails(),
          _buildDivider(),
          _buildRoomInfo(),
        ],
      ),
      bottomNavigationBar: selectedRoom.status == ConstantString.statusExpired || selectedRoom.status == ConstantString.statusRented ? const SizedBox() : _buildBottomAppBar(),
    );
  }

  Widget _buildRoomImage() {
    return SliverToBoxAdapter(
      child: CachedNetworkImage(
        imageUrl: (selectedRoom.images?.isNotEmpty ?? false) ? selectedRoom.images?.first.imageUrl ?? '' : '',
        width: Get.width,
        height: 300,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => const ErrorImageWidget(),
      ),
    );
  }

  Widget _buildRoomDetails() {
    Color color = controller.getRoomStatusIconPath(selectedRoom.status ?? '')['color'];
    String description = controller.getRoomStatusIconPath(selectedRoom.status ?? '')['description'];
    String iconPath = controller.getRoomStatusIconPath(selectedRoom.status ?? '')['path'];
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedRoom.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: ConstantFont.boldText.copyWith(fontSize: 18),
                ),
                const SizedBox(width: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      iconPath,
                      height: 24,
                      color: color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      description,
                      style: ConstantFont.lightText.copyWith(color: color),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              FormatUtil.formatCurrency(selectedRoom.price ?? 0),
              style: ConstantFont.mediumText.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Wrap(crossAxisAlignment: WrapCrossAlignment.start, spacing: 10, runSpacing: 10, children: [
              _buildFeatureRow(AssetSvg.iconMultiPeople, (selectedRoom.maxRenters ?? -1) < 0 ? "Không giới hạn" : "${selectedRoom.maxRenters} người"),
              _buildFeatureRow(AssetSvg.iconCrop, "${selectedRoom.area} m", hasSuperscript: true),
            ]),
            const SizedBox(height: 10),
            Text(
              address ?? '',
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
    return GestureDetector(
      onTap: controller.viewRoomAddressOnMap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
      ),
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
            if (selectedRoom.description?.isNotEmpty ?? false) ...[
              Text('Thông tin chi tiết', style: ConstantFont.boldText.copyWith(fontSize: 18)),
              const SizedBox(height: 10),
              _buildExpandableDescription(),
            ],
            const SizedBox(height: 10),
            const Divider(height: 1, color: AppColors.neutralF5F5F5),
            const SizedBox(height: 20),
            _buildService(),
            const SizedBox(height: 20),
            _buildEquipment(),
            const SizedBox(height: 10),
            if (selectedRoom.images != null && selectedRoom.images!.isNotEmpty) ...[Text('Ảnh căn phòng', style: ConstantFont.semiBoldText.copyWith(fontSize: 16)), const SizedBox(height: 20), _buildImageCarousel()]
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

  Widget _buildEquipment() {
    List<EquipmentModel> equipments = selectedRoom.equipments ?? [];
    if (equipments.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danh sách thiết bị',
          style: ConstantFont.semiBoldText.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3,
          ),
          padding: const EdgeInsets.all(0),
          itemCount: equipments.length,
          itemBuilder: (context, index) {
            EquipmentModel equipment = equipments[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.neutralFAFAFA,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AppUtil.getEquipmentIconPath(equipment.name ?? ''),
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${equipment.name}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ConstantFont.regularText.copyWith(fontSize: 12),
                      )
                    ],
                  ),
                  Text(
                    "x1",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ConstantFont.regularText.copyWith(fontSize: 12),
                  )
                  /*Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            "${equipment.name}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ConstantFont.regularText.copyWith(fontSize: 12),
                          ),
                        ),
                        Text(
                          FormatUtil.formatCurrency(equipment ?? 0),
                          style: ConstantFont.regularText.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),*/
                ],
              ),
            );
          },
        ),
      ],
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
                        AppUtil.formatServiceUnit(service.unitPrice!, service.type ?? ''),
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
            errorWidget: (context, url, error) => const ErrorImageWidget(
              height: 150,
            ),
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
            if (contactModel?.phoneNumber?.isNotEmpty ?? false) ...[
              _buildCallButton(),
              const SizedBox(width: 10),
            ],
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCallButton() {
    return InkWell(
      onTap: () {
        controller.makePhoneCall(contactModel!.phoneNumber!);
      },
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
      child: InkWell(
        onTap: receiveRoomInformationForm,
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
      ),
    );
  }

  Widget _buildFeatureRow(String iconPath, String text, {bool hasSuperscript = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SvgPicture.asset(iconPath),
        const SizedBox(width: 4),
        hasSuperscript
            ? Text.rich(
                TextSpan(
                  text: text,
                  style: ConstantFont.regularText,
                  children: const [
                    TextSpan(
                      text: '2',
                      style: TextStyle(
                        fontSize: 12,
                        fontFeatures: [FontFeature.superscripts()],
                      ),
                    ),
                  ],
                ),
              )
            : Text(
                text,
                style: ConstantFont.regularText,
              ),
      ],
    );
  }

  void receiveRoomInformationForm() {
    Get.bottomSheet(
        Container(
          height: Get.height * 0.4,
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: AppColors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                    "Đăng ký nhận thông tin",
                    style: ConstantFont.boldText,
                  )),
                  InkWell(
                      onTap: () {
                        Get.close(1);
                      },
                      child: SvgPicture.asset(AssetSvg.iconClose, width: 24))
                ],
              ),
              const SizedBox(height: 30),
              TextInputWidget(
                hintText: "Họ tên",
                controller: controller.fullNameCtrl,
                errorInput: controller.fullNameError,
                onChanged: controller.onChangeFullNameInput,
              ),
              const SizedBox(height: 10),
              TextInputWidget(
                hintText: "Số điện thoại",
                controller: controller.phoneCtrl,
                errorInput: controller.phoneError,
                onChanged: controller.onChangePhoneInput,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                        label: "Hủy",
                        onTap: () {
                          Get.close(1);
                        }),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomElevatedButton(
                      label: "Đăng ký",
                      onTap: controller.receiveRoomInformation,
                      isReverse: true,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        isScrollControlled: true);
  }
}
