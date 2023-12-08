import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/auth/login_request_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/utils.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger logger = Logger('LoginController');
  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  PageController controller = PageController();
  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  RxBool isLoading = false.obs;

  TextEditingController emailOrPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

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
  void routeToLandingPage() =>
      routeService.gotoRoute(AppLinks.carRenterLanding);

  Future<void> processLogin() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final result = await authService.login(
          payload: LoginRequestModel(
        user: emailOrPhoneController.text,
        password: passwordController.text,
      ).toJson());

      // logger.log(result.message.toString());
      if (result.status == 'error' || result.status_code == 403) {
        if (result.message.contains('Email not')) {
          // call request OTP
          await authService
              .resendOTP(payload: {"user": emailOrPhoneController.text});
              
          await showSuccessSnackbar(message: result.message);
          await routeService.gotoRoute(AppLinks.verifyOtp,
              arguments: {'emailOrPhone': emailOrPhoneController.text});
        }
        await showErrorSnackbar(message: result.message);
        // routeService.offAllNamed(AppLinks.verifyOtp, arguments: {
        //   'email': emailController.text,
        // });
      } else {
        await showSuccessSnackbar(message: result.message);
      }
    } catch (e) {
      logger.log("error rrr: $e");
      showErrorSnackbar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
