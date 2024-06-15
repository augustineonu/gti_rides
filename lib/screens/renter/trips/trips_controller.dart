import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/partner/car_history_model.dart';
import 'package:gti_rides/models/rating_model.dart';
import 'package:gti_rides/models/renter/booked_dates.dart';
import 'package:gti_rides/models/renter/pending_trips_model.dart';
import 'package:gti_rides/models/renter/trip_amount_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/figures_helpers.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

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
     scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          isLoadingMore.value) {
        getAllTrips(isLoadMore: true);
      }
    });
    super.onInit();
    await getTripAmountData();
    // await getAllTrips();
    // Initialize your ratings list with default values
    ratings1 = List<RatingItem>.generate(
      ratings.length, // Use your desired length
      (index) => RatingItem(),
    );
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    lastDateTimeController.value.text = '1 Nov, 9:00am'.obs.toString();
    super.onReady();
    await getAllTrips();
  }

    var skip = 0;
  final int limit = 10;
  RxBool isLoadingMore = false.obs;

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
  Rx<int> tripDays = 0.obs;
  Rx<String> carId = ''.obs;
  Rx<String> tripType = ''.obs;

  Rx<String> cleanlinessValue = '0'.obs;
  Rx<String> roadTardinessValue = '0'.obs;
  Rx<String> convenienceValue = '0'.obs;
  Rx<String> maintenanceValue = '0'.obs;
  Rx<String> fifthPointValue = '0'.obs;
  Rx<String> tripId = ''.obs;
  TextEditingController reviewMessageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ScrollController activeScrollController = ScrollController();
  final ScrollController compScrollController = ScrollController();

  //  methods
  void goBack() => routeService.goBack();
  void routeToPaymentSummary() =>
      routeService.gotoRoute(AppLinks.extendTripPayment, arguments: {
        "carId": carId.value,
        "pricePerDay": pricePerDay.value,
        "tripDays": tripDays.value,
        "tripDaysTotal": tripDaysTotal.value,
        "vatValue": vatValue.value,
        "vatTotal": formattedVatValue.value,
        "discountTotal": discountTotalFee.value,
        "tripStartDate": currentStartTime?.toIso8601String(),
        "tripEndDate": selectedEndDateTime?.toIso8601String(),
        "estimatedTotal": estimatedTotal.value,
        "tripType": tripType.value
      });
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

  void routeToCompletedTrip({Object? arguments}) =>
      routeService.gotoRoute(AppLinks.completedTrip, arguments: arguments);

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
      getTotalRatingValue();
    } else {
      // Otherwise, select the new type
      rating.selectedType = selectedType;
      logger.log("rating:: ${selectedType}");
      getTotalRatingValue();
    }

    update();
  }

  // Function to get the total value of selected ratings
  Rx<int> totalRatingValue = 0.obs;
  int getTotalRatingValue() {
    int accumulatedValue = 0;

    for (RatingItem rating in ratings1) {
      // if (rating.isSelected()) {
      // Assign value based on the rating type
      int value = (rating.selectedType == RatingType.thumbsUp) ? 20 : 0;
      if (rating.selectedType == RatingType.none) {
        value == 0;
      }
      accumulatedValue += value;
      // }
    }

    totalRatingValue.value = accumulatedValue;
    logger.log("totalRatingValue: ${totalRatingValue.value}");

    return totalRatingValue.value;
  }

  // Function to get a list of selected ratings
  List<RatingInfo> getSelectedRatings() {
    List<RatingInfo> selectedRatings = [];
    for (int i = 0; i < ratings1.length; i++) {
      if (ratings1[i].isSelected()) {
        RatingInfo ratingInfo = RatingInfo(ratings1[i].selectedType, i + 1);
        selectedRatings.add(ratingInfo);
      }
    }
    return selectedRatings;
  }

  void calculateCriterionValues() {
    cleanlinessValue.value = getCriterionValue(RatingType.thumbsUp, 0);
    roadTardinessValue.value = getCriterionValue(RatingType.thumbsUp, 1);
    convenienceValue.value = getCriterionValue(RatingType.thumbsUp, 2);
    maintenanceValue.value = getCriterionValue(RatingType.thumbsUp, 3);
    fifthPointValue.value = getCriterionValue(RatingType.thumbsUp, 4);

    // You can use the values as strings in your UI
  }

  String getCriterionValue(RatingType selectedType, int index) {
    if (ratings1[index].selectedType == selectedType) {
      return '100';
    } else {
      return '0';
    }
  }

  Rx<bool> isSendingReview = false.obs;
  GlobalKey<FormState> reviewFormKey = GlobalKey();
  Future<void> addR() async {
    logger.log("loading...");
    update();
    isSendingReview.value = true;
    await Future.delayed(Duration(seconds: 5));
    isSendingReview.value = false;
    update();
    logger.log("loaded");
  }

  Future<void> addReview() async {
    if (!reviewFormKey.currentState!.validate()) {
      return;
    }
    try {
      isSendingReview.value = true;
      final response = await renterService.addReview(carId: carId.value, data: {
        "cleanliness": cleanlinessValue.value == '0' ? 'dislike' : "like",
        "cleanlinessPercentage": cleanlinessValue.value,
        "roadTardiness": roadTardinessValue.value == '0' ? "dislike" : "like",
        "roadTardinessPercentage": roadTardinessValue.value,
        "convenience": convenienceValue.value == '0' ? "dislike" : "like",
        "conveniencePercentage": convenienceValue.value,
        "maintenance": maintenanceValue.value == '0' ? 'dislike' : "like",
        "maintenancePercentage": maintenanceValue.value,
        "point": fifthPointValue.value == '0' ? 'dislike' : "like",
        "pointPercentage": fifthPointValue.value,
        "reviewPercentage": totalRatingValue.value.toString(),
        "message": reviewMessageController.text,
        "tripID": tripId.value
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

  RxList<BookedData> bookedData = <BookedData>[].obs;
  RxString carNotAvailable = ''.obs;
  DateTime? selectedEndDateTime;
  DateTime? currentStartTime = DateTime.now();
  Rx<bool> isCheckingCarAvailability = false.obs;
  List<CarHistoryData>? carHistory;
  Rx<String> pricePerDay = ''.obs;
  Rx<double> total = 0.0.obs;
  Rx<String> tripDaysTotal = ''.obs;
  Rx<String> estimatedTotal = ''.obs;
  Rx<String> vatValue = ''.obs;
  Rx<String> formattedVatValue = ''.obs;

  //  Rx<double> updatedTotalRatingValue = 0.0.obs;
  Rx<double> discountTotal = 0.0.obs;
  Rx<String> discountTotalFee = ''.obs;
  Rx<bool> discountApplied = false.obs;
  RxList<TripAmountData> tripAmountData = <TripAmountData>[].obs;

  Future<void> addGrandTotal() async {
    double vatAmount = await calculateVAT(total.value, vatValue.value);
    logger.log("VAT total:: $vatAmount");
    formattedVatValue.value = await formatAmount(vatAmount);
  }

  Future<void> applyDiscount() async {
    var discountDay = carHistory?.first.discountDays;
    var discountPercentage = carHistory?.first.discountPrice;

    if (discountPercentage != null) {
      var parsedDiscountPercentage =
          double.tryParse(discountPercentage.replaceAll('%', '')) ?? 0.0;

      if (tripDays.value >= int.parse(discountDay)) {
        discountApplied.value = true;

        // Calculate the discount based on the percentage
        var discountPercentageValue = parsedDiscountPercentage / 100.0;
        var priceWithoutCommas = pricePerDay.value.replaceAll(',', '');
        var perDayPrice = double.parse(priceWithoutCommas);
        var discount = discountPercentageValue * (perDayPrice * tripDays.value);

        discountTotalFee.value = await formatAmount(discount);
        //  this is supposed to be equal to the totalPricePerdayfee x
        //  tripDaysTotal
        logger.log("formatted discount ${discountTotalFee.value}");

        logger.log("Discount price total: ${discountTotalFee.toString()}");
        // update updatedTotal
        // updatedTotalRatingValue.value -= discountTotal.value;
        total.value -= discount;
        // tripDaysTotal.value = await formatAmount(updatedTotalRatingValue.value);
        logger.log("Total price after discount: ${total.value}");
      }
    } else {
      // Handle the case where discountPercentage is null
      logger.log("Discount percentage is null");
    }
  }

  DateTime? carAvialbilityEndDate;

  Future<void> getCarHistory({required String carId}) async {
    try {
      isCheckingCarAvailability.value = true;
      final response = await renterService.getOneCar(carId: carId);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("car history::${response.data}");

        if (response.data?.isEmpty ?? true) {
          // If the list is empty
        } else {
          // If the list is not empty
          // List<CarHistoryData> carHistory = List<CarHistoryData>.from(
          //   response.data!.map((car) => CarHistoryData.fromJson(car)),
          // );
          carHistory = response.data!
              .map((car) => CarHistoryData.fromJson(car))
              .toList();

          var endDateString = carHistory?.first.endDate;
          carAvialbilityEndDate = DateTime.parse(endDateString!);

          pricePerDay.value = carHistory?.first.pricePerDay;
          //price per day total x no of days
          total.value =
              await calculateEstimatedTotal(pricePerDay.value, tripDays.value);

          tripDaysTotal.value = await formatAmount(total.value);
          // total formated to String
          estimatedTotal.value = await formatAmount(total.value);
          // this value would be used to reset user selection
          // initialEstimatedTotal.value = await formatAmount(total.value);

          // apply discount if applicable before calculating VAT
          await applyDiscount();

          formattedVatValue.value = await formatAmount(
              await calculateVAT(total.value, vatValue.value));
          total.value =
              total.value + await calculateVAT(total.value, vatValue.value);
          // update total after VAT and discount
          estimatedTotal.value = await formatAmount(total.value);
          logger.log("Estimated Total:: ${total.value.toString()}");

          update();
        }
      } else {
        logger.log("unable to get cars ${response.data}");
      }
    } catch (exception) {
      logger.log("error: ${exception.toString()}");
    } finally {
      isCheckingCarAvailability.value = false;
    }
  }

  Future<void> getTripAmountData() async {
    try {
      final response = await renterService.getTripAmountData();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("Trip amount data::${response.data}");

        if (response.data == null || response.data!.isEmpty) {
          // If the list is empty
          // change(<CarHistoryData>[].obs, status: RxStatus.empty());
          tripAmountData.value = [];
        } else {
          // If the list is not empty
          List<TripAmountData> tripData = List<TripAmountData>.from(
              response.data!.map((e) => TripAmountData.fromJson(e)));

          tripAmountData.value = tripData;
          // cautionFee.value = tripAmountData.first.cautionFee!;
          // dropOffFee.value = tripAmountData.first.dropOffFee!;
          // escortFee.value = tripAmountData.first.escortFee!;
          // pickUpFee.value = tripAmountData.first.pickUp!;
          vatValue.value = tripAmountData.first.vatValue!;
          update();
        }
      } else {
        logger.log("unable to get car review ${response.data}");
      }
    } catch (exception) {
      logger.log("error: ${exception.toString()}");
    }
  }

  Future<bool?> checkCarAvailability({
    required carId,
    required DateTime rawStartTime,
    required DateTime rawEndTime,
  }) async {
    // Get.back();

    try {
      isCheckingCarAvailability.value = true;
      final response = await renterService.getCarTrip(
          carID: carId, startDate: rawStartTime, endDate: rawEndTime);
      if (response.status == 'success' || response.status_code == 200) {
        if (response.data!.isEmpty) {
          isCheckingCarAvailability.value = false;
          return true;
        } else {
          // need to do another level of check
          // if car booked dates
          logger.log("trip booked dates: ${response.data}");
          carNotAvailable.value =
              response.message ?? 'Car booked for selected dates';
          bookedData.value = List<BookedData>.from(
              response.data!.map((booked) => BookedData.fromJson(booked)));
          logger.log("Booked trips ${bookedData.value.first.carId}");
          return false;
        }
      } else {
        carNotAvailable.value = response.message ?? 'error';
        logger.log("an error occured");
        return false;
      }
    } catch (e) {
      carNotAvailable.value = e.toString();

      logger.log("some error occured $e");
      return null;
    } finally {
      isCheckingCarAvailability.value = false;
    }
  }

  Future<void> getAllTrips({bool isLoadMore = false}) async {
    // RxStatus.loading();
    if (isLoadMore) {
      isLoadingMore.value = true;
      skip += limit;
    } else {
      skip = 0;
      isLoadingMore.value = false;
    }
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
    } finally {
      isLoadingMore.value = false;
    }
  }

  void routeToPayment({dynamic url}) {
    routeService.gotoRoute(AppLinks.paymentWebView, arguments: {
      "checkoutUrl": url,
    });
  }

  Future<void> updateTripStatus(
      {required String type, required String tripID}) async {
    isLoading.value = true;

    try {
      final response =
          await renterService.updateTripStatus(type: type, tripID: tripID);
      if (response.status == "success" || response.status_code == 200) {
        showSuccessSnackbar(message: response.message ?? "Trip status updated");
        selectedIndex.value = 1;
        getAllTrips();
      } else {
        logger.log("Unable to confirm or complete trip");
        // Show an error snackbar for unsuccessful response
        showErrorSnackbar(message: "Unable to update trip status");
      }
    } catch (exception) {
      showErrorSnackbar(message: "An error occurred: ${exception.toString()}");
      logger.log("Error: ${exception}");
    } finally {
      isLoading.value = false;
    }
  }

  String startCountdown(DateTime startDate, DateTime endDate) {
    final now = DateTime.now();
    final duration = endDate.difference(now);
    int secondsRemaining = duration.inSeconds;

    if (secondsRemaining > 0) {
      isCountDownFinished.value = false;
      logger.log('Countdown started!');
      Rx<String> hours = ''.obs;
      Rx<String> minutes = ''.obs;
      Rx<String> seconds = ''.obs;

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (secondsRemaining > 0) {
          secondsRemaining--;
          // updateCountdownText(secondsRemaining);
          hours.value = (secondsRemaining ~/ 3600).toString().padLeft(2, '0');
          minutes.value =
              ((secondsRemaining ~/ 60) % 60).toString().padLeft(2, '0');
          seconds.value = (secondsRemaining % 60).toString().padLeft(2, '0');
          // countdownText.value = '$hours:$minutes:$seconds';
          // return '$hours:$minutes:$seconds';
        } else {
          timer.cancel();
          // You can perform any action when the countdown reaches 0
          isCountDownFinished.value = true;
          logger.log('Countdown finished!');
        }
      });

      return '${hours.value}:${minutes.value}:${seconds.value}';
    } else {
      // Handle the case where the end date is in the past
      logger.log('End date is in the past. No countdown started.');
      return "00:00:00";
    }
  }

  void updateCountdownText(int secondsRemaining) {
    final hours = (secondsRemaining ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((secondsRemaining ~/ 60) % 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');
    countdownText.value = '$hours:$minutes:$seconds';
    logger.log("Time:: ${countdownText.value}}");
  }

  bool isTripActive(DateTime tripEndDate) {
    // Convert the current time to UTC
    DateTime currentTimeUtc = DateTime.now().toUtc();
    logger.log("date utc: $currentTimeUtc $tripEndDate");

    // Check if the trip end date is after the current time in UTC
    return tripEndDate.isAfter(currentTimeUtc);
  }

// Example usage:
  DateTime tripStartDate = DateTime.parse("2024-02-27T00:00:00.000Z");
  DateTime tripEndDate = DateTime.parse("2024-02-28T00:00:00.000Z");
// startCountdown(tripStartDate, tripEndDate);

  Future<void> launchMessenger() async {
    await Intercom.instance
        .loginIdentifiedUser(email: userService.user.value.emailAddress);
    await Intercom.instance.displayMessenger();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    reviewMessageController.clear();
  }
}
