import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger logger = Logger('LoginController');
  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  PageController controller = PageController();
  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;

  TextEditingController emailOrPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
  }

  @override
  void onInit() {
    super.onInit();
  }

  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void routeToSignUp() => routeService.gotoRoute(AppLinks.signUp);
  void routeToLandingPage() => routeService.gotoRoute(AppLinks.landingPage);

  @override
  void dispose() {
    super.dispose();
  }
}
