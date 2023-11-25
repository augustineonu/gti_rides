import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';

class IdentityVerificationController extends GetxController {
  Logger logger = Logger("Controller");

  IdentityVerificationController() {
    init();
  }

  void init() {
    logger.log("IdentityVerificationController Initialized");
  }

  @override
  void onInit() async {
    update();

    super.onInit();
  }

  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool selectedNationalID = false.obs;
  RxBool selectedPassport = false.obs;
  RxBool selectedDriversLicense = false.obs;
  PageController pageController = PageController();

  Rx<String> testString = 'hello world'.obs;

  void goBack() => routeService.goBack();
  void routeToPaymentSummary() =>
      routeService.gotoRoute(AppLinks.paymentSummary);
  void routeToProofOfIdentity() =>
      routeService.gotoRoute(AppLinks.proofOfIdentity);

      void onSelectIdType() => selectedNationalID.value = !selectedNationalID.value;

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

  void onClickPrevious() {
    if (currentIndex > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
