import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/partner/car_history_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';

class ViewCarController extends GetxController {
  Logger logger = Logger("Controller");

  ViewCarController() {
    init();
  }
  final Map<String, dynamic>? arguments = Get.arguments;

  void init() {
    logger.log("ViewCarController Initialized");

    if (arguments != null) {
      logger.log("received data:: $arguments");
      photoList.value = arguments?["photoList"];
    }
  }

  @override
  void onInit() async {
    update();

    super.onInit();
  }

  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  PageController pageController = PageController();

  Rx<String> testString = 'hello world'.obs;
  RxList<Photo> photoList = <Photo>[].obs;

  void goBack() => routeService.goBack();

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
