import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/trip_data_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/renter/home/search_result/car_selection_result/car_selection_result_controller.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/constants.dart';

class KycCheckController extends GetxController {
  Logger logger = Logger("Controller");
  // final carSelectionController = Get.put(CarSelectionResultController());

  KycCheckController() {
    init();
  }

  void init() {
    logger.log("KycCheckController Initialized");
  }

  @override
  void onInit() async {
    update();

    super.onInit();
    if (arguments != null) {
      logger.log("Received arguments:: $arguments");
      missingKycItems.value = arguments!["missingKycFields"] ?? [];
      logger.log("Received arguments:: ${missingKycItems.value}");
      isCarListing.value = arguments!["isCarListing"] ?? false;

      missingKycFields.value = arguments?["missingKycFields"] ?? [];

      displayKycFields.value = missingKycFields
          .map((fieldName) => mapFieldToDisplayName(fieldName))
          .toList();
      appBarTitle.value = arguments?["appBarTitle"] ?? '';

      tripData.value = arguments?["tripData"] as TripData ?? tripData.value;
      logger.log("trip data:: ${tripData.value.tripType ?? 'lol'}");
      logger.log("${tripData.value.carID}");

      pricePerDay.value = arguments?["pricePerDay"] ?? '';
      estimatedTotal.value = arguments?["estimatedTotal"] ?? '';
      vatValue.value = arguments?["vatValue"] ?? '';
      vat.value = arguments?["vat"] ?? '';
      tripDaysTotal.value = arguments?["tripDaysTotal"] ?? '';
      selectedSelfPickUp.value = arguments?["selectedSelfPickUp"] ?? false;
      selectedSelfDropOff.value = arguments?["selectedSelfDropOff"] ?? false;
      selectedSecurityEscort.value =
          arguments?["selectedSecurityEscort"] ?? false;
      totalEscortFee.value = arguments?["totalEscortFee"] ?? '';
      tripType.value = arguments?["tripType"] ?? 0;

      // already in tripData
      tripDays.value = arguments?["tripDays"] ?? 0;
      // not used
      cautionFee.value = arguments?["cautionFee"] ?? '';

      rawStartTime = arguments!["rawStartTime"] ?? DateTime.now();
      rawEndTime = arguments!["rawEndTime"] ?? DateTime.now();
      discountTotal.value = arguments!["discountTotal"] ?? '0';
    }
  }

  Map<String, dynamic>? arguments = Get.arguments;

  RxList<String> missingKycItems = <String>[].obs;
  RxBool isLoading = false.obs;
  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  PageController pageController = PageController();

  Rx<String> testString = 'hello world'.obs;
  RxList<String> missingKycFields = <String>[].obs;
  RxList displayKycFields = <String>[].obs;

  Rx<bool> isKycUpdate = false.obs;
  Rx<String> appBarTitle = ''.obs;
  Rx<TripData> tripData = TripData().obs;
  Rx<String> pricePerDay = ''.obs;
  Rx<int> tripDays = 0.obs;
  Rx<String> estimatedTotal = ''.obs;
  // Rx<String> formattedVatValue = ''.obs;
  Rx<String> vatValue = ''.obs;
  Rx<String> cautionFee = ''.obs;
  Rx<String> vat = ''.obs;
  Rx<String> dropOffFee = ''.obs;
  Rx<String> pickUpFee = ''.obs;
  Rx<String> escortFee = ''.obs;
  Rx<String> tripDaysTotal = ''.obs;
  RxBool isCarListing = false.obs;
  RxBool selectedSecurityEscort = false.obs;
  RxBool selectedSelfPickUp = false.obs;
  RxBool selectedSelfDropOff = false.obs;
  Rx<String> totalEscortFee = ''.obs;
  Rx<int> tripType = 0.obs;
  DateTime? rawStartTime;
  DateTime? rawEndTime;
  Rx<String> discountTotal = '0.0'.obs;

  void goBack() => routeService.goBack();
  void routeToUpdateKyc() => isCarListing.value
      ? Get.offAndToNamed(AppLinks.partnerIdentityVerification)
      : routeService.gotoRoute(AppLinks.identityVerification, arguments: {
          "isKycUpdate": true, //
          "appBarTitle": AppStrings.addToContinue,
          "tripData": tripData.value, //
          "missingKycFields": missingKycFields.value, //
          "pricePerDay": pricePerDay.value, //
          "tripDays": tripDays.value, //
          "estimatedTotal": estimatedTotal.value, //
          "vatValue": vatValue.value, //
          "vat": vatValue.value, //
          "cautionFee": cautionFee.value, //
          "dropOffFee": dropOffFee.value,
          "pickUpFee": pickUpFee.value, //
          "escortFee": escortFee.value, //
          "tripDaysTotal": tripDaysTotal.value,
          "selectedSelfPickUp": selectedSelfPickUp.value,
          "selectedSelfDropOff": selectedSelfDropOff.value,
          "selectedSecurityEscort": selectedSecurityEscort.value,
          "tripType": tripType.value,
          "totalEscortFee": totalEscortFee.value,
          "rawStartTime": rawStartTime,
          "rawEndTime": rawEndTime,
          "discountTotal": discountTotal.value,
        });

  void onClickPrevious() {
    if (currentIndex > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Map<String, String> fieldMappings = {
    "dateOfBirth": "DOB",
    "emergencyName": "Emergency Contact",
    "gender": "Gender",
    "homeAddress": "Home Address",
    "occupation": "Occupation",
    "officeAddress": "Office Address",
    "licenceNumber": "Driver's License",
    // Add other mappings as needed
  };

  String mapFieldToDisplayName(String fieldName) {
    return fieldMappings[fieldName] ?? fieldName;
  }
}
