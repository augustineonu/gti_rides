import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/auth/login_request_model.dart';
import 'package:gti_rides/models/auth/token_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/api_service.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/biometric_service.dart';
import 'package:gti_rides/services/device_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/storage_service.dart';
import 'package:gti_rides/services/token_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger logger = Logger('LoginController');
  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  PageController controller = PageController();
  RxBool isDone = false.obs;
  // RxBool? isFirstTimeLogin;
  RxBool showPassword = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  // RxBool? isFirstTimeLogin;

  TextEditingController emailOrPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  LoginController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
  }

  @override
  void onInit() async {
    super.onInit();
    // isFirstTimeLogin.value;
    // isFirstTimeLogin = await storageService.fetch("firstTimeLogin");
  }

  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void routeToSignUp() => routeService.gotoRoute(AppLinks.signUp);
  void routeToLandingPage() =>
      routeService.gotoRoute(AppLinks.carRenterLanding);
  void routeToRequestRestePassword() =>
      routeService.gotoRoute(AppLinks.requestResetPassword);

  List<UserModel> parseUserList(List<dynamic> list) {
    return List<UserModel>.from(
      list.map((item) => UserModel.fromJson(item)),
    );
  }

  Future<bool?> firstTimeLoginCheck() async {
    bool? value = await storageService.fetch('firstTimeLogin');
    if (value == null || value == true) {
      return true;
    } else {
      return false;
    }
  }

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
        if (result.message!.contains('Email not')) {
          // call request OTP
          await authService
              .resendOTP(payload: {"user": emailOrPhoneController.text});

          await showSuccessSnackbar(message: result.message!);
          await routeService.gotoRoute(AppLinks.verifyOtp,
              arguments: {'emailOrPhone': emailOrPhoneController.text});
        }
        showErrorSnackbar(message: result.message!);
        // routeService.offAllNamed(AppLinks.verifyOtp, arguments: {
        //   'email': emailController.text,
        // });
      } else {
        TokenModel tokenModel = TokenModel.fromJson(result.data);

        tokenService.saveTokensData(tokenModel);
        tokenService.setTokenModel(result.data!);
        tokenService.setAccessToken(result.data!["accessToken"]);
        logger.log("set token:: ${result.data!["accessToken"]}");

        var isFirstTimeLogin = await firstTimeLoginCheck();

        if (isFirstTimeLogin!) {
          await sendFirebaseToken();
          final res = await authService
              .addBiometric(payload: {"biometricID": deviceService.deviceId.value});
          if (res.status == "success" || res.status_code == 200) {
            isFirstTimeLogin = false;
            await storageService.insert('firstTimeLogin', isFirstTimeLogin!);
            logger.log("${res.status} ${res.message}");
             bool? value = await storageService.fetch('firstTimeLogin');
             logger.log("firstTimeLogin valeu $value");
          } else {
            logger.log("${res.status} ${res.message}");
          }
        }
        // await getProfileBeforeRouting(result.message!);
        final response = await authService.getProfile();
        if (response.status == "success" || response.status_code == 200) {
          // persist user data
          logger.log("user ${response.data.toString()}");
          final UserModel userModel = UserModel.fromJson(response.data?[0]);
          userService.setCurrentUser(userModel.toJson());
          // persist data
          await userService.saveUserData(userModel);
          await showSuccessSnackbar(message: result.message!);

          if (userModel.userType.toString() == "renter") {
            await routeService.gotoRoute(AppLinks.carRenterLanding);
          } else {
            await routeService.gotoRoute(AppLinks.carOwnerLanding);
          }
        }
      }
    } catch (e) {
      logger.log("error rrr: $e");
      showErrorSnackbar(message: e.toString());
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

  Future<void> getProfileBeforeRouting(String? message) async {
    final response = await authService.getProfile();
    if (response.status == "success" || response.status_code == 200) {
      // persist user data
      logger.log("user ${response.data.toString()}");
      final UserModel userModel = UserModel.fromJson(response.data?[0]);
      userService.setCurrentUser(userModel.toJson());
      // persiste data
      await userService.saveUserData(userModel);
      await showSuccessSnackbar(message: message!);

      if (userModel.userType.toString() == "renter") {
        await routeService.gotoRoute(AppLinks.carRenterLanding);
      } else {
        await routeService.gotoRoute(AppLinks.carOwnerLanding);
      }
    }
  }

  Future<void> biometricLogin() async {
    final UserModel? userModel = await userService.getUserData();
    logger.log("user:: ${userModel?.emailAddress ?? "NO USER FOUND"}");

    final authenticated = await biometricService.authenticate(
        message: 'Please authenticate to Login into your account');

    final biometrics = await biometricService.getBiometrics();
    if (authenticated) {
      // call login with biometrics
      logger.log("User authenticated");

      final isFirstTimeLogin = await firstTimeLoginCheck();
      if (isFirstTimeLogin!) {
        await showErrorSnackbar(
            message: AppStrings.kindlyLoginWithCredToSetBiometrics);
      } else {
        try {
          isLoading1.value = true;
          final response = await authService.biometricLogin(payload: {
            "user": userModel?.emailAddress!,
            "biometricID": deviceService.deviceId.value
          });
          if (response.status == "success" || response.status_code == 200) {
            tokenService.setTokenModel(response.data!);
            tokenService.setAccessToken(response.data!["accessToken"]);
            logger.log("set token:: ${response.data!["accessToken"]}");

            final profileResponse = await authService.getProfile();

            if (profileResponse.status == "success" ||
                profileResponse.status_code == 200) {
              // persist user data
              logger.log("user ${profileResponse.data.toString()}");
              final UserModel userModel =
                  UserModel.fromJson(profileResponse.data?[0]);
              userService.setCurrentUser(userModel.toJson());
              // persiste data
              await userService.saveUserData(userModel);
              await showSuccessSnackbar(message: profileResponse.status!);

              if (userModel.userType.toString() == "renter") {
                await routeService.gotoRoute(AppLinks.carRenterLanding);
              } else {
                await routeService.gotoRoute(AppLinks.carOwnerLanding);
              }
            }
          } else {
            logger.log("failed: ${response.message}");
            isLoading1.value = false;
            showErrorSnackbar(message: "${response.message}");
          }
        } catch (e) {
          logger.log("error rrr: $e");
          showErrorSnackbar(message: e.toString());
        } finally {
          isLoading1.value = false;
        }
      }
    } else if (biometrics.isEmpty) {
      infoDialog(
        content: "No biometrics",
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
