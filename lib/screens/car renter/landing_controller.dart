import 'package:get/get.dart';
import 'package:gti_rides/services/logger.dart';

class LandingPageController extends GetxController {
  Logger logger = Logger('OnboardingController');

  RxBool isDone = false.obs;

  LandingPageController() {
    logger.log('Controller initialized');
  }
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }
}
