import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/partner/car_history_model.dart';
import 'package:gti_rides/models/renter/booked_dates.dart';
import 'package:gti_rides/models/renter/trip_amount_model.dart';
import 'package:gti_rides/models/renter/trip_data_model.dart';
import 'package:gti_rides/models/review_response_model.dart';
import 'package:gti_rides/models/user/kyc_response_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/renter/home/search_result/car_selection_result/widgets/booked_sheet.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/figures_helpers.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class CarSelectionResultController extends GetxController
    with StateMixin<List<CarHistoryData>> {
  Logger logger = Logger("Controller");

  CarSelectionResultController() {
    init();
  }

  void init() async {
    logger.log("CarSelectionResultController Initialized");

    if (arguments != null) {
      logger.log("Received data:: $arguments");
      carId.value = arguments!['carId'] ?? '';
      startDateTime.value = arguments!['startDateTime'] ?? '';
      endDateTime.value = arguments!['endDateTime'] ?? '';
      tripDays.value = arguments!['differenceInDays'] ?? 0;

      rawStartTime = arguments?["rawStartTime"] ?? DateTime.now();
      rawEndTime = arguments?["rawEndTime"] ?? DateTime.now();

      await getTripAmountData();
      if (carId.value != '') {
        await getCarHistory();
      }
      await getCarReview();
    }
  }

  @override
  void onInit() async {
    update();

    super.onInit();
  }

  @override
  void onReady() {
    // called after the widget is rendered on screen
    // showIntroDialog();
    super.onReady();
  }

  Map<String, dynamic>? arguments = Get.arguments;
  GlobalKey<FormState> chauffeurFormKey = GlobalKey();
  GlobalKey<FormState> selfDriveFormKey = GlobalKey();
  Rx<TripData> tripData = TripData().obs;

  ScrollController scrollController = ScrollController();
  TextEditingController interStateInputController = TextEditingController();
  TextEditingController inputPickupAddController = TextEditingController();
  TextEditingController escortSecurityNoInputController =
      TextEditingController();
  TextEditingController selfPickUpInputController = TextEditingController();
  TextEditingController selfDropOffInputController = TextEditingController();
  TextEditingController startRouteController = TextEditingController();
  TextEditingController endRouteController = TextEditingController();
  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  PageController pageController = PageController();
  RxBool isLoading = false.obs;
  RxBool selectedInterState = false.obs;
  RxBool selectedSecurityEscort = false.obs;
  RxBool selectedSelfPickUp = true.obs;
  RxBool selectedSelfDropOff = true.obs;
  RxBool isLiked = false.obs;
  RxBool isAddingFavCar = false.obs;
  RxBool isDeletingFavCar = false.obs;

  Rx<String> testString = "Hello".obs;
  Rx<String> carId = "".obs;
  Rx<String> startDateTime = "".obs;
  Rx<String> endDateTime = "".obs;
  RxList<ReviewData>? reviews = <ReviewData>[].obs;

  // add trip information
  Rx<int> tripDays = 0.obs;
  Rx<String> pricePerDay = ''.obs;
  Rx<String> estimatedTotal = '0.0'.obs;
  Rx<String> tripDaysTotal = '0.0'.obs;
  Rx<String> initialEstimatedTotal = '0.0'.obs;
  Rx<double> total = 0.0.obs;
  Rx<int> tripType = 0.obs;
  Rx<bool> interState = false.obs;
  Rx<String> interStateAddress = ''.obs;
  Rx<bool> escort = false.obs;
  Rx<int> escortValue = 0.obs;
  Rx<String> pickUpType = ''.obs;
  Rx<String> pickUpAddress = ''.obs;
  Rx<String> dropOffType = ''.obs;
  Rx<String> dropOffAddress = ''.obs;
  Rx<String> routeStart = ''.obs;
  Rx<String> routeEnd = ''.obs;
  RxList<TripAmountData> tripAmountData = <TripAmountData>[].obs;

  // trips amount data
  Rx<String>? cautionFee = ''.obs;
  Rx<String> dropOffFee = ''.obs;
  Rx<String> pickUpFee = ''.obs;
  Rx<String> escortFee = ''.obs;
  Rx<String> totalEscortFee = ''.obs;
  // Rx<String> pickUp = ''.obs;
  Rx<String> vatValue = ''.obs;
  Rx<String> formattedVatValue = ''.obs;
  DateTime? rawStartTime;
  DateTime? rawEndTime;
  List<CarHistoryData>? carHistory;

  void copy({required String value}) async {
    await Clipboard.setData(ClipboardData(text: value));

    await showSuccessSnackbar(message: AppStrings.copied);
  }

  void goBack() => routeService.goBack();
  void routeToSearchFilter() => routeService.gotoRoute(AppLinks.searchFilter);
  void routeToReviews({Object? arguments}) =>
      routeService.gotoRoute(AppLinks.reviews, arguments: {
        "carId": carId.value,
        "vehicleName": vehicleName.value,
        "photoUrl": photoUrl.value,
      });
  void routeToViewCar({Object? arguments}) =>
      routeService.gotoRoute(AppLinks.viewCar, arguments: arguments);
  void routeToKycCheck() => routeService.gotoRoute(AppLinks.kycCheck);

  void onSelectInterState(bool value) => selectedInterState.value = value;

  void onSelectSecurityEscort(bool value) async {
    selectedSecurityEscort.value = value;
    if (selectedSecurityEscort.value == true) {
      await updateEstimatedTotal();
    } else {
      escortSecurityNoInputController.clear();
      await updateEstimatedTotal();
      // estimatedTotal.value = initialEstimatedTotal.value;
    }
  }

  void onChangeEscortNumber({String? value}) async {
    escortSecurityNoInputController.text = value!;
    await Future.delayed(const Duration(seconds: 2))
        .then((value) => updateEstimatedTotal());
  }

  void onSelectSelfPickUp(bool value) async {
    selectedSelfPickUp.value = value;
    await updateEstimatedTotal();
  }

  void onSelectSelfDropOff(bool value) async {
    selectedSelfDropOff.value = value;
    await updateEstimatedTotal();
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> shareRide() async {
    Share.share('Book a ride at ${AppStrings.websiteUrl}');
  }

  void onPageChanged(int value) {
    currentIndex.value = value;
    pageController.animateToPage(
      value,
      duration:
          const Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.easeIn,
    );
    update();
  }

  // onSelect self drive or cheuffeur
  void onChangeTripType(int value) async {
    // i have to reset the values of Chauffeeur is selected
    // if self drive is selected i call updateEstimatedTotal
    tripType.value = value;
    if (tripType.value == 0) {
      // reset the values
      // estimatedTotal.value = initialEstimatedTotal.value;
      selectedSecurityEscort.value = false;
      escortSecurityNoInputController.clear();
      selectedSelfDropOff.value = true;
      selectedSelfPickUp.value = true;
      await updateEstimatedTotal();
    } else {
      selectedSelfDropOff.value = false;
      selectedSelfPickUp.value = false;
      selectedSecurityEscort.value = false;
      escortSecurityNoInputController.clear();
      await updateEstimatedTotal();
    }
    pageController.animateToPage(
      value,
      duration:
          const Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.easeIn,
    );
    update();
  }

  bool isRequestInProgress = false;

  Future<void> onAddCarToFav({required String carId, bool? carStatus}) async {
    if (!isRequestInProgress) {
      isRequestInProgress = true;

      isLiked.value = carStatus!;

      if (isLiked.value) {
        await deleteFavoriteCar(carId: carId);
        update();
      } else {
        await favoriteCar(carId: carId);
        update();
      }

      // Introduce a delay before allowing another request
      Future.delayed(const Duration(seconds: 2), () {
        isRequestInProgress = false;
      });
    }
  }

  // i can also try to reset all self drive values when Chauffeur is selected
  Rx<double> updatedTotalValue = 0.0.obs;
  Future<void> updateEstimatedTotal() async {
    // calculate then format escort fee
    double escortFeeTotal = await calculateEscortFeeTotal();
    totalEscortFee.value = await formatAmount(escortFeeTotal);

    double sumTotal = await calculateTotalPriceChangesDifference();

    updatedTotalValue.value = escortFeeTotal + sumTotal;

    await applyDiscount();

    logResults();
  }

  Future<double> calculateEscortFeeTotal() async {
    return selectedSecurityEscort.value &&
            escortSecurityNoInputController.text.isNotEmpty
        ? await calculateEscortFee(
            escortFee: escortFee.value,
            numberOfEscort: escortSecurityNoInputController.text,
            tripDays: tripDays.value)
        : 0.0;
  }

  Future<double> calculateTotalPriceChangesDifference() async {
    return await calculatePriceChangesDifference(
      total: initialEstimatedTotal.value,
      // cautionFee: tripType.value == 1 &&
      //         cautionFee!.isNotEmpty &&
      //         cautionFee?.value != "null"
      //     ? cautionFee!.value
      //     : '0.0',
      dropOffFee: !selectedSelfDropOff.value ? dropOffFee.value : '0.0',
      pickUpFee: !selectedSelfPickUp.value ? pickUpFee.value : '0.0',
    );
  }

  Rx<double> discountTotal = 0.0.obs;
  Rx<String> discountTotalFee = ''.obs;
  Rx<bool> discountApplied = false.obs;

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
        // updatedTotalValue.value -= discountTotal.value;
        updatedTotalValue.value -= discount;
        // tripDaysTotal.value = await formatAmount(updatedTotalValue.value);
        logger.log("Total price after discount: ${updatedTotalValue.value}");
      }
    } else {
      // Handle the case where discountPercentage is null
      logger.log("Discount percentage is null");
    }
  }

  void logResults() {
    logger.log("Estimated total: ${estimatedTotal.value}");
    logger.log("New total: $updatedTotalValue");
  }

  Future<void> addGrandTotal() async {
    // logger.log("first time value $caution");
    logger.log("Total before summing:: ${updatedTotalValue.value}");
    double vatAmount =
        await calculateVAT(updatedTotalValue.value, vatValue.value);
    logger.log("VAT total:: $vatAmount");
    formattedVatValue.value = await formatAmount(vatAmount);

    // sum up vat plus updated total
    // then add the caution fee here
    // caution fee should be added if user selects selfDrive
    // String valueToParse;
    // if (cautionFee == null) {
    //   valueToParse = 0.toString();
    // } else {
    //   valueToParse = cautionFee!.replaceAll(',', '');
    // }

    // var caution = double.parse(valueToParse);
    double caution = 0;
    if (cautionFee != null) {
      caution = double.parse(cautionFee!.replaceAll(',', ''));
    }
    updatedTotalValue.value = updatedTotalValue.value +
        vatAmount +
        (tripType.value == 1 ? caution : 0);

    estimatedTotal.value = await formatAmount(updatedTotalValue.value);
    logger.log("Total after summing:: ${estimatedTotal.value}");
  }

  DateTime? carAvialbilityEndDate;
  Rx<String> vehicleName = ''.obs;
  Rx<String> photoUrl = ''.obs;
  Rx<String> brand = ''.obs;
  Rx<String> brandModel = ''.obs;

  Future<void> getCarHistory() async {
    change(<CarHistoryData>[].obs, status: RxStatus.loading());
    try {
      final response = await renterService.getOneCar(carId: carId.value);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("car history::${response.data}");

        if (response.data?.isEmpty ?? true) {
          // If the list is empty
          change(<CarHistoryData>[].obs, status: RxStatus.empty());
        } else {
          // If the list is not empty
          // List<CarHistoryData> carHistory = List<CarHistoryData>.from(
          //   response.data!.map((car) => CarHistoryData.fromJson(car)),
          // );
          carHistory = response.data!
              .map((car) => CarHistoryData.fromJson(car))
              .toList();

          change(carHistory, status: RxStatus.success());
          brand.value = carHistory!.first.brand!.first.brandName!;
          vehicleName.value =
              '${carHistory!.first.brandModel!.first.modelName!} ${carHistory!.first.brand!.first.brandName!}';
          photoUrl.value = carHistory!.first.photoUrl!;

          var endDateString = carHistory?.first.endDate;
          carAvialbilityEndDate = DateTime.parse(endDateString!);

          cautionFee!.value =
              carHistory!.first.modelYear!.first.cautionFee ?? "0";

          logger.log("Caution fee: ${cautionFee?.value ?? "0.0"}");
          pricePerDay.value = carHistory?.first.pricePerDay;
          //price per day total x no of days
          total.value =
              await calculateEstimatedTotal(pricePerDay.value, tripDays.value);

          tripDaysTotal.value = await formatAmount(total.value);
          //
          estimatedTotal.value = await formatAmount(total.value);
          // this value would be used to reset user selection
          initialEstimatedTotal.value = await formatAmount(total.value);

          double vatAmount = await calculateVAT(total.value, vatValue.value);
          formattedVatValue.value = await formatAmount(vatAmount);

          update();
        }
      } else {
        logger.log("unable to get cars ${response.data}");
      }
    } catch (exception) {
      logger.log("error: ${exception.toString()}");
      change(<CarHistoryData>[].obs,
          status: RxStatus.error(exception.toString()));
    }
  }

  List<String> getRequiredKycFields(int tripType) {
    if (tripType == 0) {
      return ["dateOfBirth", "gender", "emergencyName"];
    } else if (tripType == 1) {
      return [
        "dateOfBirth",
        "emergencyName",
        "gender",
        "homeAddress",
        "occupation",
        "officeAddress",
        "licenceNumber",
      ];
    } else {
      return []; // Handle other trip types as needed
    }
  }

  // List of required KYC fields
  // List<String> requiredKycFields = [
  //   "dateOfBirth",
  //   "emergencyName",
  //   // "emergencyNumber",
  //   "gender",
  //   "homeAddress",
  //   "occupation",
  //   "officeAddress",
  //   "licenceNumber",
  // ];
  // Function to check missing fields
  List<String> getMissingKycFields(KycData kycData, int tripType) {
    List<String> missingKycFields = [];
    List<String> requiredKycFields = getRequiredKycFields(tripType);

    for (String field in requiredKycFields) {
      dynamic fieldValue = kycData.toJson()[field];
      logger.log("field value:: $fieldValue");
      bool isFieldPresent = fieldValue != null && fieldValue.isNotEmpty;
      if (!isFieldPresent) {
        missingKycFields.add(field);
      }
    }

    return missingKycFields;
  }

  RxString carNotAvailable = ''.obs;
  // final controller = Get.put(ChooseTripDateController());

  // bool isDateAfterCarAvailability(
  //     {required DateTime rawEndTime,
  //     required DateTime carAvailabilityEndDate}) {
  //   return rawEndTime.isAfter(carAvailabilityEndDate);
  // }

