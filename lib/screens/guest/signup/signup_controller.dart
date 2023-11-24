import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';

class SignUpController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger logger = Logger('SignUpController');
  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  PageController pageController = PageController();
  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;

  TextEditingController emailOrPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  SignUpController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
  }

  @override
  void onInit() {
    // pageController.addListener(pageListener);
    super.onInit();
  }

  void onPageChanged(int value) {
    currentIndex.value = value;
    pageController.animateToPage(
      value,
      duration:
          const Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.ease,
    );
    update();
  }

  void obscurePassword() {
    showPassword.value = !showPassword.value;
    update();
  }

  // navigation method
  void routeToLogin() => routeService.offAllNamed(AppLinks.login);
  void routeToOtpVerification() => routeService.gotoRoute(AppLinks.verifyOtp);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
