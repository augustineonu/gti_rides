import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/shared_screens/more/account_details/account_verification/change_password/chancge_password_otp.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/more_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/utils/utils.dart';

class ChangePhoneController extends GetxController {
  Logger logger = Logger('ChangePhoneController');
  RxBool isLoading = false.obs;
  RxBool isDoneIputtingPin = false.obs;
  RxBool isCountDownFinished = false.obs;
  Timer? countdownTimer;
  RxBool showOldPassword = true.obs;
  RxBool showNewPassword = true.obs;
  RxBool showConfirmPassword = true.obs;
  Duration myDuration = Duration(days: 5);
  final TextEditingController pinController = TextEditingController();
  RxBool showPassword = true.obs;
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordInputFormKey = GlobalKey<FormState>();
  final FocusNode focus = FocusNode();
  Rx<UserModel> user = UserModel().obs;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String phone = '';
  // RxBool isResetPassword = false.obs;

  late Timer timer;
  RxString countdownText = '2:00'.obs;

  ChangePhoneController() {
    init();
  }

  void init() {
    logger.log('ChangePhoneController initialized');
    load();
  }

  void load() {
    logger.log('Loading');
      user = userService.user;

      logger.log("USER:: ${user.value.emailAddress}");
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    startCountdown();
  


    // Access the arguments using Get.arguments
    Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null && arguments.containsKey('phone')) {
      phone = arguments['phone'];
      // isResetPassword.value = arguments['isResetPassword'];

      // Now you have access to the passed data (emailOrPhone)
      logger.log('Received phone: $phone');
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

  void obscureOldPassword() => showOldPassword.value = !showOldPassword.value;

  void obscureNewPassword() => showNewPassword.value = !showNewPassword.value;
  void obscureConfirmPassword() =>
      showConfirmPassword.value = !showConfirmPassword.value;

  Future<void> resetPassword() async {
    if (!passwordInputFormKey.currentState!.validate()) {
      return;
    }
    isLoading.value = true;
    ApiResponseModel result;
    ApiResponseModel response;
    try {
      result = await moreService.requestResetPassword(payload: {
        "password": oldPasswordController.text,
        "newPassword": newPasswordController.text
      });
      if (result.status == "success" || result.status_code == 200) {
        await showSuccessSnackbar(message: result.message!);
        pinController.clear();
        response = await moreService.resendOtp(payload: {
          "user": userService.user.value.emailAddress,
        });
        if (response.status == "success" || response.status_code == 200) {
          await showSuccessSnackbar(message: response.message!);
          isLoading.value = false;
          await routeService.gotoRoute(AppLinks.changePasswordOtp);
        }
        isLoading.value = false;
      } else {
        isLoading.value = false;
        showErrorSnackbar(message: result.message!);
      }
    } catch (e) {
      logger.log("error: $e");
      showErrorSnackbar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp({
    required String emailOrPhone,
    required String otp,
  }) async {
    if (!otpFormKey.currentState!.validate()) {
      return;
    }
    isLoading.value = true;
    try {
      final result = await authService.verifyOtp(payload: {
        "user": emailOrPhone, // email or phone number
        "otp": otp
      });
      if (result.status == "success" || result.status_code == 200) {
        await showSuccessSnackbar(message: result.message!);
        pinController.clear();

        // After OTP verification
        if (user.value.userType == 'renter') {
          // Navigate back to the renter landing page
          routeService.offAllNamedUntill(AppLinks.carRenterLanding);
        } else {
          // Navigate back to the owner landing page
          routeService.offAllNamedUntill(AppLinks.carOwnerLanding);
        }

        isLoading.value = false;
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

  Future<void> sendOtp() async {
    startCountdown();
    try {
      final result = await authService
          .resendOTP(payload: {"user": user.value.emailAddress});
      if (result.status == "success" || result.status_code == 200) {
        await showSuccessSnackbar(message: result.message!);
        routeService.getOff(() => const ChangePasswordOtpScreen(), arguments: {
          "oldPassword": oldPasswordController.text,
          "newPassword": newPasswordController.text
        });
      } else {
        logger.log("error resending OTP ${result.message!}");
        showErrorSnackbar(message: result.message!);
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
      newPasswordController.clear();
    oldPasswordController.clear();
    focus
      ..removeListener(onFocusChange)
      ..dispose();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
     newPasswordController.clear();
    oldPasswordController.clear();
    timer.cancel();
  }
}
