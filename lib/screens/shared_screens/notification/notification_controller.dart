import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/favorite_cars_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class NotificationController extends GetxController
    with StateMixin<List<FavoriteCarData>> {
  Logger logger = Logger('NotificationController');
  NotificationController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
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
  void routeToViewNotification({Object? arguments}) => routeService.gotoRoute(AppLinks.viewNotification, arguments: arguments);

  Future<void> hello() async {}

}
