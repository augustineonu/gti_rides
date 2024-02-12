import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/more_controller.dart';
import 'package:gti_rides/services/logger.dart';

class RenterLandingController extends GetxController {
  Logger logger = Logger('RenterController');

  RxBool isDone = false.obs;

  RenterLandingController() {
    logger.log('Controller initialized');
  }
  Rx<int> tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  @override
  void onInit() {
    Get.delete<MoreController>();
    Get.put<MoreController>(MoreController());
    super.onInit();
  }
}
