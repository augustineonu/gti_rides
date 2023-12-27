import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';

class CarSelectionResultController extends GetxController {
  Logger logger = Logger("Controller");

  CarSelectionResultController() {
    init();
  }

  void init() {
    logger.log("CarSelectionResultController Initialized");
  }

  @override
  void onInit() async {
    update();

    super.onInit();
  }

  TextEditingController interStateInputController = TextEditingController();
  TextEditingController escortSecurityNoInputController =
      TextEditingController();
  TextEditingController selfPickUpInputController = TextEditingController();
  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  PageController pageController = PageController();
  RxBool isLoading = false.obs;
  RxBool selectedInterState = false.obs;
  RxBool selectedSecurityEscort = false.obs;
  RxBool selectedSelfPickUp = false.obs;

  Rx<String> testString = "Hello".obs;

  void goBack() => routeService.goBack();
  void routeToSearchFilter() => routeService.gotoRoute(AppLinks.searchFilter);
  void routeToReviews() => routeService.gotoRoute(AppLinks.reviews);
  void routeToViewCar() => routeService.gotoRoute(AppLinks.viewCar);
  void routeToKycCheck() => routeService.gotoRoute(AppLinks.kycCheck);

  void onSelectInterState(bool value) => selectedInterState.value = value;
  void onSelectSecurityEscort(bool value) =>
      selectedSecurityEscort.value = value;
  void onSelectSelfPickUp(bool value) => selectedSelfPickUp.value = value;

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
}
