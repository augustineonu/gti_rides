import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/models/auth/sign_up_request_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/utils.dart';

class SignUpController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger logger = Logger('SignUpController');

  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  PageController pageController = PageController();
  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  RxBool isLoading = false.obs;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();

  SignUpController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
  }

  @override
  void onInit() {
    // pageController.addListener(pageListener);
    super.onInit();
  }

  void onPageChanged(int value) {
    currentIndex.value = value;
    pageController.animateToPage(
      value,
      duration:
          const Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.ease,
    );
    update();
  }

  void obscurePassword() {
    showPassword.value = !showPassword.value;
    update();
  }

  // navigation method
  void routeToLogin() => routeService.offAllNamed(AppLinks.login);
  void routeToOtpVerification() => routeService.gotoRoute(AppLinks.verifyOtp);

  Future<void> processSignup() async {
    if (!signUpFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final ApiResponseModel result = await authService.signUp(
          payload: SignUpRequestModel(
        fullName: fullNameController.text,
        emailAddress: emailController.text,
        phoneNumber: phoneNoController.text,
        password: passwordController.text,
        referralCode: referralCodeController.text,
        userType: currentIndex.value == 0 ? 'renter' : 'owner',
      ).toJson());

      // logger.log(result.message.toString());
      if (result.status == 'success' || result.status_code == 200) {
        await showSuccessSnackbar(message: result.message);
        routeService.offAllNamed(AppLinks.verifyOtp, arguments: {
          'email': emailController.text,
        });
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
    pageController.dispose();
    super.dispose();
  }
}
