import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/pending_trips_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class CompletedTripController extends GetxController {
  Logger logger = Logger('CompletedTripController');
  CompletedTripController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(arguments != null) {
      logger.log("Received data:: ${arguments.adminStatus}");
      tripsData = arguments;
    }
  }

  AllTripsData arguments = Get.arguments as AllTripsData ;
  AllTripsData tripsData = AllTripsData();
  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  Rx<String> exampleText = "example".obs;

 

  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void goBack() => routeService.goBack();
  void routeToSignUp() => routeService.gotoRoute(AppLinks.signUp);
  void routeToLandingPage() =>
      routeService.gotoRoute(AppLinks.carRenterLanding);
  void routeToSearchCity() => routeService.gotoRoute(AppLinks.searchCity);

   void copy({required String value}) async {
    await Clipboard.setData(ClipboardData(text: value));

    await showSuccessSnackbar(message: AppStrings.copied, seconds: 2);
  }
  
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
