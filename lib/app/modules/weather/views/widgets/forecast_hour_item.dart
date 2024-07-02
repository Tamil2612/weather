import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/extensions.dart';
import '../../../../../config/translations/strings_enum.dart';
import '../../../../components/custom_cached_image.dart';
import '../../../../data/models/weather_details_model.dart';

class ForecastHourItem extends StatelessWidget {
  final Hour hour;
  final Color textColor;
  const ForecastHourItem({super.key, required this.hour, required this.textColor});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      margin: EdgeInsetsDirectional.only(end: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hour.time.convertToTime(),
            style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
          ),
          CustomCachedImage(
            imageUrl: hour.condition.icon.addHttpPrefix(),
            fit: BoxFit.cover,
            width: 40.w,
            height: 40.h,
          ),
          Text(
            '${hour.tempC.toInt().toString()}${Strings.celsius.tr}',
            style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}