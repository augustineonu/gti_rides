import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/device_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
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
