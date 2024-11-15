import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/account/customer_info/customer_info_controller.dart';
import 'package:rent_house/untils/format_util.dart';
import 'package:rent_house/widgets/avatar/avatar.dart';
import 'package:rent_house/widgets/buttons/custom_elevated_button.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:rent_house/widgets/textfield/text_input_widget.dart';
import 'package:rent_house/widgets/textfield/title_input_widget.dart';

class CustomerInfo extends StatelessWidget {
  CustomerInfo({super.key});

  final controller = Get.put(CustomerInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(label: "Thông tin cá nhân"),
      body: Obx(
        () => Visibility(
          visible: controller.isVisible.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileImage(controller.user.name ?? ''),
                const SizedBox(height: 10),
                _buildProfileName(controller.user.name ?? ''),
                const SizedBox(height: 20),
                _buildAccountInfo(email: controller.user.email ?? '', phone: controller.user.phoneNumber ?? ''),
                const SizedBox(height: 20),
                _buildCustomerInfo(
                  name: controller.user.name ?? '',
                  address: controller.user.address?.toString() ?? '',
                  citizenId: controller.user.citizenId ?? '',
                  dob: controller.user.birthday ?? '',
                ),
                const SizedBox(height: 20),
                _buildOtherInfo(moveInDate: controller.user.moveInDate ?? '', tempReg: controller.user.tempReg ?? 0),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Material(
      elevation: 10,
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(10),
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCancelButton(),
            const SizedBox(width: 10),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return Expanded(
      child: CustomElevatedButton(
        label: 'Hủy',
        onTap: () => Get.back(),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Expanded(
      child: CustomElevatedButton(
        label: 'Xác nhận',
        textColor: AppColors.white,
        bgColor: AppColors.primary600,
        onTap: controller.confirmResidenceRegistration,
      ),
    );
  }

  Widget _buildProfileImage(String name) {
    String lastName = name.split(' ').last;
    return Align(
      alignment: Alignment.topCenter,
      child: CachedNetworkImage(
        imageUrl: 'imageUrl',
        height: 80,
        width: 80,
        errorWidget: (context, url, error) => AvatarWidget(lastName: lastName),
      ),
    );
  }

  Widget _buildProfileName(String name) {
    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        name,
        style: ConstantFont.semiBoldText.copyWith(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAccountInfo({required String email, required String phone}) {
    return _infoContainer([
      _buildInfoItem("Email", AssetSvg.iconMail, email, color: AppColors.primary500),
      _buildInfoItem("Phone", AssetSvg.iconCall, FormatUtil.formatPhoneNumber(phone), color: AppColors.primary500),
      _buildInfoItem("Tài khoản liên kết", AssetSvg.iconGoogle, "Google"),
    ]);
  }

  Widget _infoContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutralFAFAFA,
        borderRadius: BorderRadius.circular(10),
        border: const Border.fromBorderSide(
          BorderSide(color: AppColors.neutralCCCAC6, width: 1),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildInfoItem(String title, String iconPath, String content, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: ConstantFont.regularText.copyWith(color: AppColors.neutral8F8D8A),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SvgPicture.asset(iconPath, color: color, width: 26),
            const SizedBox(width: 6),
            Expanded(child: Text(content, style: ConstantFont.mediumText.copyWith(fontSize: 16))),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCustomerInfo({required String name, required String citizenId, required String address, required String dob}) {
    return Column(
      children: [
        const TitleInputWidget(title: 'Nhập thông tin cá nhân'),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: controller.useScanQR,
              child: Text(
                "Use QR Scan",
                style: ConstantFont.mediumText.copyWith(color: AppColors.primary600),
              ),
            ),
            InkWell(
              onTap: controller.useNFC,
              child: Text("Use NFC", style: ConstantFont.mediumText.copyWith(color: AppColors.primary600)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildTextField('Họ tên', controller.fullName ?? name),
        const SizedBox(height: 10),
        _buildTextField('Số định danh cá nhân', controller.citizenId ?? citizenId),
        const SizedBox(height: 10),
        _buildTextField('Ngày sinh', controller.dateOfBirth ?? FormatUtil.formatToDayMonthYear(dob)),
        const SizedBox(height: 10),
        _buildTextField('Địa chỉ', controller.address ?? address, maxLines: 2),
      ],
    );
  }

  Widget _buildTextField(String title, String value, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleInputWidget(title: title),
        const SizedBox(height: 6),
        TextInputWidget(
          enable: false,
          label: value,
          maxLines: maxLines,
          height: 48,
          backgroundColor: AppColors.neutralE5E5E3,
          colorBorder: AppColors.white,
        ),
      ],
    );
  }

  Widget _buildOtherInfo({required String moveInDate, required int tempReg}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Thông tin khác', style: ConstantFont.mediumText.copyWith(fontSize: 18)),
        const SizedBox(height: 10),
        _buildTextField('Ngày chuyển vào', FormatUtil.formatToDayMonthYear(moveInDate)),
        const SizedBox(height: 10),
        Row(
          children: [
            SvgPicture.asset(
              tempReg == 1 ? AssetSvg.iconCheckMark : AssetSvg.iconClose,
              height: 24,
              color: tempReg == 1 ? AppColors.green900 : AppColors.red,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                tempReg == 1 ? "Đăng ký tạm trú" : "Chưa đăng ký tạm trú",
                style: ConstantFont.regularText.copyWith(color: AppColors.neutral8F8D8A),
              ),
            ),
          ],
        ),
        if (tempReg != 1) _buildRegistrationNotice(tempReg: tempReg),
      ],
    );
  }

  Widget _buildRegistrationNotice({required int tempReg}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.neutralFAFAFA,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bạn chưa đăng ký tạm trú, xin vui lòng ra cơ quan có thẩm quyền gần nhất để thực hiện khai báo. Nếu bạn đã khai báo thì xin vui lòng nhấn bỏ qua.",
            style: ConstantFont.regularText.copyWith(fontSize: 12),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: controller.confirmResidenceRegistration,
              child: Text(
                'Bỏ qua',
                style: ConstantFont.mediumText.copyWith(color: AppColors.primary400, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
