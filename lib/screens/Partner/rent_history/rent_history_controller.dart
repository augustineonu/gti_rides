import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/Partner/home/list_vehicle/list_vehicle_screen.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';

class RentHistoryController extends GetxController {
  Logger logger = Logger("Controller");

  RentHistoryController() {
    init();
  }

  void init() {
    logger.log("RentHistoryController Initialized");
  }

  @override
  void onInit() async {
    pageController.addListener(() {
      update();
    });
    super.onInit();
  }

  // variables
  RxBool isLoading = false.obs;
  PageController pageController = PageController();
  RxInt selectedIndex = 0.obs;
  RxString testString = "".obs;

  TextEditingController senderNameController = TextEditingController();

  List<Map<String, String>> quickOptions = [
    {
      "imageUrl": ImageAssets.pencilEdit,
      "title": AppStrings.reportTripToAdin,
    },
    {
      "imageUrl": ImageAssets.history,
      "title": AppStrings.carHistory,
    },
  ];

// routing methods
  void goBack() => routeService.goBack();
  void routeToQuickEdit() => routeService.gotoRoute(AppLinks.quickEdit);
  void routeToCarHistory() => routeService.gotoRoute(AppLinks.carHistory);
  void routeToCompletedTrip() => routeService.gotoRoute(AppLinks.completedTrip);
}