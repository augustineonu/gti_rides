import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/device_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/storage_service.dart';
import 'package:gti_rides/services/user_service.dart';

class AppController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger logger = Logger('AppController');
  final animationValue = 0.0.obs;
  late AnimationController _animationController;


  AppController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
    deviceService.getDeviceInfo();
       
  }

  Future<bool> determineUserStatus() async {
    final UserModel? userModel = await userService.getUserData();

    if (userModel != null) {
      logger.log("User model: ${userModel.fullName}");
      return true;
    } else {
      // move to login
      logger.log("going to login");
      routeService.offAllNamed(AppLinks.splash);
      return false;
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

  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}