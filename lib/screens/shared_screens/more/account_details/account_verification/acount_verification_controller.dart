import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/models/banks_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/more_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/utils/utils.dart';

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
  TextEditingController phoneController =
      TextEditingController(text: userService.user.value.phoneNumber);
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> emailVerificationFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();

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

  Future<void> requestOtp() async {
    if (!phoneFormKey.currentState!.validate()) {
      return;
    }
    ApiResponseModel result;
    ApiResponseModel response;
    try {
      var formData = dio.FormData.fromMap({
        "phoneNumber": phoneController.text,
      });
      response = await userService.updateProfile(payload: formData);
      if (response.status == "success") {
        result = await moreService
            .resendOtp(payload: {"user": userService.user.value.emailAddress});

        if (result.message == "success" || result.status_code == 200) {
          await showSuccessSnackbar(message: "Kindly verifyfy OTP to continue");
          logger.log("refresh user details ${response.data.toString()}");
          final UserModel userModel = UserModel.fromJson(response.data[0]);
          userService.setCurrentUser(userModel.toJson());
          
          await routeService.gotoRoute(AppLinks.phoneOtp,
              arguments: {'email': userService.user.value.emailAddress});
          // await routeService.getOff(
          //   AppLinks.more,
          // );
        } else {
          await showErrorSnackbar(message: result.message!);
          logger.log("error requesting OTP${result.message!}");
        }
      } else {
        await showErrorSnackbar(message: response.message!);
        logger.log("error requesting OTP${response.message!}");
      }
    } catch (e) {
      logger.log("error : $e");
      showErrorSnackbar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
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
