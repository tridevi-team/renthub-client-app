import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/onboarding/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body:Container(
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [
              Color(0xFF80C8FF),
              Color(0xFFD9A3F6)
            ], begin: Alignment.centerLeft, end: Alignment.centerRight)
            ),
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                alignment: Alignment.topRight,
                child: TextButton(
                    onPressed: controller.skipPage,
                    child: Obx(()=> Text(controller.currentPageIndex.value == 0 ? '' : 'Bỏ qua', style: ConstantFont.regularText)),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.updatePageIndicator,
                  children: [
                    _buildOnboardingPage(
                        image: 'assets/images/started.png',
                        description: 'Giải pháp chuyên nghiệp và linh hoạt cho quản lý nhà trọ, kí túc xá, nhà cho thuê'),
                    _buildOnboardingPage(
                        image: 'assets/images/started-2.png',
                        description: 'Quản lý thuê phòng, hóa đơn, thu chi minh bạch chỉ với vài thao tác đơn giản'),
                    _buildOnboardingPage(
                        image: 'assets/images/started-3.png',
                        description: 'Giám sát, quản lý tình trạng phòng và sửa chữa bảo trì tiện lợi, tiết kiệm thời gian, công sức.'),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) => Obx(
                  () => Container(
                        height: 3,
                        width: 25,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: controller.currentPageIndex.value == index
                              ? const Color(0xFF4B7BE5)
                              : Colors.white,
                        ),
                      )),
                ),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Row(
                    children: [
                      Obx(()=> controller.currentPageIndex.value != 0 ? GestureDetector(
                        onTap: controller.previousPage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.0),
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ) : const SizedBox()),
                      Expanded(
                        child: CupertinoButton(
                          color: const Color(0xFF4B7BE5),
                          onPressed: controller.nextPage,
                          child: Text('Tiếp tục', style: ConstantFont.boldText.copyWith(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    ],
                  )),
            ]),
          )
      );
}

  Column _buildOnboardingPage({required String image, required String description}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 300,
        ),
        SvgPicture.asset('assets/images/img_rent_house.svg', color: Colors.white, width: 2 * Get.width / 3),
        const SizedBox(height: 20),
        Text(
          'Rent House',
          style: ConstantFont.extraBoldText.copyWith(fontSize: 32),
        ),
        const SizedBox(height: 20),
        Text(
            description,
            textAlign: TextAlign.center,
            style: ConstantFont.lightText
        ),
      ],
    );
  }
}
