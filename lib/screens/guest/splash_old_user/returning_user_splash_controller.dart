import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/auth/login_request_model.dart';
import 'package:gti_rides/models/auth/token_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/device_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/storage_service.dart';
import 'package:gti_rides/services/token_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ReturningUserSplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger logger = Logger('ReturningUserSplashController');
  final animationValue = 0.0.obs;
  late AnimationController _animationController;

  ReturningUserSplashController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
    initAnimation();
    deviceService.getDeviceInfo();
  }

  Future<void> getSavedUserModel() async {
    final UserModel? userModel = await userService.getUserData();
    final TokenModel? tokenModel = await tokenService.getTokensData();
    if (tokenModel != null) {
      logger.log("User token: ${tokenModel!.accessToken}");

      //   // setup and move to home screen
      tokenService.saveTokensData(tokenModel);
      tokenService.setAccessToken(tokenModel.accessToken);

      bool hasExpired = JwtDecoder.isExpired(tokenModel.accessToken!);
      logger.log("token status:: $hasExpired");

      logger.log("User model >>: ${userModel!.toJson()}");
      if (hasExpired) {
        // get new access token
        bool result = await tokenService.getNewAccessToken();
        if (!result) {
          // move to welcome screen
          logger.log('Going to Login screen');
          routeService.offAllNamed(AppLinks.login);
          return;
        }
        //   // move to home screen
          final response = await authService.getProfile();
        if (response.status == "success" || response.status_code == 200) {
          // persist user data
          logger.log("user ${response.data.toString()}");
          final UserModel userModel = UserModel.fromJson(response.data?[0]);
          userService.setCurrentUser(userModel.toJson());
          // persist data
          await userService.saveUserData(userModel);

          if (userModel.userType.toString() == "renter") {
            await routeService.gotoRoute(AppLinks.carRenterLanding);
          } else {
            await routeService.gotoRoute(AppLinks.carOwnerLanding);
          }
        } else {
          routeService.offAllNamed(AppLinks.login);
        }
      } else {
        final response = await authService.getProfile();
        if (response.status == "success" || response.status_code == 200) {
          // persist user data
          logger.log("user ${response.data.toString()}");
          final UserModel userModel = UserModel.fromJson(response.data?[0]);
          userService.setCurrentUser(userModel.toJson());
          // persist data
          await userService.saveUserData(userModel);

          if (userModel.userType.toString() == "renter") {
            await routeService.gotoRoute(AppLinks.carRenterLanding);
          } else {
            await routeService.gotoRoute(AppLinks.carOwnerLanding);
          }
        } else {
          routeService.offAllNamed(AppLinks.login);
        }
      }

      logger.log('Going to home screen');
      return;
    } else {
      // move to login screen
      logger.log("going to login");
      routeService.offAllNamed(AppLinks.login);
      return;
    }
  }

  void initAnimation() {
    logger.log("animation started");
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    final animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves
          .elasticIn, // Use a different curve for the desired animation effect
    );

    animation.addListener(() {
      animationValue.value = animation.value;
    });

    // Start the animation when the controller is initialized
    _animationController.forward();

    // listen to animation completion and navigate to the login screen
    _animationController.addListener(() {
      logger.log("animation completed");
      if (_animationController.status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () async {
          await getSavedUserModel();
          // routeService.gotoRoute(AppLinks.onboarding);
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
