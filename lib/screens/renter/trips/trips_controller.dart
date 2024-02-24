import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/rating_model.dart';
import 'package:gti_rides/models/renter/pending_trips_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class TripsController extends GetxController
    with StateMixin<List<AllTripsData>> {
  Logger logger = Logger("Controller");

  TripsController() {
    init();
  }

  void init() {
    logger.log("TripsController Initialized");
  }

  @override
  void onInit() async {
    super.onInit();
    // await getAllTrips();
    // Initialize your ratings list with default values
    ratings1 = List<RatingItem>.generate(
      ratings.length, // Use your desired length
      (index) => RatingItem(rating: 'Rating ${index + 1}'),
    );
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    lastDateTimeController.value.text = '1 Nov, 9:00am'.obs.toString();
    super.onReady();
    await getAllTrips();
  }

  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  RxInt selectedIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isGettingPendingTrips = false.obs;
  RxBool isGettingActiveTrips = false.obs;
  RxBool isExpanded = false.obs;
  RxBool confirmingTrip = false.obs;
  PageController pageController = PageController();

  Rx<String> testString = 'hello world'.obs;
  Rx<TextEditingController> lastDateTimeController =
      TextEditingController().obs;
  TextEditingController dateTimeController = TextEditingController();

  List<String> ratings = [
    AppStrings.cleanliness,
    AppStrings.roadTardiness,
    AppStrings.convenience,
    AppStrings.maintenance,
    AppStrings.fifthPoint,
  ];

  List<int> selectedIndices = [];
  List<RatingItem> ratings1 = List<RatingItem>.empty(growable: true);
  RxList<AllTripsData> pendingTrips = <AllTripsData>[].obs;
  RxList<AllTripsData> activeTrips = <AllTripsData>[].obs;
  RxList<AllTripsData> completedTrips = <AllTripsData>[].obs;

  RxBool isCountDownFinished = false.obs;
  late Timer timer;
  RxString countdownText = ''.obs;

  //  methods
  void goBack() => routeService.goBack();
  void routeToPaymentSummary({required bool isComingFromTrips}) => routeService
      .gotoRoute(AppLinks.paymentSummary, arguments: isComingFromTrips);
  void routeToChooseTripDate() =>
      routeService.gotoRoute(AppLinks.chooseSingleDateTrip);

  void routeToHome() => routeService.offAllNamed(AppLinks.carRenterLanding);
  void onPageChanged(int value) {
    currentIndex.value = value;
    pageController.animateToPage(
      value,
      duration:
          const Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.ease,
    );
    update();
  }

  void onPendingSelected(int value) {
    selectedIndex.value = value;
    update();
  }

  void onClickPrevious() {
    if (currentIndex > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // void toggleSelection(int index) {
  //   if (selectedIndices.contains(index)) {
  //     selectedIndices.remove(index);
  //   } else {
  //     selectedIndices.add(index);
  //   }
  //   update();
  // }

  void toggleSelection1(int index, RatingType selectedType) {
    final RatingItem rating = ratings1[index];

    if (rating.selectedType == selectedType) {
      // If the same type is selected, unselect
      rating.selectedType = RatingType.none;
    } else {
      // Otherwise, select the new type
      rating.selectedType = selectedType;
    }

    update();
  }

  Future<void> getAllTrips() async {
    // RxStatus.loading();
    change([], status: RxStatus.loading());
    try {
      final response = await renterService.getAllTrips(param: 'renter');

      if (response.status == 'success' || response.status_code == 200) {
        logger.log("All Trips:: ${response.data}");
        List<AllTripsData> trips = List<AllTripsData>.from(
            response.data!.map((trip) => AllTripsData.fromJson(trip)));

        if (trips.isEmpty) {
          change([], status: RxStatus.empty());
        } else {
          // Clear existing lists
          pendingTrips.clear();
          activeTrips.clear();
          completedTrips.clear();

          // Iterate through trips and assign to appropriate lists based on status
          for (AllTripsData trip in trips) {
            switch (trip.status) {
              case 'pending':
                pendingTrips.add(trip);
                break;
              case 'active':
                activeTrips.add(trip);
                break;
              case 'completed':
                completedTrips.add(trip);
                break;
              default:
                // Handle other status types if needed
                break;
            }
          }
          change(trips, status: RxStatus.success());
        }
      } else {
        logger.log("Unable to get trips");
      }
    } catch (e) {
      change([], status: RxStatus.error('Unable to get trips'));
      logger.log("Error occurred while getting trips: $e");
    }
  }

  void routeToPayment({dynamic url}) {
    routeService.gotoRoute(AppLinks.paymentWebView, arguments: {
      "checkoutUrl": url,
    });
  }

  Future<void> updateTripStatus(
      {required String type, required String tripID}) async {
    confirmingTrip.value = true;

    try {
      final response =
          await renterService.updateTripStatus(type: type, tripID: tripID);
      if (response.status == "success" || response.status_code == 200) {
        showSuccessSnackbar(message: response.message ?? "Trip confirmed");
        selectedIndex.value = 1;
        getAllTrips();
      } else {
        logger.log("Unable to confirm trip");
        // Show an error snackbar for unsuccessful response
        showErrorSnackbar(message: "Unable to confirm trip");
      }
    } catch (exception) {
      showErrorSnackbar(message: "An error occurred: ${exception.toString()}");
      logger.log("Error: ${exception}");
    } finally {
      confirmingTrip.value = false;
    }
  }

  void startCountdown(DateTime startDate, DateTime endDate) {
    final now = DateTime.now();
    final duration = endDate.difference(now);
    int secondsRemaining = duration.inSeconds;

    if (secondsRemaining > 0) {
      isCountDownFinished.value = false;
      logger.log('Countdown started!');

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (secondsRemaining > 0) {
          secondsRemaining--;
          updateCountdownText(secondsRemaining);
        } else {
          timer.cancel();
          // You can perform any action when the countdown reaches 0
          isCountDownFinished.value = true;
          logger.log('Countdown finished!');
        }
      });
    } else {
      // Handle the case where the end date is in the past
      logger.log('End date is in the past. No countdown started.');
    }
  }

  void updateCountdownText(int secondsRemaining) {
    final hours = (secondsRemaining ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((secondsRemaining ~/ 60) % 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');
    countdownText.value = '$hours:$minutes:$seconds';
  }

// Example usage:
  DateTime tripStartDate = DateTime.parse("2024-02-27T00:00:00.000Z");
  DateTime tripEndDate = DateTime.parse("2024-02-28T00:00:00.000Z");
// startCountdown(tripStartDate, tripEndDate);
}
