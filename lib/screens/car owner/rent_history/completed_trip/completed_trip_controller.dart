import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class CompletedTripController extends GetxController {
  Logger logger = Logger('CompletedTripController');
  CompletedTripController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
  }

  // late Timer timer;
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
  @override
  void onInit() {
    super.onInit();
  }

  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void goBack() => routeService.goBack();
  void routeToSignUp() => routeService.gotoRoute(AppLinks.signUp);
  void routeToLandingPage() =>
      routeService.gotoRoute(AppLinks.carRenterLanding);
  void routeToSearchCity() => routeService.gotoRoute(AppLinks.searchCity);

   void copy({required String value}) async {
    await Clipboard.setData(ClipboardData(text: value));

    await showSuccessSnackbar(message: AppStrings.copied);
  }
  
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
