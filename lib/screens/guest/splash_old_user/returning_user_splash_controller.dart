import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/auth/login_request_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/device_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/storage_service.dart';
import 'package:gti_rides/services/user_service.dart';

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
    // final Agent? agentModel = await biometricService.getAgentModelData();
    final UserModel? userModel = await userService.getUserData();
    // final Tokens? tokens = await biometricService.getTokensData();
    if (userModel != null) {
    //   // setup and move to home screen
    //   agentService.setCurrentAgentModel(agentModel.toJson());
      userService.setCurrentUser(userModel.toJson());
    //   tokenService.setTokenModel(tokens!.toJson());
    //   tokenService.setAccessToken(tokens.accessToken);
    //   tokenService.setRefreshToken(tokens.refreshToken);

      logger.log("User model >>: ${userModel!.toJson()}");
      routeService.offAllNamed(AppLinks.login);
    //   // get new access token
    //   bool result = await tokenService.getNewAccessToken();
    //   if (!result) {
    //     // move to welcome screen
    //     logger.log('Going to welcome screen');
    //     routeService.offAllNamed(AppLinks.welcomeBack);
    //     return;
    //   }
    //   // move to home screen
    //   // if (agentModel.user!.isAgentOnline!) {
    //   await socketService.openConnection();
    //   if (userModel.isAgentOnline!) {
    //     logger.log('Going to current Orders screen');
    //     routeService.offAllNamed(AppLinks.currentOrders);
    //     return;
    //   }
    //   logger.log('Going to home screen');
    //   routeService.offAllNamed(AppLinks.agentHome);

    //   return;
    } else {
    //   // move to login screen
    //   logger.log("going to login");
    //   routeService.offAllNamed(AppLinks.login);
    //   return;
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