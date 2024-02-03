import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/partner/car_history_model.dart';
import 'package:gti_rides/models/renter/trip_amount_model.dart';
import 'package:gti_rides/models/renter/trip_data_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/figures_helpers.dart';
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
      carId.value = arguments!['carId'];
      startDateTime.value = arguments!['startDateTime'] ?? '';
      endDateTime.value = arguments!['endDateTime'] ?? '';
      tripDays.value = arguments!['differenceInDays'] ?? 0;
      await getTripAmountData();
      await getCarHistory();
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

  ScrollController scrollController = ScrollController();
  TextEditingController interStateInputController = TextEditingController();
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
  RxBool selectedSelfPickUp = false.obs;
  RxBool selectedSelfDropOff = false.obs;
  RxBool isLiked = false.obs;
  RxBool isAddingFavCar = false.obs;
  RxBool isDeletingFavCar = false.obs;

  Rx<String> testString = "Hello".obs;
  Rx<String> carId = "".obs;
  Rx<String> startDateTime = "".obs;
  Rx<String> endDateTime = "".obs;
  RxList<dynamic>? reviews = <dynamic>[].obs;

  // add trip information
  Rx<int> tripDays = 0.obs;
  Rx<String> pricePerDay = ''.obs;
  Rx<String> estimatedTotal = '0.0'.obs;
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
  Rx<String> cautionFee = ''.obs;
  Rx<String> dropOffFee = ''.obs;
  Rx<String> pickUpFee = ''.obs;
  Rx<String> escortFee = ''.obs;
  Rx<String> totalEscortFee = ''.obs;
  // Rx<String> pickUp = ''.obs;
  Rx<String> vatValue = ''.obs;
  Rx<String> formattedVatValue = ''.obs;

  void goBack() => routeService.goBack();
  void routeToSearchFilter() => routeService.gotoRoute(AppLinks.searchFilter);
  void routeToReviews() => routeService
      .gotoRoute(AppLinks.reviews, arguments: {"carId": carId.value});
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

  void onChangeEscortNumber() async {
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
      selectedSelfDropOff.value = false;
      selectedSelfPickUp.value = false;
      await updateEstimatedTotal();
    } else {
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

  void onAddPhotoToFav({required String carId}) async {
    if (!isRequestInProgress) {
      isRequestInProgress = true;

      isLiked.value = !isLiked.value;

      if (isLiked.value) {
        await favoriteCar(carId: carId);
      } else {
        await deleteFavoriteCar(carId: carId);
      }

      // Introduce a delay before allowing another request
      Future.delayed(const Duration(seconds: 2), () {
        isRequestInProgress = false;
      });
    }
  }

  // i can also try to reset all self drive values when Chauffeur is selected
  Future<void> updateEstimatedTotal() async {
    // double total = calculateEstimatedTotal(pricePerDay.value, tripDays.value);

    double escortFeeTotal = selectedSecurityEscort.value &&
            escortSecurityNoInputController.text.isNotEmpty
        ? await calculateEscortFee(
            escortFee: escortFee.value,
            numberOfEscort: escortSecurityNoInputController.text,
          )
        : 0.0;
    totalEscortFee.value = escortFeeTotal.toString();

    double sumTotal = await calculatePriceChangesDifference(
      total: initialEstimatedTotal.value,
      cautionFee:
          tripType.value == 1 && cautionFee.isNotEmpty ? cautionFee.value : '0',
      dropOffFee: selectedSelfDropOff.value ? dropOffFee.value : '0',
      pickUpFee: selectedSelfPickUp.value ? pickUpFee.value : '0',
      // still need to calculate the escort fee
      // which is number of escort x escort fee
      // escortFee: selectedSecurityEscort.value ? escortFee.value : '0',
    );

    var updatedTotalValue = escortFeeTotal + sumTotal;

    estimatedTotal.value = await formatAmount(updatedTotalValue);

    logger.log("new sum total:: ${estimatedTotal.value}");

    double vatAmount = await calculateVAT(updatedTotalValue, vatValue.value);
    formattedVatValue.value = await formatAmount(vatAmount);
  }

  Future<void> getEscortFee() async {
    var sumTotal = await calculateEscortFee(
      escortFee: escortFee.value,
      numberOfEscort: escortSecurityNoInputController.text,
      // initialEstimatedTotal: initialEstimatedTotal.value
    );

    estimatedTotal.value = await formatAmount(sumTotal);
    logger.log("new sum total:: ${estimatedTotal.value}");

    double vatAmount = await calculateVAT(sumTotal, vatValue.value);
    formattedVatValue.value = await formatAmount(vatAmount);
  }

  Future<void> getCarHistory() async {
    change(<CarHistoryData>[].obs, status: RxStatus.loading());
    try {
      final response = await renterService.getOneCar(carId: carId.value);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("car history::${response.data}");

        if (response.data == null || response.data!.isEmpty) {
          // If the list is empty
          change(<CarHistoryData>[].obs, status: RxStatus.empty());
        } else {
          // If the list is not empty
          List<CarHistoryData> carHistory = List<CarHistoryData>.from(
            response.data!.map((car) => CarHistoryData.fromJson(car)),
          );
          change(carHistory, status: RxStatus.success());

          pricePerDay.value = carHistory.first.pricePerDay;
          total.value =
              await calculateEstimatedTotal(pricePerDay.value, tripDays.value);
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

  Future<void> processCarBooking() async {
    // here call get User KYC.
    // if infor passes? take user to summary page, otherwise
    // take user to KycCheckScreen
    if (tripType.value == 0 && !chauffeurFormKey.currentState!.validate()) {
      return;
    }
    if (tripType.value == 1 && !selfDriveFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    final kycResponse = await userService.getKycProfile();

    // if user has KYC details, route to payment summary
    // else take them to kyc screen

    TripData tripData = TripData(
        carID: carId.value,
        tripStartDate: startDateTime.value,
        tripEndDate: endDateTime.value,
        tripsDays: tripDays.value.toString(),
        tripType: tripType.value == 0 ? "chauffeur" : "self drive",
        interState: selectedInterState.value ? "true" : "false",
        interStateAddress:
            selectedInterState.value ? interStateInputController.text : null,
        escort: selectedSecurityEscort.value ? "true" : "false",
        escortValue: selectedSecurityEscort.value
            ? escortSecurityNoInputController.text
            : null,
        pickUpType:
            tripType.value == 1 && selectedSelfPickUp.value ? "true" : "false",
        pickUpAddress: tripType.value == 1 && selectedSelfPickUp.value
            ? selfPickUpInputController.text
            : null,
        dropOffType:
            tripType.value == 1 && selectedSelfDropOff.value ? "true" : "false",
        dropOffAddress: tripType.value == 1 && selectedSelfDropOff.value
            ? selfDropOffInputController.text
            : null,
        routeStart: tripType.value == 0 ? startRouteController.text : null,
        routeEnd: tripType.value == 0 ? endRouteController.text : null);

    try {
      routeService.gotoRoute(AppLinks.paymentSummary, arguments: {
        "tripData": tripData,
        "pricePerDay": pricePerDay.value,
        "tripDays": tripDays.value,
        "estimatedTotal": estimatedTotal.value,
        "vatValue": formattedVatValue.value,
        "vat": vatValue.value,
        "cautionFee": tripType.value == 1 ? cautionFee.value : null,
        "dropOffFee": tripType.value == 1 && selectedSelfDropOff.value
            ? dropOffFee.value
            : null,
        "pickUp": tripType.value == 1 && selectedSelfPickUp.value
            ? pickUpFee.value
            : null,
        "escortFee": selectedSecurityEscort.value ? totalEscortFee.value : null,

        // "startDateTime": startDateTime.value,
        // "endDateTime": endDateTime.value,
      });
    } catch (exception) {
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
          cautionFee.value = tripAmountData.first.cautionFee!;
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
          reviews?.value = response.data!;
        } else {
          // If the list is not empty
          reviews?.value = response.data!;

          // change(carHistory, status: RxStatus.success());
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
