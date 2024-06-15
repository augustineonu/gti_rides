import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/notification_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/route_service.dart';

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

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoadingMore.value) {
        getNotification(isLoadMore: true);
      }
    });
    super.onInit();
  }

  final ScrollController scrollController = ScrollController();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  RxBool isLoading = false.obs;
  RxBool isDeletingFavCar = false.obs;
  Rx<String> exampleText = "example".obs;
  Rx<String> pickedImagePath = ''.obs;

  var skip = 0;
  final int limit = 9;
  RxBool isLoadingMore = false.obs;

  onPageChanged(int index) {}

  // update();

  // navigation method
  void goBack() => routeService.goBack();
  Future<void> routeToViewNotification({Object? arguments}) async {
    routeService.gotoRoute(AppLinks.viewNotification, arguments: arguments);
  }

  Future<void> hello() async {}
  Future<void> getNotification({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isLoadingMore.value = true;
      skip += limit;
    } else {
      skip = 0;
      isLoadingMore.value = false;
    }
    List<NotificationData> notification1 = [];

    try {
      final response = await partnerService.getNotification(
          skipNumber: skip.toString(), limit: limit);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten cars ${response.data}");
        List<NotificationData> notification = List<NotificationData>.from(
            response.data!.map((not) => NotificationData.fromJson(not)));
        notification1 = notification;

        if (response.data == null || response.data!.isEmpty) {
          // If the list is empty
          if (!isLoadMore) {
            change(<NotificationData>[].obs, status: RxStatus.empty());
          }
          [] = response.data!;
          logger.log("notification ${notification}");
        } else {
          // If the list is not empty
          if (isLoadMore) {
            notification1.addAll(notification);

            change(notification1, status: RxStatus.success());
            update();
            // change(notification, status: RxStatus.success());
          } else {
            change(notification, status: RxStatus.success());
            update();
          }
        }
        // isFetchingCars.value = false;
      } else {
        logger.log("unable to get notification ${response.data}");
      }
    } catch (e) {
      logger.log("unable to get notification $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> viewNotification({required String notificationID}) async {
    try {
      final response =
          await partnerService.viewNotification(notificationID: notificationID);
      if (response.status_code == 200) {
        logger.log("successfully viewed notification");
        refresh();
        update();
      } else {
        logger.log("failed to view notification");
      }
    } catch (e) {
      logger.log("failed view notification $e");
    }
  }
}
