import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';

import '../../../../utils/extensions.dart';
import '../../../../config/translations/strings_enum.dart';
import '../../../../utils/constants.dart';
import '../../../components/api_error_widget.dart';
import '../../../components/custom_icon_button.dart';
import '../../../components/my_widgets_animator.dart';
import '../../home/views/widgets/blur_container.dart';
import '../controllers/weather_controller.dart';
import 'widgets/forecast_hour_item.dart';
import 'widgets/sun_rise_set_item.dart';
import 'widgets/weather_details_card.dart';
import 'widgets/weather_details_item.dart';
import 'widgets/weather_row_data.dart';

class WeatherView extends GetView<WeatherController> {
  const WeatherView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<WeatherController>(
          builder: (_) => MyWidgetsAnimator(
            apiCallStatus: controller.apiCallStatus,
            loadingWidget: () => Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                  color: theme.primaryColor, size: 50),
            ),
            errorWidget: () => ApiErrorWidget(
              retryAction: () => controller.getWeatherDetails(),
            ),
            successWidget: () {
              int weatherCode =
                  controller.weatherDetails.current.condition.code;
              String backgroundImage = controller.getWeatherImage(weatherCode);
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(backgroundImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      30.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 26.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomIconButton(
                              onPressed: () => Get.back(),
                              icon: const Icon(Icons.arrow_back_rounded,
                                  color: Colors.white),
                              backgroundColor: controller.containerColor,
                            ),
                            PopupMenuButton<String>(
                              onSelected: controller.onDaySelected,
                              color: theme.cardColor,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context) => controller
                                  .weatherDetails.forecast.forecastday
                                  .map((fd) {
                                return PopupMenuItem<String>(
                                  value: fd.date.convertToDay(),
                                  child: Text(
                                    fd.date.convertToDay(),
                                    style: theme.textTheme.displaySmall
                                        ?.copyWith(
                                            color:
                                                controller.containerTextColor),
                                  ),
                                );
                              }).toList(),
                              child: Container(
                                height: 50.h,
                                padding: EdgeInsetsDirectional.only(start: 8.w),
                                decoration: BoxDecoration(
                                  color: theme.canvasColor,
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(controller.selectedDay,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                                color: controller
                                                    .containerTextColor)),
                                    8.horizontalSpace,
                                    CustomIconButton(
                                      onPressed: null,
                                      icon: SvgPicture.asset(
                                        Constants.downArrow,
                                        fit: BoxFit.none,
                                      ),
                                      backgroundColor:
                                          controller.containerColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      24.verticalSpace,
                      AspectRatio(
                        aspectRatio: 0.99,
                        child: PageView.builder(
                          controller: controller.pageController,
                          physics: const ClampingScrollPhysics(),
                          onPageChanged: controller.onCardSlided,
                          itemCount: controller
                              .weatherDetails.forecast.forecastday.length,
                          itemBuilder: (context, index) {
                            return AnimatedBuilder(
                              animation: controller.pageController,
                              builder: (context, child) {
                                double value = 0.0;
                                //print('abd: value=$value | index=$index');
                                if (controller
                                    .pageController.position.haveDimensions) {
                                  value = index.toDouble() -
                                      (controller.pageController.page ?? 0);
                                  //value = (value * 0.038).clamp(-1, 1);
                                  value = controller.isEnLang
                                      ? (value * 0.038).clamp(-1, 1)
                                      : (value * -0.038).clamp(-1, 1);
                                } else {
                                  // if(index == 0) value = controller.isEnLang ? -0.038 : 0.038;
                                  // if(index == 1) value = 0.0;
                                  // if(index == 2) value = controller.isEnLang ? 0.038 : -0.038;
                                  if (index == 0) value = 0.0;
                                  if (index == 1) {
                                    value =
                                        controller.isEnLang ? 0.038 : -0.038;
                                  }
                                  if (index == 2) {
                                    value =
                                        controller.isEnLang ? -0.038 : 0.038;
                                  }
                                }
                                return Transform.rotate(
                                  angle: pi * value,
                                  child: WeatherDetailsCard(
                                    weatherDetails: controller.weatherDetails,
                                    forecastDay: controller.weatherDetails
                                        .forecast.forecastday[index],
                                    color: controller.containerColor,
                                    textColor: controller.containerTextColor,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      20.verticalSpace,
                      Center(
                        child: AnimatedSmoothIndicator(
                          activeIndex: controller.currentPage,
                          count: 3,
                          effect: WormEffect(
                            activeDotColor: controller.containerTextColor,
                            dotColor: theme.colorScheme.secondary,
                            dotWidth: 10.w,
                            dotHeight: 10.h,
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Strings.weatherNow.tr,
                                style: theme.textTheme.displayMedium),
                            16.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WeatherDetailsItem(
                                  title: Strings.wind.tr,
                                  icon: Constants.wind,
                                  value: controller
                                      .weatherDetails.current.windMph
                                      .toInt()
                                      .toString(),
                                  text: 'mph',
                                  color: controller.containerColor,
                                  textColor: controller.containerTextColor,
                                ),
                                WeatherDetailsItem(
                                  title: Strings.pressure.tr,
                                  icon: Constants.pressure,
                                  value: controller
                                      .weatherDetails.current.pressureIn
                                      .toInt()
                                      .toString(),
                                  text: 'inHg',
                                  isHalfCircle: true,
                                  color: controller.containerColor,
                                  textColor: controller.containerTextColor,
                                ),
                              ],
                            ),
                            20.verticalSpace,
                            Text(Strings.hoursForecast.tr,
                                style: theme.textTheme.displayMedium?.copyWith(
                                    color: controller.containerTextColor)),
                            16.verticalSpace,
                            BlurContainer(
                              height: 150.h,
                              width: 360.w,
                              color: controller.containerColor.withOpacity(0.6),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: 75,
                                      // Adjust the height as needed
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            controller.forecastday.hour.length,
                                        itemBuilder: (context, index) =>
                                            ForecastHourItem(
                                          hour: controller
                                              .forecastday.hour[index],
                                          textColor:
                                              controller.containerTextColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            16.verticalSpace,
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BlurContainer(
                                        radius: 24,
                                        width: double.infinity,
                                        height: 85.h,
                                        color: controller.containerColor
                                            .withOpacity(0.6),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w, vertical: 20.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    controller.weatherDetails
                                                        .current.windDir
                                                        .getWindDir(),
                                                    style: theme
                                                        .textTheme.displayMedium
                                                        ?.copyWith(
                                                            fontSize: 14.sp,
                                                            color: controller
                                                                .containerTextColor),
                                                  ),
                                                  10.verticalSpace,
                                                  Text(
                                                    '${controller.forecastday.day.maxwindMph} ${Strings.kmh.tr}',
                                                    style: theme
                                                        .textTheme.displayMedium
                                                        ?.copyWith(
                                                            fontSize: 14.sp,
                                                            color: controller
                                                                .containerTextColor),
                                                  ),
                                                ],
                                              ),
                                              RotationTransition(
                                                turns: AlwaysStoppedAnimation(
                                                    controller
                                                            .weatherDetails
                                                            .current
                                                            .windDegree /
                                                        360),
                                                child: Icon(Icons.north,
                                                    size: 30,
                                                    color: controller
                                                        .containerTextColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      10.verticalSpace,
                                      BlurContainer(
                                        radius: 24,
                                        width: double.infinity,
                                        height: 85.h,
                                        color: controller.containerColor
                                            .withOpacity(0.6),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w, vertical: 20.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SunRiseSetItem(
                                                  text: Strings.sunrise.tr,
                                                  value: controller
                                                      .forecastday.astro.sunrise
                                                      .formatTime(),
                                                  color: controller
                                                      .containerTextColor),
                                              5.verticalSpace,
                                              SunRiseSetItem(
                                                  text: Strings.sunset.tr,
                                                  value: controller
                                                      .forecastday.astro.sunset
                                                      .formatTime(),
                                                  color: controller
                                                      .containerTextColor),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                10.horizontalSpace,
                                Expanded(
                                  flex: 6,
                                  child: BlurContainer(
                                    radius: 24,
                                    width: double.infinity,
                                    height: 190.h,
                                    color: controller.containerColor
                                        .withOpacity(0.6),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          15.w, 15.h, 15.w, 10.h),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          WeatherRowData(
                                            text: Strings.humidity.tr,
                                            value:
                                                '${controller.forecastday.day.avghumidity.toInt()}%',
                                            color:
                                                controller.containerTextColor,
                                          ),
                                          5.verticalSpace,
                                          WeatherRowData(
                                            text: Strings.realFeel.tr,
                                            value:
                                                '${controller.forecastday.day.avgtempC.toInt()}°',
                                            color:
                                                controller.containerTextColor,
                                          ),
                                          5.verticalSpace,
                                          WeatherRowData(
                                            text: Strings.uv.tr,
                                            value:
                                                '${controller.forecastday.day.uv.toInt()}',
                                            color:
                                                controller.containerTextColor,
                                          ),
                                          5.verticalSpace,
                                          WeatherRowData(
                                            text: Strings.chanceOfRain.tr,
                                            value:
                                                '${controller.forecastday.day.dailyChanceOfRain}%',
                                            color:
                                                controller.containerTextColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
