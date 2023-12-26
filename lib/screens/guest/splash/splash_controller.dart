import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/device_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/storage_service.dart';
import 'package:gti_rides/services/user_service.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger logger = Logger('SplashController');
  final animationValue = 0.0.obs;
  late AnimationController _animationController;
  late RxBool isNewUser = false.obs;

  SplashController() {
    init();
  }

  void init() async {
    logger.log('SplashController initialized');
    initAnimation();
    deviceService.getDeviceInfo();
  //  isNewUser.value = await determineUserStatus();
   logger.log("status 1: ${isNewUser.value}");
  }

    @override
  void onInit() {
    // controller.addListener(pageListener);

    logger.log("Init called");
    logger.log("status: ${isNewUser.value}");
    super.onInit();
  }

  Future<bool> determineUserStatus() async{
    final user = await userService.getUserData();
    if(user == null){
      return false;
    } else {
      return true;
    }
  }

  Future<void> getSavedAgentModel() async {
    // final Agent? agentModel = await biometricService.getAgentModelData();
    // final User? userModel = await biometricService.getUserData();
    // final Tokens? tokens = await biometricService.getTokensData();
    // if (agentModel != null) {
    //   // setup and move to home screen
    //   agentService.setCurrentAgentModel(agentModel.toJson());
    //   agentService.setCurrentUser(agentModel.user!.toJson());
    //   tokenService.setTokenModel(tokens!.toJson());
    //   tokenService.setAccessToken(tokens.accessToken);
    //   tokenService.setRefreshToken(tokens.refreshToken);
    //   logger.log("Agent model >>: ${agentService.user.toJson()}");
    //   logger.log("User model >>: ${userModel!.toJson()}");
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
    // } else {
    //   // move to login screen
    //   logger.log("going to login");
    //   routeService.offAllNamed(AppLinks.login);
    //   return;
    // }
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
          // await getSavedAgentModel();
          routeService.gotoRoute(AppLinks.onboarding);
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
