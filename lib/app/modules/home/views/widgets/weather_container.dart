import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:weather/utils/extensions.dart';

import '../../../../../config/translations/strings_enum.dart';
import '../../../../components/custom_cached_image.dart';
import '../../../../data/models/weather_model.dart';
import '../../../../routes/app_pages.dart';

class WeatherContainer extends StatelessWidget {
  final WeatherModel weather;
  final double height;
  final double width;
  final Color color;
  final Color textColor;

  const WeatherContainer({
    super.key,
    required this.height,
    required this.width,
    required this.color,
    required this.textColor,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle(double fontSize, FontWeight? fontWeight) {
      return TextStyle(
        fontSize: fontSize.sp,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: textColor,
      );
    }

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.WEATHER,
          arguments: '${weather.location.lat},${weather.location.lon}'),
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(35.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Today", style: textStyle(25, FontWeight.normal)),
            SizedBox(height: 18.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomCachedImage(
                  imageUrl: weather.current.condition.icon.toHighRes().addHttpPrefix(),
                  fit: BoxFit.cover,
                  width: 100.w,
                  height: 100.h,
                  color: Colors.white,
                ),
                SizedBox(width: 12.w),
                Text("${weather.current.tempC.round()}${Strings.celsius.tr}",
                    style: textStyle(50, FontWeight.w500)),
              ],
            ),
            SizedBox(height: 18.h),
            Text(weather.current.condition.text,
                style:
                    textStyle(20, FontWeight.w600).copyWith(letterSpacing: 1)),
            SizedBox(height: 15.h),
            Text(weather.location.name.toRightCity(),
                style: textStyle(15, FontWeight.normal)),
            SizedBox(height: 15.h),
            Text(
                "Feels like ${weather.current.feelslikeC.round()}${Strings.celsius.tr}",
                style: textStyle(15, FontWeight.normal)),
          ],
        ),
      ).animate().fade().slideY(
            duration: 300.ms,
            begin: 1,
            curve: Curves.easeInSine,
          ),
    );
  }
}
