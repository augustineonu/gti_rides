import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/storage_service.dart';

class OnboardingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger logger = Logger('OnboardingController');
  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  PageController controller = PageController();
  RxBool isDone = false.obs;
    bool? isFirstTimeLogin;

  OnboardingController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
    // initAnimation();
    // deviceService.getDeviceInfo();
     storageService.insert('firstTimeLogin', isFirstTimeLogin);
  }

  @override
  void onInit() {
    controller.addListener(pageListener);
    super.onInit();
  }

  void onPageChanged(int value) {
    currentIndex.value = value;
    update();
  }

  void routeToLogin() => routeService.offAllNamed(AppLinks.login);
  void routeToreturningUserSplash() => routeService.offAllNamed(AppLinks.returningUserSplash);
  void routeToSignUp() => routeService.gotoRoute(AppLinks.signUp);

  void pageListener() {
    currentIndex.value = controller.page!.round();
    isDone.value = currentIndex.value == 2;
  }

  void nextPage() {
    if (currentIndex.value < 2) {
      controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
