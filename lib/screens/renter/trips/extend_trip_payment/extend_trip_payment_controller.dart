import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/trip_data_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/renter/home/search_result/car_selection_result/car_selection_result_controller.dart';
import 'package:gti_rides/screens/renter/home/search_result/car_selection_result/payment_summary/webview_payment/payment_webiew.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/payment_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ExtendTripPaymentController extends GetxController {
  Logger logger = Logger("Controller");

  ExtendTripPaymentController() {
    init();
  }

  void init() {
    logger.log("ExtendTripPaymentController Initialized");
  }

  @override
  void onInit() async {
    update();

    super.onInit();
    if (arguments != null) {
      logger.log("Received data:: $arguments");
      carId.value = arguments?["carId"] ?? '';
      pricePerDay.value = arguments?["pricePerDay"] ?? '';
      tripsDays.value = arguments?["tripDays"] ?? 0;
      tripDaysTotal.value = arguments?["tripDaysTotal"] ?? '';
      vatValue.value = arguments?["vatValue"] ?? '';
      vat.value = arguments?["vatTotal"] ?? '';
      discountTotal.value = arguments!["discountTotal"] ?? '0';
      rawStartTime = arguments!["tripStartDate"] ?? '';
      rawEndTime = arguments!["tripEndDate"] ?? '';
      estimatedTotal.value = arguments!["estimatedTotal"] ?? '0';
      formattedStartDayDateMonth.value = formatDayDate1(rawStartTime!);
      formattedStartTime.value = formatTime1(rawStartTime!);
      formattedEndDayDateMonth.value = formatDayDate1(rawEndTime!);
      formattedEndTime.value = formatTime1(rawEndTime!);
      tripType.value = arguments!["tripType"] ?? '';
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  Map<String, dynamic>? arguments = Get.arguments;
  // Rx<TripData> tripData = TripData().obs;
  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;

  Rx<String> testString = 'hello world'.obs;
  Rx<String> formattedStartDayDateMonth = ''.obs;
  Rx<String> formattedStartTime = ''.obs;
  Rx<String> formattedEndDayDateMonth = ''.obs;
  Rx<String> formattedEndTime = ''.obs;

  Rx<String> carId = ''.obs;
  Rx<int> tripsDays = 0.obs;
  Rx<String> pricePerDay = ''.obs;
  Rx<String> tripDaysTotal = ''.obs;
  Rx<String> vatValue = ''.obs;

  Rx<String> estimatedTotal = ''.obs;
  Rx<String> vat = ''.obs;

  Rx<String> tripType = ''.obs;
  String? rawStartTime;
  String? rawEndTime;
  Rx<String> discountTotal = '0.0'.obs;

  // bool args = Get.arguments;

  void goBack() => routeService.goBack();
  void routeToHome() => routeService.gotoRoute(AppLinks.carRenterLanding);

  Future<void> addTrip({BuildContext? context}) async {
    isLoading.value = true;
    try {
      final response = await paymentService.addTrip(data: {
        "carID": carId.value, // the CarID
        "tripStartDate": rawStartTime, // Trip Start date
        "tripEndDate": rawEndTime, // Trips end date
        "tripsDays":
            tripsDays.value.toString(), // Number of days the user select.
        "tripType":
            tripType.value, // Type of trips either chauffeur or self drive
        // "interState" : "false", // Interstate allow true or false
        // "interStateAddress" : null, // Inter state address
        // "escort" : "false",// Escort Allow true or false
        // "escortValue" : null, // Number of escort
        // "pickUpType" : "true", // Pick up type either self or pickup
        // "pickUpAddress" : "yaba", // pick up address
        // "dropOffType" : "true", // dropoff type either self or pickup
        // "dropOffAddress" : null, // drop off adddress
        // "routeStart" : "yaba", // route start
        // "routeEnd" : "ikeja" // route end
      });

      if (response.status == 'success' || response.status_code == 200) {
        // call the flutterwave checkout URL
        logger.log("Success: ${response.data}");

        if (response.data['link'] != null) {
          var url = response.data["link"];
          var value =
              await routeService.gotoRoute(AppLinks.paymentWebView, arguments: {
            "checkoutUrl": url,
          });

          if (value != null && value == true) {
            // payment success
            successDialog(
                title: AppStrings.paymentSuccessful,
                body: AppStrings.weWillSendYouNotification,
                buttonTitle: AppStrings.home,
                onTap: () =>
                    routeService.offAllNamed(AppLinks.carRenterLanding));
          }
          logger.log("Value is:: $value");
        } 
      } else {
        // error
        logger.log("Error adding trip:: ${response.message ?? ''}");
        showErrorSnackbar(message: response.message ?? '');
      }
    } catch (exception) {
      logger.log("Exception:: ${exception.toString()}");
      if (exception.toString().contains("NoSuchMethodError")) {
        showErrorSnackbar(message: "Error: No Such Method");
      } else {
        showErrorSnackbar(message: "$exception");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
