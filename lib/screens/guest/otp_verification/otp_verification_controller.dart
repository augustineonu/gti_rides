import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';

import '../../../route/app_links.dart';

class OtpVerificationController extends GetxController {
  Logger logger = Logger('OTPVerificationController');
  RxBool isLoading = false.obs;
  Timer? countdownTimer;
  Duration myDuration = Duration(days: 5);
  final TextEditingController pinController = TextEditingController();
  RxBool showPassword = true.obs;
  final GlobalKey<FormState> emailVerificationFormKey = GlobalKey<FormState>();
  final FocusNode focus = FocusNode();

  OtpVerificationController() {
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

  void togglePasswordShow() {
    showPassword.value = !showPassword.value;
  }

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
