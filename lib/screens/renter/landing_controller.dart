import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/more_controller.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/user_service.dart';

class RenterLandingController extends GetxController {
  Logger logger = Logger('RenterController');

  RxBool isDone = false.obs;

  RenterLandingController() {
    logger.log('Controller initialized');
  }

  final Map<String, dynamic>? arguments = Get.arguments;
  Rx<int> tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;

    if (userService.user.value.fullName == null) return;
    switch (tabIndex.value) {
      case 2:
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
          statusBarIconBrightness: Brightness.light,
        ));
        break;
      default:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }

    // if (tabIndex.value == 2) {
    // } else {}
  }

  @override
  void onInit() {
    Get.delete<MoreController>();
    // Get.put<MoreController>(MoreController());
    if (arguments != null) {
      tabIndex.value = arguments!['tabIndex'] ?? 0;
    }
    super.onInit();
  }
}
