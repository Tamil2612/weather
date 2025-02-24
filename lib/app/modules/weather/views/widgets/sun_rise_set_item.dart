import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SunRiseSetItem extends StatelessWidget {
  final String text;
  final String value;
  final Color color;
  const SunRiseSetItem({
    super.key,
    required this.text,
    required this.value, required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(value, style: Get.theme.textTheme.displayMedium?.copyWith(
          fontSize: 14.sp,
          color: color
        )),
        10.horizontalSpace,
        Text(text, style: Get.theme.textTheme.displaySmall?.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          color: color
        )),
      ],
    );
  }
}