import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/banks_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';

class AccountVerificationController extends GetxController {
  Logger logger = Logger('OTPVerificationController');
  RxBool isLoading = false.obs;
  RxBool showOldPassword = true.obs;
  RxBool showNewPassword = true.obs;
  RxBool showConfirmPassword = true.obs;
  Timer? countdownTimer;
  Duration myDuration = Duration(days: 5);
  final TextEditingController pinController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> emailVerificationFormKey = GlobalKey<FormState>();
  final FocusNode focus = FocusNode();

  AccountVerificationController() {
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


  
  void goBack() => routeService.goBack();
  void onFocusChange() => update();
  void routeToVerifyEmail() => routeService.gotoRoute(AppLinks.emailOtp);
  void routeToVerifyPhoneNumber() => routeService.gotoRoute(AppLinks.phoneOtp);

  void obscureOldPassword() => showOldPassword.value = !showOldPassword.value;

  void obscureNewPassword() => showNewPassword.value = !showNewPassword.value;
  void obscureConfirmPassword() =>
      showConfirmPassword.value = !showConfirmPassword.value;
  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    countdownTimer!.cancel();
  }

  // Step 5
  void resetTimer() {
    stopTimer();
    myDuration = Duration(days: 5);
  }

  // Step 6
  void setCountDown() {
    final reduceSecondsBy = 1;

    final seconds = myDuration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      countdownTimer!.cancel();
    } else {
      myDuration = Duration(seconds: seconds);
    }
    update();
  }

  @override
  void dispose() {
    super.dispose();
    pinController.dispose();
    focus
      ..removeListener(onFocusChange)
      ..dispose();
  }

  // void printDeviceType() {
  //   logger.log(deviceService.deviceType);
  // }

  void routeToforgotPassword() => routeService.gotoRoute(
        AppLinks.requestResetPassword,
      );
}
