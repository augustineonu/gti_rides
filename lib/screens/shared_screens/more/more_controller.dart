import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';

import '../../../services/route_service.dart';

class MoreController extends GetxController {
  Logger logger = Logger('MoreController');

  Rx<UserModel> user = UserModel().obs;

  MoreController() {
    init();
  }

  void init() {
    logger.log('MoreController initialized');
    user = userService.user;
    logger.log("User:: $user");
  }

  // late Timer timer;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;

  // late PageController cardPageController;
  ScrollController scrollController = ScrollController();

  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  Rx<String> exampleText = "".obs;

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
    {'image': ImageAssets.toyCar, 'title': AppStrings.myDrivers},
    {'image': ImageAssets.key, 'title': "  ${AppStrings.howGtiWorks1}"},
    {'image': ImageAssets.people, 'title': "  ${AppStrings.referrals}"},
    {'image': ImageAssets.headSet, 'title': "  ${AppStrings.reportAnIncident}"},
    {
      'image': ImageAssets.headSet,
      'title': "  ${AppStrings.contactCustomerCare}"
    },
  ];

  onPageChanged(int index) {}

  void obscurePassword() => showPassword.value = !showPassword.value;
  void logOut() {
    routeService.offAllNamed(AppLinks.login);
  }
  // update();

  // navigation method
  void goBack() => routeService.goBack();
  void routeToSignUp() => routeService.gotoRoute(AppLinks.signUp);
  void routeToLandingPage() =>
      routeService.gotoRoute(AppLinks.carRenterLanding);
  void routeToSearchCity() => routeService.gotoRoute(AppLinks.searchCity);
  void routeToProfile() => routeService.gotoRoute(AppLinks.profile);
  void routeToFavorite() => routeService.gotoRoute(AppLinks.favorite);
  void routeToAccountDetails() =>
      routeService.gotoRoute(AppLinks.accountDetails);
  void routeToIdentityVerification() =>
      routeService.gotoRoute(AppLinks.identityVerification);
  void routeToReferralCode() => routeService.gotoRoute(AppLinks.referral);
  void routeToDrivers() => routeService.gotoRoute(AppLinks.drivers);

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    // timer.cancel(); // Cancel the timer when the controller is disposed.
    super.onClose();
  }
}
