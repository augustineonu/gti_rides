import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class OwnerTripsController extends GetxController {
  Logger logger = Logger('OwnerTripsController');

  OwnerTripsController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
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

  RxInt selectedIndex = 0.obs;

  @override
  void dispose() {
    super.dispose();
  }

  void goBack() => routeService.goBack();

  void routeToresetPassword() => routeService.gotoRoute(
        AppLinks.resetPassword,
      );

  void copy({required String value}) async {
    await Clipboard.setData(ClipboardData(text: value));

    await showSuccessSnackbar(message: AppStrings.copied);
  }
}
