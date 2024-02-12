import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/cars_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/renter_service.dart';
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
    late List<PageController> pageControllers;


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
    pageControllers = List.generate(
      carListData!.length,
      (index) => PageController(),
    );
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

 void onPageChanged1(int index) {
  if (index >= 0 && index < pageControllers.length) {
    currentIndex.value = index;
    pageControllers[index].animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
    update();
  }
}


    Future<void> addRecentCar({required String carId}) async {
    isLoading.value = true;
    try {
      final response = await renterService.addRecentCar(carId: carId);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("Car added to recent:: $response");
      } else {
        logger.log("Unable to add car to recently viewed:: $response");
      }
    } catch (exception) {
      logger.log("error:: ${exception.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
