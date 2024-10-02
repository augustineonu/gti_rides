import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/models/auth/sign_up_request_model.dart';
import 'package:gti_rides/models/auth/social_signup_request_model.dart';
import 'package:gti_rides/models/auth/token_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/device_service.dart';
import 'package:gti_rides/services/google_sign_in_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/storage_service.dart';
import 'package:gti_rides/services/token_service.dart';
import 'package:gti_rides/services/user_service.dart';
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
  TextEditingController lastNameController = TextEditingController();
  TextEditingController ownerFullNameController = TextEditingController();
  TextEditingController ownerLastNameController = TextEditingController();
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
  void routeToRenterLanding() => routeService.gotoRoute(AppLinks.carRenterLanding);

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
            ? "${fullNameController.text} ${lastNameController.text}"
            : "${ownerFullNameController.text} ${ownerLastNameController.text}}",
        emailAddress: currentIndex.value == 0
            ? emailController.text
            : ownerEmailController.text,
        phoneNumber: currentIndex.value == 0
            ? phoneNoController.text
            : ownerPhoneNoController.text,
        password: currentIndex.value == 0
            ? passwordController.text
            : ownerPasswordController.text,
        userType: currentIndex.value == 0 ? 'renter' : 'partner',
      );

      logger.log("email ${signUpRequest.emailAddress}");
      // Check if referralCode is not empty before including it in the payload
      if (currentIndex.value == 0 && referralCodeController.text.isNotEmpty) {
        signUpRequest.referralCode = referralCodeController.text;
      }
      final result = await authService.signUp(payload: signUpRequest.toJson());

      // logger.log(result.message.toString());

      if (result.status == 'success' || result.status_code == 200) {
        await showSuccessSnackbar(message: result.message!);

        await routeService.gotoRoute(AppLinks.verifyOtp, arguments: {
          'emailOrPhone': signUpRequest.emailAddress,
        });
      } else {
        await showErrorSnackbar(message: result.message!);
      }
    } catch (e) {
      logger.log("error rrr: $e");
      if (e
          .toString()
          .contains("type 'Null' is not a subtype of type 'String'")) {
        showErrorSnackbar(message: "Failed to sign up. Please try again");
        return;
      } else {
        showErrorSnackbar(message: e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendFirebaseToken() async {
    final response = await deviceService.addNotificationToken();
    try {
      if (response.status_code == 200) {
        logger.log("Success:: ${response.message} ");
      } else {
        logger.log("Failed:: ${response.message} ");
      }
    } catch (exception) {
      logger.log("Exception:: ${exception.toString()} ");
    }
  }

  Future<void> googleSignUp() async {
    try {
      final Map<String, dynamic>? result =
          await googleSignInService.signInWithGoogle();
      if (result != null) {
        logger.log("user google detials ${result}");
        final response = await authService.socialSignUp(
            payload: SocialSignUpRequestModel(
                    fullName: result["fullName"],
                    emailAddress: result["email"],
                    socialType: "google",
                    socialId: result["googleId"])
                .toJson());
        logger.log("google signin: ${response}");
        if (response.status == "success" || response.status_code == 200) {
          // save user token
          TokenModel tokenModel = TokenModel.fromJson(response.data);

          tokenService.saveTokensData(tokenModel);
          tokenService.setTokenModel(response.data!);
          tokenService.setAccessToken(response.data!["accessToken"]);

          // check if it's the first time user logged in on this device
          // then send firebase token
          var isFirstTimeLogin = await firstTimeLoginCheck();

          if (isFirstTimeLogin!) {
            await sendFirebaseToken();
            final res = await authService.addBiometric(
                payload: {"biometricID": deviceService.deviceId.value});
            if (res.status == "success" || res.status_code == 200) {
              isFirstTimeLogin = false;
              await storageService.insert('firstTimeLogin', isFirstTimeLogin!);
              userService.saveData('firstTimeLogin', 'false');
              logger.log("${res.status} ${res.message}");
              bool? value = await storageService.fetch('firstTimeLogin');
              logger.log("firstTimeLogin valeu $value");
            } else {
              logger.log("${res.status} ${res.message}");
            }
          }

          // get user profile before routing user to landing page
          final profile = await authService.getProfile();
          // logger.log("profile: ${profile.message}");
          if (response.status == "success" || response.status_code == 200) {
            // persist user data
            logger.log("user ${profile.data.toString()}");
            final UserModel userModel = UserModel.fromJson(profile.data?[0]);
            userService.setCurrentUser(userModel.toJson());
            // persist data
            await userService.saveUserData(userModel);
          }
          await showSuccessSnackbar(message: response.message!);
          // return;
          await routeService.offAllNamed(AppLinks.carRenterLanding);
        } else {
          logger.log("error: ${response.message}");
          await showErrorSnackbar(message: response.message!);
        }
      }
    } catch (e) {
      logger.log("error rrr: $e");
      if (e
          .toString()
          .contains("type 'Null' is not a subtype of type 'String'")) {
        showErrorSnackbar(
            message: "Failed to sign in with Google. Please try again.");
        return;
      } else {
        showErrorSnackbar(message: e.toString());
      }
    }
  }


  Future<bool?> firstTimeLoginCheck() async {
    String? value = await userService.getData('firstTimeLogin');
    if (value == null || value == 'true') {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
    fullNameController.dispose();
    lastNameController.dispose();
    ownerFullNameController.dispose();
    ownerLastNameController.dispose();
    emailController.dispose();
    ownerEmailController.dispose();
    phoneNoController.dispose();
    ownerPhoneNoController.dispose();
    passwordController.dispose();
    ownerPasswordController.dispose();
    referralCodeController.dispose();
  }
}
