import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/ui/signin/signin_controller.dart';
import 'package:rent_house/widgets/buttons/custom_elevated_button.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';
import 'package:rent_house/widgets/textfield/text_input_widget.dart';
import 'package:rent_house/widgets/textfield/title_input_widget.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(label: 'Đăng nhập'),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    SvgPicture.asset('assets/images/img_rent_house.svg', width: Get.width / 2),
                    const SizedBox(height: 50),
                    const TitleInputWidget(title: 'Email / Phone', isRequired: true),
                    const SizedBox(height: 4),
                    TextInputWidget(
                      hintText: 'Nhập Email / Phone',
                      prefixIconPath: AssetSvg.iconPerson,
                      controller: controller.contactInputController,
                      errorInput: controller.contactErrorInputObject,
                      sendOTP: true,
                      isSendOTP: controller.isSendOTP.value,
                      timeCountdown: controller.formattedRemainingTime,
                      onSendOTP: () {
                        if (controller.contactErrorInputObject.value.isError == false) {
                          controller.sendOTP();
                        }
                      },
                      onChanged: controller.onChangeContactInput,
                    ),
                    const SizedBox(height: 16),
                    const TitleInputWidget(title: 'OTP', isRequired: true),
                    const SizedBox(height: 4),
                    TextInputWidget(
                          hintText: 'Nhập OTP',
                          prefixIconPath: AssetSvg.iconPassword,
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          controller: controller.otpEditingController,
                          onChanged: controller.onChangeOTP,
                          errorInput: controller.otpErrorInputObject),
                    /*const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          child: Text(
                        'Quên mật khẩu',
                        style: ConstantFont.semiBoldText.copyWith(color: const Color(0xFF4B7BE5)),
                      )),
                    ),*/
                      const SizedBox(height: 18),
                      CustomElevatedButton(label: 'Đăng nhập', onTap: controller.onLogin, bgColor: const Color(0xFF4B7BE5), textColor: Colors.white),
                      const SizedBox(height: 16),
                      CustomElevatedButton(label: 'Tiếp tục với Google', iconPath: 'assets/icons/ic_google.svg', onTap: controller.signInWithGoogle, textColor: Colors.black.withOpacity(0.5)),
                      const SizedBox(height: 30),
                      /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(child: Divider(height: 1, color: Color(0xFF646464))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Chưa có tài khoản?',
                            style: ConstantFont.regularText.copyWith(color: const Color(0xFF646464)),
                          ),
                        ),
                        const Expanded(child: Divider(height: 1, color: Color(0xFF646464)))
                      ],
                    ),
                    const SizedBox(height: 30),
                    CustomElevatedButton(label: 'Tạo tài khoản mới', onTap: () {})*/
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
