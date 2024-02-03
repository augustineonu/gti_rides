import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/trip_data_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
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
       pricePerDay.value = arguments?["pricePerDay"];
       estimatedTotal.value = arguments?["estimatedTotal"];
       vatValue.value = arguments?["vatValue"];
       vat.value = arguments?["vat"];

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
  Rx<String> vatValue = ''.obs;
  Rx<String> vat = ''.obs;

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
}
