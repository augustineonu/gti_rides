import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/token_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:dio/dio.dart' as dio;

class PhoneVerificationController extends GetxController {
  Logger logger = Logger('PhoneVerificationController');
  RxBool isLoading = false.obs;
  RxBool isDoneIputtingPin = false.obs;
  RxBool isCountDownFinished = false.obs;
  Timer? countdownTimer;
  Duration myDuration = Duration(days: 5);
  final TextEditingController pinController = TextEditingController();
  RxBool showPassword = true.obs;
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  final FocusNode focus = FocusNode();
  Rx<UserModel> user = UserModel().obs;

  String email = '';
  String newPhoneNumber = '';
  // RxBool isResetPassword = false.obs;

  late Timer timer;
  RxString countdownText = '2:00'.obs;

  PhoneVerificationController() {
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
    user = userService.user;
    startCountdown();

    // Access the arguments using Get.arguments
    Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null && arguments.containsKey('email')) {
      email = arguments['email'];
      newPhoneNumber = arguments['newPhoneNumber'];

      // Now you have access to the passed data (emailOrPhone)
      logger.log('Received email: $email');
      logger.log('Received newPhoneNumber: $newPhoneNumber');
    }
  }

  void onFocusChange() => update();

  void togglePasswordShow() {
    showPassword.value = !showPassword.value;
  }

  void goBack() => routeService.goBack();

  void routeToforgotPassword() => routeService.gotoRoute(
        AppLinks.requestResetPassword,
      );

  Future<void> verifyOtp({
    // required String emailOrPhone,
    required String otp,
  }) async {
    if (!otpFormKey.currentState!.validate()) {
      return;
    }
    isLoading.value = true;
    // ApiResponseModel response;
    try {
      final result = await authService.verifyOtp(payload: {
        "user": email, // email or phone number
        "otp": otp
      });
      if (result.status == "success" || result.status_code == 200) {
        // backend needs to change result.message to "OTP Verified Success" to
        // match all OTP verifications
        await showSuccessSnackbar(message: result.message!);
        
        // save new access token as backend sends new one when OTP is verified

        await tokenService.setTokenModel(result.data);
        tokenService.setAccessToken(result.data["accessToken"]);
        logger.log("saved new token:: ${result.data["accessToken"]}");
        logger.log("access token:: ${tokenService.accessToken}");
        var formData = dio.FormData.fromMap({
          "phoneNumber": newPhoneNumber,
        });
        final response = await userService.updateProfile(payload: formData);
        if (response.status == "success") {
          pinController.clear();
          // await userService.user.value.userId

          // After OTP verification
          if (user.value.userType == 'renter') {
            // Navigate back to the renter landing page
            routeService.offAllNamedUntill(AppLinks.carRenterLanding);
          } else {
            // Navigate back to the owner landing page
            routeService.offAllNamedUntill(AppLinks.carOwnerLanding);
          }

          // await routeService.getOff(AppLinks.more);
          // await routeService.offAllNamedUntill(AppLinks.more);
        } else {
          showErrorSnackbar(message: result.message!);
          logger.log("error updating user profile ${response.message!}");
        }

        isLoading.value = false;
      } else {
        showErrorSnackbar(message: result.message!);
        logger.log("error verifying OTP ${result.message!}");
      }
    } catch (e) {
      logger.log("error: $e");
      showErrorSnackbar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp({
    required String emailOrPhone,
  }) async {
    startCountdown();
    try {
      final result =
          await authService.resendOTP(payload: {"user": emailOrPhone});
      if (result.status == "success" || result.status_code == 200) {
        await showSuccessSnackbar(message: result.message!);
        // routeService.offAllNamed(AppLinks.login);
      } else {
        showErrorSnackbar(message: result.message!);
      }
    } catch (e) {
      logger.log("error: $e");
      showErrorSnackbar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void startCountdown() {
    const duration = Duration(minutes: 2);
    int secondsRemaining = duration.inSeconds;
    logger.log('Countdown started!');

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        updateCountdownText(secondsRemaining);
      } else {
        timer.cancel();
        // You can perform any action when the countdown reaches 0
        isCountDownFinished.value = true;
        logger.log('Countdown finished!');
      }
    });
  }

  void updateCountdownText(int secondsRemaining) {
    final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');
    countdownText.value = '$minutes:$seconds';
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    pinController.dispose();
    focus
      ..removeListener(onFocusChange)
      ..dispose();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    timer.cancel();
  }
}
