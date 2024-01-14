import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/payment_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/token_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:dio/dio.dart' as dio;

class VerifyAccountOtpController extends GetxController {
  Logger logger = Logger('VerifyAccountOtpController');
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
  String fullName = '';
  String bankName = '';
  String bankCode = '';
  String accountNumber = '';
  // RxBool isResetPassword = false.obs;

  late Timer timer;
  RxString countdownText = '2:00'.obs;

  VerifyAccountOtpController() {
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

    if (arguments != null) {
      email = arguments['email'];
      fullName = arguments['fullName'];
      bankName = arguments['bankName'];
      bankCode = arguments['bankCode'];
      accountNumber = arguments['accountNumber'];

      // Now you have access to the passed data (emailOrPhone)
      logger.log('Received email: $email');
      logger.log('Received fullName: $fullName');
    }
  }

  void onFocusChange() => update();

  void togglePasswordShow() {
    showPassword.value = !showPassword.value;
  }

  void goBack() => routeService.goBack();
  void goBack1() => routeService.goBack(closeOverlays: true);

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
        // await showSuccessSnackbar(message: result.message!);

        // save new access token as backend sends new one when OTP is verified
        await tokenService.setTokenModel(result.data);
        tokenService.setAccessToken(result.data["accessToken"]);
        logger.log("saved new token:: ${result.data["accessToken"]}");
        logger.log("access token:: ${tokenService.accessToken}");

        await addBankAccount();

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

  Future<void> addBankAccount() async {
    try {
      final result = await paymentService.addBanAccount(data: {
        "fullName": fullName,
        "bankName": bankName,
        "bankCode": bankCode,
        "accountNumber": accountNumber,
        "otp": pinController.text
      });

      if (result.status == "success" || result.status_code == 200) {
        await showSuccessSnackbar(message:  'Success');

        Future.delayed(const Duration(seconds: 3))
            .then((value) => routeService.goBack(closeOverlays: true));

        logger.log("bank account added:: ${result.data}");
      } else {
        showErrorSnackbar(message: result.message!);
        logger.log("error adding bank account ${result.message!}");
      }
    } catch (e) {
      logger.log("error: $e");
      showErrorSnackbar(message: e.toString());
    }
  }

  Future<void> resendOtp({
    required String emailOrPhone,
  }) async {
    startCountdown();
    pinController.clear();
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
    // need to test this more
    isCountDownFinished.value = false;
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
    pinController.clear();
  }
}
