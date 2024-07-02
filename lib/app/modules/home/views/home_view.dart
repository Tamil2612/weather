import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather/app/modules/home/views/widgets/blur_container.dart';
import 'package:weather/app/modules/home/views/widgets/weather_container.dart';

import '../../../components/api_error_widget.dart';
import '../../../components/my_widgets_animator.dart';
import '../../weather/views/widgets/forecast_hour_item.dart';
import '../controllers/home_controller.dart';
import 'widgets/home_shimmer.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: GetBuilder<HomeController>(
              builder: (_) => MyWidgetsAnimator(
                apiCallStatus: controller.apiCallStatus,
                loadingWidget: () => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 23.w),
                  child: const HomeShimmer(),
                ),
                errorWidget: () => ApiErrorWidget(
                  retryAction: () => controller.getUserLocation(),
                ),
                successWidget: () {
                  // Determine the weather code for current weather
                  int weatherCode =
                      controller.currentWeather.current.condition.code;
                  String backgroundImage =
                      controller.getWeatherImage(weatherCode);
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(backgroundImage),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 23.w),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          20.verticalSpace,
                          WeatherContainer(
                            height: 370.h,
                            width: 360.w,
                            textColor: HomeController.containerTextColor,
                            weather: controller.currentWeather,
                            color: HomeController.containerColor,
                          ).animate().fade().slideY(
                                duration: 300.ms,
                                begin: 1,
                                curve: Curves.easeInSine,
                              ),
                          16.verticalSpace,
                          if (controller.forecastday.value !=
                              null) // Check if forecastday is initialized
                            BlurContainer(
                              height: 150.h,
                              width: 360.w,
                              color: HomeController.containerColor
                                  .withOpacity(0.6),
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
                                        itemCount: controller
                                            .forecastday.value!.hour.length,
                                        itemBuilder: (context, index) =>
                                            ForecastHourItem(
                                          hour: controller
                                              .forecastday.value!.hour[index], textColor: HomeController.containerTextColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animate().fade().slideX(
                                  duration: 300.ms,
                                  begin: -1,
                                  curve: Curves.easeInSine,
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
