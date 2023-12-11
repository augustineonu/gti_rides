import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/utils.dart';

class RequestResetPasswordController extends GetxController {
  Logger logger = Logger('ResetPasswordController');
  RxBool isLoading = false.obs;

  Duration myDuration = const Duration(days: 5);
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conFirmPasswordController =
      TextEditingController();
  RxBool showPassword = true.obs;
  RxBool showPassword1 = true.obs;
  GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> resetPasswordFormKey1 = GlobalKey<FormState>();
  final FocusNode focus = FocusNode();
  RxString accessToken = ''.obs;

  RequestResetPasswordController() {
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
    logger.log("reset password init called");
    // Access the arguments using Get.arguments
    Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null) {
      accessToken = arguments['accessToken'];

      // Now you have access to the passed data (emailOrPhone)
      logger.log('Received accessToken: $accessToken');
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
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

  void goBack() => routeService.goBack();

  void routeToresetPassword() => routeService.gotoRoute(
        AppLinks.resetPassword,
      );
  void routeToLogin() => routeService.gotoRoute(
        AppLinks.login,
      );

  Future<void> requestResetPassword() async {
    if (!resetPasswordFormKey.currentState!.validate()) {
      return;
    }
    isLoading.value = true;

    try {
      final result = await authService
          .requestResetPassword(payload: {"user": emailOrPhoneController.text});

      if (result.status == "success" || result.status_code == 200) {
        await showSuccessSnackbar(message: result.message);
        isLoading.value = false;
        await routeService.gotoRoute(AppLinks.verifyOtp, arguments: {
          'emailOrPhone': emailOrPhoneController.text,
          "isResetPassword": true,
        });
      }
    } catch (e) {
      logger.log("error rrr: $e");
      showErrorSnackbar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    if (!resetPasswordFormKey1.currentState!.validate()) {
      return;
    }
    if (passwordController.text != conFirmPasswordController.text) {
      showErrorSnackbar(message: "Passwords do not match");
      return;
    }
    isLoading.value = true;

    try {
      final result = await authService.resetPassword(
          payload: {"password": passwordController.text},
          token: accessToken.value);

      if (result.status == "success" || result.status_code == 200) {
        await showSuccessSnackbar(message: result.message);
        await routeService.offAllNamed(AppLinks.login);
      } else {
        logger.log("error rrr: ${result.message}");
        showErrorSnackbar(message: result.message);
      }
    } catch (e) {
      logger.log("error rrr: $e");
      showErrorSnackbar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
 