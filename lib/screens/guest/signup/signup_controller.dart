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

  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> ownerSignUpFormKey = GlobalKey<FormState>();

  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  PageController pageController = PageController();
  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  RxBool isLoading = false.obs;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController ownerFullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ownerEmailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController ownerPhoneNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ownerPasswordController = TextEditingController();
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
    if ((signUpFormKey.currentState != null &&
            !signUpFormKey.currentState!.validate()) ||
        (ownerSignUpFormKey.currentState != null &&
            !ownerSignUpFormKey.currentState!.validate())) {
      return;
    }

    isLoading.value = true;

    try {
      // Use the right set of controllers based on the selected user type
      final SignUpRequestModel signUpRequest = SignUpRequestModel(
        fullName: currentIndex.value == 0
            ? fullNameController.text
            : ownerFullNameController.text,
        emailAddress: currentIndex.value == 0
            ? emailController.text
            : ownerEmailController.text,
        phoneNumber: currentIndex.value == 0
            ? phoneNoController.text
            : ownerPhoneNoController.text,
        password: currentIndex.value == 0
            ? passwordController.text
            : ownerPasswordController.text,
        userType: currentIndex.value == 0 ? 'renter' : 'owner',
      );

      logger.log("email ${signUpRequest.emailAddress}");
      // Check if referralCode is not empty before including it in the payload
      if (currentIndex.value == 0 && referralCodeController.text.isNotEmpty) {
        signUpRequest.referralCode = referralCodeController.text;
      }
      final result = await authService.signUp(payload: signUpRequest.toJson());

      // logger.log(result.message.toString());

      if (result.status == 'success' || result.status_code == 200) {
        await showSuccessSnackbar(message: result.message);

        await routeService.gotoRoute(AppLinks.verifyOtp, arguments: {
          'emailOrPhone': signUpRequest.emailAddress,
        });
      } else {
        await showErrorSnackbar(message: result.message);
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
    fullNameController.dispose();
    ownerFullNameController.dispose();
    emailController.dispose();
    ownerEmailController.dispose();
    phoneNoController.dispose();
    ownerPhoneNoController.dispose();
    passwordController.dispose();
    ownerPasswordController.dispose();
    referralCodeController.dispose();
  }
}
