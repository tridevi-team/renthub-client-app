import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          children: [
            Stack(
              children: [
                /*CachedNetworkImage(imageUrl: 'assets/images/started.png',
                  width: Get.width / 4,
                  height: 3 * Get.width / 8,
                  fit: BoxFit.contain,),*/
                Image.asset(
                  'assets/images/started.png',
                  width: Get.width / 4,
                  height: 3 * Get.width / 8,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            Column(children: [
              Text('Green Diamond'),
              SizedBox(height: 8),
              Text('3 - 4 triệu'),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  text: "2 phòng ngủ",
                  children: [
                    TextSpan(text: '47 m^2'),
                  ],
                  style: TextStyle(color: Colors.black), // Add any necessary styles
                ),
              ),
              SizedBox(height: 8),
              Text('Đống Đa, Hà Nội'),
            ],)
          ],
        ),
      ),
    );
  }
}
