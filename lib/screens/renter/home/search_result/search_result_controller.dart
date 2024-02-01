import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/partner/car_list_model.dart';
import 'package:gti_rides/models/renter/cars_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';

class SearchResultController extends GetxController {
  Logger logger = Logger("Controller");

  // List<CarData>? carsArgument = Get.arguments;
  Map<String, dynamic>? arguments = Get.arguments;
  RxBool isLoading = false.obs;
  Rx<String> selectedState = "".obs;
  Rx<String> selectedCity = "".obs;
  RxList<CarData>? carListData = <CarData>[].obs;
  Rx<String> startDate = ''.obs;
  Rx<String> endDate = ''.obs;
  RxInt currentIndex = 0.obs;
  PageController pageController = PageController();
  Rx<String> startDateTime = ''.obs;
  Rx<String> endDateTime = ''.obs;
  Rx<int> differenceInDays = 0.obs;

  SearchResultController() {
    init();
  }

  void init() {
    logger.log("SearchResultController Initialized");

    if (arguments != null) {
      logger.log("Received arguments: ${arguments}");
      logger.log("Received arguments: ${arguments}");
      carListData?.value = arguments?["cars"] ?? [];
      selectedCity.value = arguments?['selectedCity'] ?? '';
      selectedState.value = arguments?['selectedState'] ?? '';
      startDate.value = arguments?['startDate'] ?? '';
      endDate.value = arguments?['endDate'] ?? '';
      startDateTime.value = arguments?['startDateTime'] ?? '';
      endDateTime.value = arguments?['endDateTime'] ?? '';
      differenceInDays.value = arguments?["differenceInDays"] ?? 0;
    }
  }

  @override
  void onInit() async {
    update();

    super.onInit();
  }

  void goBack({closeOverlays = true}) => routeService.goBack();
  void routeToSearchFilter() => routeService.gotoRoute(AppLinks.searchFilter);
  void routeToCarSelection( {  Object? arguments}) =>
      routeService.gotoRoute(AppLinks.carSelectionResult,
      arguments: arguments
      );

  void onPageChanged(int value) {
    currentIndex.value = value;
    pageController.animateToPage(
      value,
      duration:
          const Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.easeIn,
    );
    update();
  }
}
