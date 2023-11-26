import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/rating_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/constants.dart';

class TripsController extends GetxController {
  Logger logger = Logger("Controller");

  TripsController() {
    init();
  }

  void init() {
    logger.log("TripsController Initialized");
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize your ratings list with default values
    ratings1 = List<RatingItem>.generate(
      ratings.length, // Use your desired length
      (index) => RatingItem(rating: 'Rating ${index + 1}'),
    );
  }

  @override
  void onReady() {
    // TODO: implement onReady
    lastDateTimeController.value.text = '1 Nov, 9:00am'.obs.toString();
    super.onReady();
  }

  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  RxInt selectedIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isExpanded = false.obs;
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
}
