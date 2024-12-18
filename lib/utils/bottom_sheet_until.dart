import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';

class BottomSheetUtils {
  static Future<void> showBottomSheetUtils({
    required bool isError,
    String? title,
    String? content,
    String? titlePrimaryButton,
    String? titleSecondaryButton,
    String? textButtonError,
    Function? onTapPrimaryButton,
    Function? onTapSecondaryButton,
    Function? onTapButtonError,
  }) async {
    await Get.bottomSheet(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      SizedBox(
        height: Get.height / 1.5,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 27,
            ),
            Center(
              child: Container(
                height: 3,
                width: 60,
                color: const Color(0xff53587A),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            isError != true ? const Text('Thành công') : const SizedBox(),
            const Spacer(),
            Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    textAlign: TextAlign.center,
                    content ?? '',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF56575B), height: 20 / 14),
                  ),
                ),
              ),
            ),
            const Spacer(),
            if (titlePrimaryButton != '' && titlePrimaryButton != null) ...[
              Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(title ?? ''),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
            if (isError) ...[
              GestureDetector(
                onTap: () {
                  onTapButtonError?.call() ?? Get.back();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 190,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: Color(0xFFF6831F), borderRadius: BorderRadius.all(Radius.circular(49))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 14, top: 14),
                        child: Text(
                          textButtonError ?? 'Thử lại',
                          style: ConstantFont.regularText.copyWith(color: AppColors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              )
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }

}