import 'package:flutter/cupertino.dart';
import 'package:rent_house/constants/app_colors.dart';

class DividerCustom extends StatelessWidget {
  const DividerCustom({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: AppColors.neutralF5F5F5,
          width: 1.0,
        ),
      ),
    ),
    child: child);
  }
}
