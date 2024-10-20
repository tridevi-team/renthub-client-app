import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
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
                    const TitleInputWidget(title: 'Email', isRequired: true),
                    const SizedBox(height: 4),
                    TextInputWidget(
                      hintText: 'Nhập email',
                      prefixIconPath: AssetSvg.iconMail,
                      controller: controller.emailEditingController,
                      errorInput: controller.emailErrorInputObject,
                      sendOTP: true,
                      isSendOTP: controller.isSendOTP.value,
                      onSendOTP: () {
                        if (controller.emailErrorInputObject.value.isError == false) {
                          controller.generateOTPByEmail();
                        }
                      },
                      onChanged: controller.onChangeSignInEmail,
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
                    CustomElevatedButton(
                        label: 'Đăng nhập',
                        onTap: controller.signInWithEmail,
                        bgColor: const Color(0xFF4B7BE5),
                        textColor: Colors.white),
                    const SizedBox(height: 16),
                    CustomElevatedButton(label: 'Tiếp tục với Google', iconPath: 'assets/icons/ic_google.svg',
                        onTap: controller.signInWithGoogle,
                        textColor: Colors.black.withOpacity(0.5)),
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