import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';

import '../../../services/route_service.dart';

class MoreController extends GetxController {
  Logger logger = Logger('MoreController');
  MoreController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
  }

  late Timer timer;
  RxInt currentIndex = 0.obs;
  late PageController cardPageController;
  ScrollController scrollController = ScrollController();

  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  Rx<String> exampleText = "example".obs;

  List<Map<String, dynamic>> profileOptions = [
    {
      'image': ImageAssets.personIcon1,
      'title': " ${AppStrings.accountDetails}",
    },
    {'image': ImageAssets.heart, 'title': AppStrings.favorite},
    {
      'image': ImageAssets.note1,
      'title': " ${AppStrings.identityVerification}"
    },
    {'image': ImageAssets.headSet, 'title': "  ${AppStrings.reportAnIncident}"},
    {'image': ImageAssets.people, 'title': "  ${AppStrings.referrals}"},
    {'image': ImageAssets.key, 'title': "  ${AppStrings.howGtiWorks1}"},
  ];

  onPageChanged(int index) {}

  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void routeToSignUp() => routeService.gotoRoute(AppLinks.signUp);
  void routeToLandingPage() => routeService.gotoRoute(AppLinks.landingPage);
  void routeToSearchCity() => routeService.gotoRoute(AppLinks.searchCity);
  void routeToProfile() => routeService.gotoRoute(AppLinks.profile);
  void routeToFavorite() => routeService.gotoRoute(AppLinks.favorite);
  void routeToAccountDetails() =>
      routeService.gotoRoute(AppLinks.accountDetails);
  void routeToIdentityVerification() =>
      routeService.gotoRoute(AppLinks.identityVerification);

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    timer.cancel(); // Cancel the timer when the controller is disposed.
    super.onClose();
  }
}