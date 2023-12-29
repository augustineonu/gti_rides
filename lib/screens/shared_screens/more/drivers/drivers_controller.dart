import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';


class DriversController extends GetxController {
  Logger logger = Logger('DriversController');
  DriversController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
  }

  // late Timer timer;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;

  // late PageController cardPageController;
  ScrollController scrollController = ScrollController();

  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  Rx<String> exampleText = "".obs;




  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void goBack() => routeService.goBack();
  void goBack1() => routeService.goBack(closeOverlays: true);
  void routeToAddDriver() => routeService.gotoRoute(AppLinks.addDriver);
  void routeToHome() => routeService.gotoRoute(AppLinks.carOwnerLanding);

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    // timer.cancel(); // Cancel the timer when the controller is disposed.
    super.onClose();
  }
}
