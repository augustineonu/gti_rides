import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/review_response_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';

class FeedbacksController extends GetxController
    with StateMixin<List<ReviewData>> {
  Logger logger = Logger('FeedbacksController');

  FeedbacksController() {
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
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    if (arguments != null) {
      logger.log("Received data:: $arguments");
      carId.value = arguments!['carId'];
      photoUrl.value = arguments!['photoUrl'] ?? '';
      vehicleName.value = arguments!['vehicleName'] ?? '';
      await getCarReviews();
    }
  }

  Map<String, dynamic>? arguments = Get.arguments;

  RxInt selectedIndex = 0.obs;
  Rx<String> carId = "".obs;
  Rx<String> photoUrl = "".obs;
  Rx<String> vehicleName = "".obs;

  RxList<ReviewData>? reviews = <ReviewData>[].obs;

  @override
  void dispose() {
    super.dispose();
  }

  void goBack() => routeService.goBack();

  void routeToresetPassword() => routeService.gotoRoute(
        AppLinks.resetPassword,
      );

  RxList<ReviewData> positiveReviews = <ReviewData>[].obs;
  RxList<ReviewData> negativeReviews = <ReviewData>[].obs;

  Future<void> getCarReviews() async {
    change([], status: RxStatus.loading());
    try {
      final response = await renterService.getReview(carId: carId.value);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("car review::${response.data}");

        if (response.data == null || response.data!.isEmpty) {
          // If the list is empty
          reviews?.value = [];
          change(reviews, status: RxStatus.empty());
        } else {
          reviews?.value = response.data!
              .map((review) => ReviewData.fromJson(review))
              .toList();

          positiveReviews.clear();
          negativeReviews.clear();

          for (ReviewData review in reviews!) {
            var reviewPercentage = int.parse(review.reviewPercentage);
            switch (reviewPercentage) {
              case <= 49:
                negativeReviews.add(review);
                break;
              case >= 50:
                positiveReviews.add(review);
                break;
              default:
                reviews;
            }
          }
          logger.log("Positive Review:: ${positiveReviews.length.toString()}");
          logger.log("Negative Review:: ${negativeReviews.length.toString()}");
          logger.log("Review:: ${reviews!.length.toString()}");
          change(reviews, status: RxStatus.success());
          update();
        }
      } else {
        change([], status: RxStatus.error());
        logger.log("unable to get car review ${response.data}");
      }
    } catch (exception) {
      change([], status: RxStatus.error());
      logger.log("error: ${exception.toString()}");
    }
  }

  // Future<void> getCarReviews1() async {
  //   // change(<CarHistoryData>[].obs, status: RxStatus.loading());
  //   try {
  //     final response = await renterService.getReview(carId: carId.value);
  //     if (response.status == 'success' || response.status_code == 200) {
  //       logger.log("car review::${response.data}");

  //       if (response.data == null || response.data!.isEmpty) {
  //         // If the list is empty
  //         // change(<reviews>[].obs, status: RxStatus.empty());
  //         reviews.value = response.data!;
  //       } else {
  //         reviews.value = response.data!;

  //         // change(carHistory, status: RxStatus.success());
  //         update();
  //       }
  //     } else {
  //       logger.log("unable to get car review ${response.data}");
  //     }
  //   } catch (exception) {
  //     logger.log("error: ${exception.toString()}");
  //   }
  // }
}
