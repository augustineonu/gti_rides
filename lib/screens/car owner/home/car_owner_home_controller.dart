import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/utils/utils.dart';

import '../../../services/route_service.dart';

class CarOwnerHomeController extends GetxController {
  Logger logger = Logger('CarOwnerHomeController');
  late Timer timer;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;

  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  Rx<String> exampleText = "example".obs;
  late PageController cardPageController;
  ScrollController scrollController = ScrollController();

  TextEditingController emailOrPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  CarOwnerHomeController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
  }

  onPageChanged(int index) {}
  @override
  void onInit() {
    super.onInit();
    cardPageController = PageController(initialPage: 0);

    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentIndex.value < 2) {
        currentIndex.value++;
      } else {
        currentIndex.value = 0;
      }

      if (scrollController.hasClients) {
        cardPageController.animateToPage(
          currentIndex.value,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void routeToSignUp() => routeService.gotoRoute(AppLinks.signUp);
  void routeToLandingPage() =>
      routeService.gotoRoute(AppLinks.carRenterLanding);
  void routeToSearchCity() => routeService.gotoRoute(AppLinks.searchCity);
  void routeToCarRenterLanding() => routeService.gotoRoute(AppLinks.carRenterLanding);
  void routeTolistVehicle() => routeService.gotoRoute(AppLinks.listVehicle);
  void routeToManageVehicle() => routeService.gotoRoute(AppLinks.manageVehicle);

   Future<void> switchProfileToRenter() async {
    isLoading.value = true;
    try {
      final result =
          await renterService.switchProfile(payload: {"userType": "renter"});

      if (result.status == "success" || result.status_code == 200) {
        await showSuccessSnackbar(message: result.message!);
        logger.log("success message::: ${result.message}");
        await routeService.offAllNamed(AppLinks.carRenterLanding);
      } else {
        await showErrorSnackbar(message: result.message!);
      }
    } catch (e) {
      logger.log("error rrr: $e");
      showErrorSnackbar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    timer.cancel(); // Cancel the timer when the controller is disposed.
    super.onClose();
  }
}
