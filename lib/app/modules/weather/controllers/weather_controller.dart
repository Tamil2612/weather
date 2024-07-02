import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/assets.dart';
import '../../../components/custom_loading_overlay.dart';
import '../../../../utils/extensions.dart';
import '../../../../config/translations/localization_service.dart';
import '../../../../config/translations/strings_enum.dart';
import '../../../../utils/constants.dart';
import '../../../data/models/weather_details_model.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';

class WeatherController extends GetxController {
  static WeatherController get instance => Get.find();

  // get the current language code
  final currentLanguage = LocalizationService.getCurrentLocal().languageCode;

  // hold the weather details & forecast day
  late WeatherDetailsModel weatherDetails;
  late Forecastday forecastday;

  // for update
  final dotIndicatorsId = 'DotIndicators';

  // for weather forecast
  final days = 3;
  //var selectedDay = 'Today';
  var selectedDay = Strings.today.tr;

  // api call status
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  // for weather card slider
  late PageController pageController;

  // for weather slider and dot indicator
  var currentPage = 0;
  static const List<int> rainyCodes = [
    1063,
    1072,
    1150,
    1153,
    1168,
    1171,
    1180,
    1183,
    1186,
    1189,
    1192,
    1195,
    1198,
    1201,
    1240,
    1243,
    1246,
    1249,
    1252,
    1261,
    1264,
    1273,
    1276
  ];

  static const List<int> sunnyCodes = [1000, 1003];

  static const List<int> snowCodes = [
    1066,
    1069,
    1114,
    1117,
    1210,
    1213,
    1216,
    1219,
    1222,
    1225,
    1237,
    1249,
    1252,
    1255,
    1258,
    1261,
    1264,
    1279,
    1282
  ];

  static const List<int> cloudyCodes = [1006, 1009, 1030, 1135, 1147];

   Color containerColor = const Color(0xff91b4c6);
   Color containerTextColor = const Color(0xff91b4c6);


  String getWeatherImage(int code) {
    if (rainyCodes.contains(code)) {
      containerColor = const Color(0xff40666A);
      containerTextColor = const Color(0xffC9E8E0);
      return Assets.imagesRainy;
    } else if (sunnyCodes.contains(code)) {
      containerColor = const Color(0xffFAE2BD);
      containerTextColor = const Color(0xffEFAA82);
      return Assets.imagesSunny;
    } else if (snowCodes.contains(code)) {
      containerColor = const Color(0xff99B8CC);
      containerTextColor = const Color(0xffE4F1F9);
      return Assets.imagesSnow;
    } else if (cloudyCodes.contains(code)) {
      containerColor = const Color(0xff91B4C6);
      containerTextColor = const Color(0xffCAD7DF);
      return Assets.imagesCloudy;
    } else {
      return Assets.imagesCloudy; // Default image for undefined codes
    }
  }


  @override
  void onInit() async {
    pageController = PageController(
      initialPage: currentPage, viewportFraction: 0.8,
    );
    super.onInit();
  }

  @override
  void onReady() {
    getWeatherDetails();
    super.onReady();
  }

  /// get current language
  bool get isEnLang => currentLanguage == 'en';

  /// get weather details
  getWeatherDetails() async {
    await showLoadingOverLay(
      asyncFunction: () async => await BaseClient.safeApiCall(
        Constants.forecastWeatherApiUrl,
        RequestType.get,
        queryParameters: {
          Constants.key: Constants.mApiKey,
          Constants.q: Get.arguments,
          Constants.days: days,
          Constants.lang: currentLanguage,
        },
        onSuccess: (response) {
          weatherDetails = WeatherDetailsModel.fromJson(response.data);
          forecastday = weatherDetails.forecast.forecastday[0];
          apiCallStatus = ApiCallStatus.success;
          update();
        },
        onError: (error) {
          BaseClient.handleApiError(error);
          apiCallStatus = ApiCallStatus.error;
          update();
        },
      ),
    );
  }

  /// when the user change the selected day
  onDaySelected(String day) {
    selectedDay = day;
    var index = weatherDetails.forecast.forecastday.indexWhere((fd) {
      return fd.date.convertToDay() == day;
    });

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
    onCardSlided(index);
  }

  /// when the user slide the weather card
  onCardSlided(int index) {
    forecastday = weatherDetails.forecast.forecastday[index];
    selectedDay = forecastday.date.convertToDay();
    currentPage = index;
    update();
  }
}
