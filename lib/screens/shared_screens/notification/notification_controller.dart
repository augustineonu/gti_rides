import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/notification_model.dart';
import 'package:gti_rides/models/renter/favorite_cars_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class NotificationController extends GetxController
    with StateMixin<List<NotificationData>> {
  Logger logger = Logger('NotificationController');
  NotificationController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    await getNotification();
    super.onInit();
  }

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  RxBool isLoading = false.obs;
  RxBool isDeletingFavCar = false.obs;
  Rx<String> exampleText = "example".obs;
  Rx<String> pickedImagePath = ''.obs;

  onPageChanged(int index) {}

  // update();

  // navigation method
  void goBack() => routeService.goBack();
  Future<void> routeToViewNotification({Object? arguments}) async {
    routeService.gotoRoute(AppLinks.viewNotification, arguments: arguments);
  }

  Future<void> hello() async {}
  Future<void> getNotification() async {
    final response = await partnerService.getNotification();
    if (response.status == 'success' || response.status_code == 200) {
      logger.log("gotten cars ${response.data}");
      List<NotificationData> notification = List<NotificationData>.from(
          response.data!.map((not) => NotificationData.fromJson(not)));

      if (response.data == null || response.data!.isEmpty) {
        // If the list is empty
        change(<NotificationData>[].obs, status: RxStatus.empty());
        [] = response.data!;
        logger.log("notification ${notification}");
      } else {
        // If the list is not empty
        change(notification, status: RxStatus.success());
        update();
      }

      // isFetchingCars.value = false;
    } else {
      logger.log("unable to get notification ${response.data}");
    }
  }

  Future<void> viewNotification({required String notificationID}) async {
    try {
      final response =
          await partnerService.viewNotification(notificationID: notificationID);
      if (response.status_code == 200) {
        logger.log("successfully viewed notification");
        refresh();
      } else {
        logger.log("failed to view notification");
      }
    } catch (e) {
      logger.log("failed view notification $e");
    }
  }
}
