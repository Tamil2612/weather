import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/extensions.dart';
import '../../../../../config/translations/strings_enum.dart';
import '../../../../components/custom_cached_image.dart';
import '../../../../data/models/weather_details_model.dart';

class WeatherDetailsCard extends StatelessWidget {
  final WeatherDetailsModel weatherDetails;
  final Forecastday forecastDay;
  final Color color;
  final Color textColor;
  const WeatherDetailsCard({
    super.key,
    required this.weatherDetails,
    required this.forecastDay,
    required this.color, required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        children: [
          30.verticalSpace,
          CustomCachedImage(
            imageUrl: weatherDetails.current.condition.icon.toHighRes().addHttpPrefix(),
            fit: BoxFit.cover,
            width: 150.w,
            height: 150.h,
            color: textColor,
          ),
          30.verticalSpace,
          Text(
            '${weatherDetails.location.name.toRightCity()}, ${weatherDetails.location.country.toRightCountry()}',
            style: theme.textTheme.displaySmall?.copyWith(
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          Text(
            '${weatherDetails.current.tempC.toInt()}${Strings.celsius.tr}',
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: 64.sp,
              color: textColor,
            ),
          ),
          16.verticalSpace,
          Text(
            weatherDetails.current.condition.text,
            style: theme.textTheme.displaySmall?.copyWith(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}