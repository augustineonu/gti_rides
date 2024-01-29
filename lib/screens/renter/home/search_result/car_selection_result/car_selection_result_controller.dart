import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/partner/car_history_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';

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
      await getCarHistory();
    }
  }

  @override
  void onInit() async {
    update();

    super.onInit();
  }

  Map<String, dynamic>? arguments = Get.arguments;

  TextEditingController interStateInputController = TextEditingController();
  TextEditingController escortSecurityNoInputController =
      TextEditingController();
  TextEditingController selfPickUpInputController = TextEditingController();
  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  PageController pageController = PageController();
  RxBool isLoading = false.obs;
  RxBool selectedInterState = false.obs;
  RxBool selectedSecurityEscort = false.obs;
  RxBool selectedSelfPickUp = false.obs;

  Rx<String> testString = "Hello".obs;
  Rx<String> carId = "".obs;

  void goBack() => routeService.goBack();
  void routeToSearchFilter() => routeService.gotoRoute(AppLinks.searchFilter);
  void routeToReviews() => routeService.gotoRoute(AppLinks.reviews);
  void routeToViewCar() => routeService.gotoRoute(AppLinks.viewCar);
  void routeToKycCheck() => routeService.gotoRoute(AppLinks.kycCheck);

  void onSelectInterState(bool value) => selectedInterState.value = value;
  void onSelectSecurityEscort(bool value) =>
      selectedSecurityEscort.value = value;
  void onSelectSelfPickUp(bool value) => selectedSelfPickUp.value = value;

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
}
