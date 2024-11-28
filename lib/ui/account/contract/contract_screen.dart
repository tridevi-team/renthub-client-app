import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/account/contract/contract_controller.dart';
import 'package:rent_house/widgets/custom_app_bar.dart';

class CustomerContractScreen extends StatelessWidget {
  CustomerContractScreen({super.key});

  final controller = Get.put(CustomerContractController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(label: "Quản lý hợp đồng"),
      body: Column(
        children: [
          TabBar(
            tabs: controller.contractTabs,
            labelStyle: ConstantFont.mediumText.copyWith(color: AppColors.primary1),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            isScrollable: true,
            controller: controller.contractTabController,
            indicatorColor: AppColors.primary1,
            labelColor: AppColors.primary1,
            unselectedLabelColor: AppColors.black,
            overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
            onTap: (value) {
              controller.currentContractTabIndex = value;
            },
          ),
        ],
      ),
    );
  }
}