// raw date should be passed from previous screen
  RxList<BookedData> bookedData = <BookedData>[].obs;
  Future<bool> checkCarAvailability() async {
    try {
      final response = await renterService.getCarTrip(
          carID: carId.value, startDate: rawStartTime!, endDate: rawEndTime!);
      if (response.status == 'success' || response.status_code == 200) {
        if (response.data!.isEmpty) {
          return true;
        } else {
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
      return false;
    }
  }

  Future<void> processCarBooking() async {
    tripData.value = TripData(
        carID: carId.value,
        tripStartDate: startDateTime.value,
        tripEndDate: endDateTime.value,
        tripsDays: tripDays.value.toString(),
        tripType: tripType.value == 0 ? "chauffeur" : "selfDrive",
        interState: selectedInterState.value ? "true" : "false",
        interStateAddress:
            selectedInterState.value ? interStateInputController.text : null,
        escort: selectedSecurityEscort.value ? "true" : "false",
        escortValue: selectedSecurityEscort.value
            ? escortSecurityNoInputController.text
            : null,
        pickUpType: tripType.value == 0
            ? 'true'
            : tripType.value == 1 && selectedSelfPickUp.isTrue
                ? "true"
                : "false",
        pickUpAddress: tripType.value == 0
            ? inputPickupAddController.text
            : tripType.value == 1 && selectedSelfPickUp.isTrue
                ? selfPickUpInputController.text
                : null,
        dropOffType: tripType.value == 0
            ? "true"
            : tripType.value == 1 && selectedSelfDropOff.isTrue
                ? "true"
                : "false",
        dropOffAddress: tripType.value == 1 && selectedSelfDropOff.isTrue
            ? selfDropOffInputController.text
            : null,
        routeStart: tripType.value == 0 ? startRouteController.text : null,
        routeEnd: tripType.value == 0 ? endRouteController.text : null);

    // here call get User KYC.
    // if infor passes? take user to summary page, otherwise
    // take user to KycCheckScreen

    if (tripType.value == 0 && !chauffeurFormKey.currentState!.validate()) {
      return;
    }
    if (tripType.value == 1 && !selfDriveFormKey.currentState!.validate()) {
      return;
    }
    if (startDateTime.value.isEmpty && endDateTime.value.isEmpty) {
      showErrorSnackbar(message: 'Kindly select trip dates');
      return;
    }
    if (carHistory?.first.availability == "notAvailable") {
      showSuccessSnackbar(message: "Car not available");
      return;
    }
    logger.log("Value::  ${cautionFee?.value ?? "value is empty"}");
    // return;

    // var value = double.parse(cautionFee!.replaceAll(',', ''));
    await updateEstimatedTotal();
    await addGrandTotal();

    // return;
    isLoading.value = true;

    // if the user selects a date that is not within the car's availability date
    // it throws this
    var isEndDaterWithinAvailabilityFrame = isDateAfterCarAvailability(
        rawEndTime: rawEndTime!,
        carAvailabilityEndDate: carAvialbilityEndDate!);
    if (isEndDaterWithinAvailabilityFrame) {
      showSuccessSnackbar(
          message: 'Car end date is not within car availability frame');
      isLoading.value = false;
      return;
    }

    // checks car availability frame matching the supplied start and end date if
    // the car is booked within the frame
    var isCarAvailable = await checkCarAvailability();
    if (!isCarAvailable) {
      if (carNotAvailable.value == 'An error occurred') {
        isLoading.value = false;
        return;
      }
      showSuccessSnackbar(message: carNotAvailable.value);
      isLoading.value = false;
      return bookedDatedSheet(
        itemCount: bookedData,
      );
    }
    try {
      final kycResponse = await userService.getKycProfile();

      // if user has KYC details, route to payment summary
      // else take them to kyc screen
      if (kycResponse.status == 'success' || kycResponse.status_code == 200) {
        if (kycResponse.data!.isEmpty || kycResponse.data == []) {
          // route to kyc screen. All kyc
        } else {
          KycData kycData = KycData.fromJson(kycResponse.data?.first);

          // Check missing fields and route accordingly
          List<String> missingKycFields =
              getMissingKycFields(kycData, tripType.value);
          if (missingKycFields.isEmpty) {
            // All required fields are present, proceed to the payment screen
            // ...
            logger.log("All fields are present, proceed to the payment screen");
            logger.log("All ${tripData.value}");
            logger.log("All ${estimatedTotal.value}");
            // return;
            routeService.gotoRoute(AppLinks.paymentSummary, arguments: {
              "appBarTitle": AppStrings.addToContinue,
              "tripData": tripData.value,
              "pricePerDay": pricePerDay.value,
              "tripDays": tripDays.value,
              "estimatedTotal": estimatedTotal.value,
              "tripDaysTotal": tripDaysTotal.value,
              "vatValue": formattedVatValue.value,
              "selectedSelfPickUp": selectedSelfPickUp.value,
              "selectedSelfDropOff": selectedSelfDropOff.value,
              "selectedSecurityEscort": selectedSecurityEscort.value,
              "vat": vatValue.value,
              "tripType": tripType.value,
              "cautionFee": tripType.value == 1 ? cautionFee!.value : '',
              "dropOffFee": tripType.value == 1 && selectedSelfDropOff.isFalse
                  ? dropOffFee.value
                  : null,
              "pickUp": tripType.value == 1 && selectedSelfPickUp.isFalse
                  ? pickUpFee.value
                  : null,
              "totalEscortFee":
                  selectedSecurityEscort.value ? totalEscortFee.value : '',
              "rawStartTime": rawStartTime,
              "rawEndTime": rawEndTime,
              "discountTotal": discountTotalFee.value,
              "numberOfEscort": escortSecurityNoInputController.text
            });
          } else {
            // Some fields are missing, route to KYC screen with the list of missing fields
            // ...
            logger.log("Some fields are missing:: $missingKycFields");
            showSuccessSnackbar(message: 'Kindly update KYC details');
            routeService.gotoRoute(AppLinks.kycCheck, arguments: {
              "isKycUpdate": true, //
              "appBarTitle": AppStrings.addToContinue,
              "tripData": tripData.value,
              "missingKycFields": missingKycFields,
              "pricePerDay": pricePerDay.value,
              "tripDays": tripDays.value,
              "estimatedTotal": estimatedTotal.value,
              "tripDaysTotal": tripDaysTotal.value,
              "vatValue": formattedVatValue.value,
              "selectedSelfPickUp": selectedSelfPickUp.value,
              "selectedSelfDropOff": selectedSelfDropOff.value,
              "selectedSecurityEscort": selectedSecurityEscort.value,
              "vat": vatValue.value,
              "tripType": tripType.value,
              "cautionFee": tripType.value == 1 ? cautionFee!.value : '',
              "dropOffFee": tripType.value == 1 && selectedSelfDropOff.value
                  ? dropOffFee.value
                  : null,
              "pickUpFee": tripType.value == 1 && selectedSelfPickUp.value
                  ? pickUpFee.value
                  : null,
              "totalEscortFee":
                  selectedSecurityEscort.value ? totalEscortFee.value : '',
              "rawStartTime": rawStartTime,
              "rawEndTime": rawEndTime,
              "discountTotal": discountTotalFee.value,
              "numberOfEscort": escortSecurityNoInputController.text
            });
          }
        }
      } else {
        logger.log("Error fetching KYC detials:: ${kycResponse.data}");
        showErrorSnackbar(message: kycResponse.message ?? "");
      }
    } catch (exception) {
      logger.log("Exception: $exception");
    } finally {
      isLoading.value = false;
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
          dropOffFee.value = tripAmountData.first.dropOffFee!;
          escortFee.value = tripAmountData.first.escortFee!;
          pickUpFee.value = tripAmountData.first.pickUp!;
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

  Future<void> favoriteCar({required String carId}) async {
    isAddingFavCar.value = true;
    try {
      final response = await renterService.addFavoriteCar(carId: carId);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("Car added to favorites:: $response");
      } else {
        logger.log("Unable to add car to favorites:: $response");
      }
    } catch (exception) {
      logger.log("error:: ${exception.toString()}");
    } finally {
      isAddingFavCar.value = false;
    }
  }

  Future<void> deleteFavoriteCar({required String carId}) async {
    isDeletingFavCar.value = true;
    try {
      final response = await renterService.deleteFavoriteCar(carId: carId);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("Car deleted from favorites:: ${response}");
      } else {
        logger.log("Unable to delete car from favorites:: ${response}");
      }
    } catch (exception) {
      logger.log("error:: ${exception.toString()}");
    } finally {
      isDeletingFavCar.value = false;
    }
  }

  Future<void> getCarReview() async {
    // change(<CarHistoryData>[].obs, status: RxStatus.loading());
    try {
      final response = await renterService.getReview(carId: carId.value);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("car review::${response.data}");

        if (response.data == null || response.data!.isEmpty) {
          // If the list is empty
          // change(<CarHistoryData>[].obs, status: RxStatus.empty());
          reviews?.value = [];
        } else {
          // If the list is not empty
          // reviews?.value = response.data!;
          reviews?.value = response.data!
              .map((review) => ReviewData.fromJson(review))
              .toList();

          update();
        }
      } else {
        logger.log("unable to get car review ${response.data}");
      }
    } catch (exception) {
      logger.log("error: ${exception.toString()}");
    }
  }

  DateTime? parseFormattedDate(String formattedDate) {
    try {
      // Use a date format that matches your input string
      final DateFormat dateFormat = DateFormat("EEE, dd MMM h:mma");
      return dateFormat.parse(formattedDate);
    } catch (e) {
      return null;
    }
  }
}

