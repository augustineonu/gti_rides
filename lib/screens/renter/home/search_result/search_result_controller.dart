import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/cars_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/utils.dart';

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
  RxInt updateIndex = 0.obs;
  DateTime? rawStartTime;
  DateTime? rawEndTime;

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
      rawStartTime = arguments?["rawStartTime"] ?? DateTime.now();
      rawEndTime = arguments?["rawEndTime"] ?? DateTime.now();
      selectedStateCode.value = arguments?["selectedStateCode"] ?? 0;
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
  void routeToCarSelection({Object? arguments}) =>
      routeService.gotoRoute(AppLinks.carSelectionResult, arguments: arguments);

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

  RxBool isFetchingCars = false.obs;
  RxBool isFetchi = false.obs;
  // RxList<CarData> cars = <CarData>[].obs;
  RxString selectedStateCode = ''.obs;

  Future<void> searchCars({
    required String brandCode,
    required String brandModelCode,
    required String yearCode,
    required String startPricing,
    required String endPricing,
    required String priceArrangement,
  }) async {
    isFetchingCars.value = true;
    try {
      final response = await renterService.searchCars(
        stateCode: selectedStateCode.value,
        startDate: rawStartTime!.toIso8601String(),
        endDate: rawEndTime!.toIso8601String(),
        brandCode: brandCode, brandModelCode: brandModelCode,
        yearCode: yearCode,
        // startPricing: startPricing, endPricing: endPricing,
        // priceArrangement: priceArrangement
      );
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten cars  ${response.data}");

        if (response.data == null || response.data!.isEmpty) {
          // If the list is empty
          carListData!.value = [];
          // selectedType.value = LocationType.state;
          // Get.back();
          showSuccessSnackbar(
            title: 'Cars not found',
            message: 'No car for selected filter!',
          );
          // logger.log("cars $cars");
        } else {
          // If the list is not empty
          List<CarData> carDataList = List<CarData>.from(
            response.data!.map((car) => CarData.fromJson(car)),
          );

          carListData!.value = carDataList;
          carListData!.refresh();
          update();

          logger.log("cars:: ${carListData}");
          update();

          // showSuccessSnackbar(
          //   title: 'Cars for Location',
          //   message: 'Available!',
          // );
          isFetchingCars.value = false;
          // update();
        }
      } else {
        logger.log("unable to get city ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
    } finally {
      isFetchingCars.value = false;
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
