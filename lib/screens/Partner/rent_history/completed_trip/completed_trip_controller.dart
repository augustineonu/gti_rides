import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/pending_trips_model.dart';
import 'package:gti_rides/models/review_response_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class CompletedTripController extends GetxController
    with StateMixin<List<ReviewData>> {
  Logger logger = Logger('CompletedTripController');
  CompletedTripController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    if (arguments != null) {
      logger.log("Received data:: ${arguments!}");
      tripsData = arguments!["completedTrip"] as AllTripsData;
      showSupport.value = arguments!["showSupport"] ?? true;
      await getCarReviews(type: showSupport.value ? 'partner' : 'renter');
    }
  }

  Map<String, dynamic>? arguments = Get.arguments;
  AllTripsData tripsData = AllTripsData();
  RxBool isLoading = false.obs;
  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  RxBool showSupport = true.obs;
  Rx<String> exampleText = "example".obs;

  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void goBack() => routeService.goBack();
  void routeToSignUp() => routeService.gotoRoute(AppLinks.signUp);
  void routeToLandingPage() =>
      routeService.gotoRoute(AppLinks.carRenterLanding);
  void routeToSearchCity() => routeService.gotoRoute(AppLinks.searchCity);

  void copy({required String value}) async {
    await Clipboard.setData(ClipboardData(text: value));

    await showSuccessSnackbar(message: AppStrings.copied, seconds: 2);
  }

  RxList<ReviewData>? reviews = <ReviewData>[].obs;

  Future<void> getCarReviews({required String type}) async {
    change([], status: RxStatus.loading());
    isLoading.value = true;
    try {
      final response = await renterService.getReview(
          carId: tripsData.carId.toString(), type: type);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("car review::${response.data}");

        if (response.data == null || response.data!.isEmpty) {
          // If the list is empty
          // change(<CarHistoryData>[].obs, status: RxStatus.empty());
          reviews?.value = [];
          change(reviews, status: RxStatus.empty());
        } else {
          reviews?.value = response.data!
              .map((review) => ReviewData.fromJson(review))
              .toList();

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
    } finally {
      isLoading.value = false;
    }
  }

  Rx<bool> isSendingReview = false.obs;
  GlobalKey<FormState> reviewFormKey = GlobalKey();
  TextEditingController reviewMessageController = TextEditingController();

  Future<void> addReview() async {
    if (!reviewFormKey.currentState!.validate()) {
      return;
    }
    try {
      isSendingReview.value = true;
      final response = await partnerService
          .addReview(carId: tripsData.carId.toString(), data: {
        "tripID": tripsData.tripId.toString(),
        // "renterID": tripsData.,
        "message": reviewMessageController.text,
      });
      if (response.status_code == 200) {
        showSuccessSnackbar(
            message: response.message ?? 'Review sent', seconds: 2);
        Future.delayed(const Duration(seconds: 4))
            .then((value) => routeService.goBack())
            .then((value) => Get.back());
        //  Get.back();
      } else {
        logger.log(
            "unable to send review: ${response.message ?? "error sending review"}");

        showErrorSnackbar(message: response.message ?? 'Unable to send review');
      }
    } catch (e) {
      logger.log("error: $e");
    } finally {
      isSendingReview.value = false;
    }
  }

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    // timer.cancel(); // Cancel the timer when the controller is disposed.
    super.onClose();
  }
}