//  Future<void> processBooking() async {
//     // Sample KYC response data
//     List<Map<String, dynamic>> kycData = [
//       {
//         // "dateOfBirth": "31-05-1996",
//         "emergencyName": "john",
//         "emergencyNumber": "12345679801",
//         "emergencyRelationship": "brother",
//         // "gender": "male",
//         "homeAddress": "lekki",
//         "occupation": "pm",
//         "officeAddress": "Lagos",
//         "licenceExpireDate": "23-05-2024",
//         "licenceNumber": "1234567876",
//         "homeAddressProof":
//             "https://firebasestorage.googleapis.com/v0/b/gti-rides-backend.appspot.com/o/1706122532733--homeAddress.pdf?alt=media&token=b5784101-dd85-40e0-9513-7374c14d639d"
//       }
//     ];

// // List of required KYC fields
//     List<String> requiredKycFields = [
//       "dateOfBirth",
//       "emergencyName",
//       // "emergencyNumber",
//       "gender",
//       "homeAddress",
//       "occupation",
//       "officeAddress",
//       "licenceNumber",
//     ];

// // Function to check missing fields
//     List<String> getMissingKycFields(List<Map<String, dynamic>> kycData) {
//       List<String> missingKycFields = [];

//       for (String field in requiredKycFields) {
//         bool isFieldPresent =
//             kycData.isNotEmpty && kycData[0].containsKey(field);
//         if (!isFieldPresent) {
//           missingKycFields.add(field);
//         }
//       }

//       return missingKycFields;
//     }

// // Check missing fields and route accordingly
//     List<String> missingKycFields = getMissingKycFields(kycData);
//     if (missingKycFields.isEmpty) {
//       // All required fields are present, proceed to the payment screen
//       // ...
//       logger.log("All fields are present, proceed to the payment screen");
//     } else {
//       // Some fields are missing, route to KYC screen with the list of missing fields
//       // ...
//       logger.log("Some fields are missing:: ${missingKycFields}");
//     }
//   }
