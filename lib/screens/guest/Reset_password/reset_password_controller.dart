import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';

class ResetPasswordController extends GetxController {
  Logger logger = Logger('OTPVerificationController');
  RxBool isLoading = false.obs;

  Duration myDuration = const Duration(days: 5);
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conFirmPasswordController =
      TextEditingController();
  RxBool showPassword = true.obs;
  RxBool showPassword1 = true.obs;
  final GlobalKey<FormState> emailVerificationFormKey = GlobalKey<FormState>();
  final FocusNode focus = FocusNode();

  ResetPasswordController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
    load();
  }

  void load() {
    logger.log('Loading');
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void onFocusChange() => update();

  void obscurePassword() {
    showPassword.value = !showPassword.value;
  }

  void obscurePassword1() {
    showPassword1.value = !showPassword1.value;
  }

  @override
  void dispose() {
    super.dispose();
    emailOrPhoneController.dispose();
  }

  void routeToresetPassword() => routeService.gotoRoute(
        AppLinks.resetPassword,
      );
}
