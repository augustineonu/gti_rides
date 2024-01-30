import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';

class ReviewController extends GetxController {
  Logger logger = Logger('ReviewController');

  ReviewController() {
    init();
  }

  void init() async {
    logger.log('Controller initialized');

    if (arguments != null) {
      logger.log("Received data:: $arguments");
      carId.value = arguments!['carId'];
      await getCarReview();
    }
    load();
  }

  void load() {
    logger.log('Loading');
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Map<String, dynamic>? arguments = Get.arguments;

  RxInt selectedIndex = 0.obs;
  Rx<String> carId = "".obs;

  RxList<dynamic> reviews = <dynamic>[].obs;

  void goBack() => routeService.goBack();

  void routeToresetPassword() => routeService.gotoRoute(
        AppLinks.resetPassword,
      );

  Future<void> getCarReview() async {
    // change(<CarHistoryData>[].obs, status: RxStatus.loading());
    try {
      final response = await renterService.getReview(carId: carId.value);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("car review::${response.data}");

        if (response.data == null || response.data!.isEmpty) {
          // If the list is empty
          // change(<CarHistoryData>[].obs, status: RxStatus.empty());
          reviews?.value = response.data!;
        } else {
          // If the list is not empty
          reviews?.value = response.data!;

          // change(carHistory, status: RxStatus.success());
          update();
        }
      } else {
        logger.log("unable to get car review ${response.data}");
      }
    } catch (exception) {
      logger.log("error: ${exception.toString()}");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
