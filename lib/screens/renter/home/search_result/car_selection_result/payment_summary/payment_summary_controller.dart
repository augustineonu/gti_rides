import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/trip_data_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/renter/home/search_result/car_selection_result/car_selection_result_controller.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/payment_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/utils.dart';

class PaymentSummaryController extends GetxController {
  Logger logger = Logger("Controller");

  PaymentSummaryController() {
    init();
  }

  void init() {
    logger.log("PaymentSummaryController Initialized");
  }

  @override
  void onInit() async {
    update();

    super.onInit();
    if (arguments != null) {
      logger.log("Received data:: $arguments");
      logger.log("Received data:: ${arguments?["tripsData"]}");
      tripData.value = arguments?["tripData"] as TripData;
      logger.log("${tripData.value.carID}");

      pricePerDay.value = arguments?["pricePerDay"];
      estimatedTotal.value = arguments?["estimatedTotal"];
      tripDaysTotal.value = arguments?["tripDaysTotal"];
      vatValue.value = arguments?["vatValue"];
      vat.value = arguments?["vat"];
      selectedSelfPickUp.value = arguments?["selectedSelfPickUp"] ?? false;
      selectedSelfDropOff.value = arguments?["selectedSelfDropOff"] ?? false;
      selectedSecurityEscort.value =
          arguments?["selectedSecurityEscort"] ?? false;
      totalEscortFee.value = arguments?["totalEscortFee"] ?? '';
      tripType.value = arguments?["tripType"] ?? 0;

      logger.log("Received data:: ${tripData.value.carID}");
      logger.log("Received data:: ${tripData.value.tripStartDate}");

      formattedStartDayDateMonth.value =
          extractDayDateMonth(tripData.value.tripStartDate!);
      logger.log(
          "formattedStartDayDateMonth:: ${formattedStartDayDateMonth.value}");
      formattedStartTime.value = extractTime(tripData.value.tripStartDate!);
      logger.log("formattedStartTime:: ${formattedStartTime.value}");

      formattedEndDayDateMonth.value =
          extractDayDateMonth(tripData.value.tripEndDate!);
      formattedEndTime.value = extractTime(tripData.value.tripEndDate!);
    }
  }

  Map<String, dynamic>? arguments = Get.arguments;
  Rx<TripData> tripData = TripData().obs;
  final carSelectionController = Get.put(CarSelectionResultController());

  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isComingFromTrips = false.obs;
  PageController pageController = PageController();

  Rx<String> testString = 'hello world'.obs;
  Rx<String> formattedStartDayDateMonth = ''.obs;
  Rx<String> formattedStartTime = ''.obs;
  Rx<String> formattedEndDayDateMonth = ''.obs;
  Rx<String> formattedEndTime = ''.obs;

  Rx<String> pricePerDay = ''.obs;
  Rx<String> estimatedTotal = ''.obs;
  Rx<String> tripDaysTotal = ''.obs;
  Rx<String> vatValue = ''.obs;
  Rx<String> vat = ''.obs;
  Rx<bool> selectedSelfPickUp = false.obs;
  Rx<bool> selectedSelfDropOff = false.obs;
  Rx<bool> selectedSecurityEscort = false.obs;
  Rx<String> totalEscortFee = ''.obs;
  Rx<int> tripType = 0.obs;

  // bool args = Get.arguments;

  void goBack() => routeService.goBack();
  void routeToHome() => routeService.gotoRoute(AppLinks.carRenterLanding);

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

  void onClickPrevious() {
    if (currentIndex > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

//   String formatPaymentDate(String receivedDate) {
//   // Split the input date by comma
//   List<String> parts = receivedDate.split(', ');

//   // Extract the day and month parts
//   String day = parts[1].split(' ')[1];
//   // String month = parts[2];

//   // Extract the time part
//   // String time = parts[3];

//   // Return the formatted date
//   return '$day \n';
// }

Future<void> addTrip() async {
  paymentService.addTrip(data: TripData(
    carID: tripData.value.carID,
    tripStartDate: tripData.value.tripStartDate,
    tripEndDate: tripData.value.tripEndDate,
    tripsDays: tripData.value.tripsDays,
    tripType: tripData.value.tripType,
    interState: tripData.value.interState,
    interStateAddress: tripData.value.interStateAddress,
    escort: tripData.value.escort,
  ).toJson());
}
}
