import 'dart:ui';

import 'package:get/get.dart';

import '../../../../config/theme/my_theme.dart';
import '../../../../config/translations/localization_service.dart';
import '../../../../generated/assets.dart';
import '../../../../utils/constants.dart';
import '../../../components/custom_loading_overlay.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../data/models/weather_details_model.dart';
import '../../../data/models/weather_model.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';
import '../../../services/location_service.dart';
import '../views/widgets/location_dialog.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  // get the current language code
  var currentLanguage = LocalizationService.getCurrentLocal().languageCode;

  // hold current weather data
  late WeatherModel currentWeather;

  var forecastday = Rx<Forecastday?>(null);

  final days = 3;
  late WeatherDetailsModel weatherDetails;

  // hold the weather arround the world
  List<WeatherModel> weatherArroundTheWorld = [];

  // for update
  final dotIndicatorsId = 'DotIndicators';
  final themeId = 'Theme';

  // api call status
  ApiCallStatus apiCallStatus = ApiCallStatus.loading;

  // for app theme
  var isLightTheme = MySharedPref.getThemeIsLight();

  // for weather slider and dot indicator
  var activeIndex = 0;

  static Color containerColor = const Color(0xff91b4c6);
  static Color containerTextColor = const Color(0xff91b4c6);

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
    if (!await LocationService().hasLocationPermission()) {
      Get.dialog(const LocationDialog());
    } else {
      getUserLocation();
    }
    super.onInit();
  }

  /// get the user location
  getUserLocation() async {
    var locationData = await LocationService().getUserLocation();
    if (locationData != null) {
      await getCurrentWeather(
          '${locationData.latitude},${locationData.longitude}');
      await getWeatherDetails(
          '${locationData.latitude},${locationData.longitude}');
    }
  }

  getWeatherDetails(String location) async {
      await BaseClient.safeApiCall(
        Constants.forecastWeatherApiUrl,
        RequestType.get,
        queryParameters: {
          Constants.key: Constants.mApiKey,
          Constants.q: location,
          Constants.days: days,
          Constants.lang: currentLanguage,
        },
        onSuccess: (response) {
          weatherDetails = WeatherDetailsModel.fromJson(response.data);
          forecastday.value = weatherDetails.forecast.forecastday[0];
          apiCallStatus = ApiCallStatus.success;
          update();
        },
        onError: (error) {
          BaseClient.handleApiError(error);
          apiCallStatus = ApiCallStatus.error;
          update();
        },
      );
  }

  /// get home screem data (sliders, brands, and cars)
  getCurrentWeather(String location) async {
    await BaseClient.safeApiCall(
      Constants.currentWeatherApiUrl,
      RequestType.get,
      queryParameters: {
        Constants.key: Constants.mApiKey,
        Constants.q: location,
        Constants.lang: currentLanguage,
      },
      onSuccess: (response) async {
        currentWeather = WeatherModel.fromJson(response.data);
        await getWeatherArroundTheWorld();
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  /// get weather arround the world
  getWeatherArroundTheWorld() async {
    weatherArroundTheWorld.clear();
    final cities = ['London', 'Cairo', 'Alaska'];
    await Future.forEach(cities, (city) {
      BaseClient.safeApiCall(
        Constants.currentWeatherApiUrl,
        RequestType.get,
        queryParameters: {
          Constants.key: Constants.mApiKey,
          Constants.q: city,
          Constants.lang: currentLanguage,
        },
        onSuccess: (response) {
          weatherArroundTheWorld.add(WeatherModel.fromJson(response.data));
          update();
        },
        onError: (error) => BaseClient.handleApiError(error),
      );
    });
  }

  /// when the user slide the weather card
  onCardSlided(index, reason) {
    activeIndex = index;
    update([dotIndicatorsId]);
  }

  /// when the user press on change theme icon
  onChangeThemePressed() {
    MyTheme.changeTheme();
    isLightTheme = MySharedPref.getThemeIsLight();
    update([themeId]);
  }

  /// when the user press on change language icon
  onChangeLanguagePressed() async {
    currentLanguage = currentLanguage == 'ar' ? 'en' : 'ar';
    await LocalizationService.updateLanguage(currentLanguage);
    apiCallStatus = ApiCallStatus.loading;
    update();
    await getUserLocation();
  }
}
