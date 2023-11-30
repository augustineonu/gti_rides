import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';

class PaymentSummaryController extends GetxController {
  Logger logger = Logger("Controller");

  PaymentSummaryController() {
    init();
  }

  void init() {
    logger.log("PaymentSummaryController Initialized");
  }

  @override
  void onInit() async {
    update();

    super.onInit();
  }

  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isComingFromTrips = false.obs;
  PageController pageController = PageController();

  Rx<String> testString = 'hello world'.obs;

  // bool args = Get.arguments;

  void goBack() => routeService.goBack();
  void routeToHome() => routeService.gotoRoute(AppLinks.carRenterLanding);

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
