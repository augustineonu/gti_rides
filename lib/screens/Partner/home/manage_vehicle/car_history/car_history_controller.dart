import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/route_service.dart';

class CarHistoryController extends GetxController
    with StateMixin<List<dynamic>> {
  Logger logger = Logger("Controller");

  CarHistoryController() {
    init();
  }

  void init() async {
    logger.log("CarHistoryController Initialized");

    Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null) {
      brandModelName.value = arguments['brandModelName'];
      photoUrl.value = arguments['photoUrl'];
      carID.value = arguments['carID'];

      // Now you have access to the passed data (emailOrPhone)
      logger.log('Received data $arguments');
    }
    await getCarHistory();
  }

  @override
  void onInit() async {
    update();
    // Get.delete<CarHistoryController>();
    // Get.put(CarHistoryController());

    super.onInit();
  }

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
  RxString brandModelName = "".obs;
  RxString photoUrl = "".obs;
  RxString carID = "".obs;
  RxString startDate = "".obs;
  RxString endDate = "".obs;
  RxString pricePerDay = "".obs;
  RxList<dynamic> carHistory = RxList<dynamic>();

  Rx<String> testString = "".obs;

  void goBack() => routeService.goBack();
  void routeToFeedbacks() => routeService.gotoRoute(AppLinks.feedback);
  void routeToOwnerTrips() => routeService.gotoRoute(AppLinks.ownerTrips);
  Future<Object?>? routeToQuickEdit1 () {
     Get.toNamed(AppLinks.quickEdit, arguments: {
        "startDate": startDate.value,
        "endDate": endDate.value,
        "pricePerDay": pricePerDay.value,
         "brandModelName": brandModelName.value,
         "photoUrl": photoUrl.value,
         "carID": carID.value,
      }
      );
  }
  void routeToQuickEdit() =>
      routeService.gotoRoute(AppLinks.quickEdit, arguments: {
        "startDate": startDate.value,
        "endDate": endDate.value,
        "pricePerDay": pricePerDay.value,
         "brandModelName": brandModelName.value,
         "photoUrl": photoUrl.value,
         "carID": carID.value,
      });

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
    change(<String>[].obs, status: RxStatus.loading());
    try {
      final response = await partnerService.getOnCar(carId: carID.value);

      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten car history ${response.data}");
        if (response.data != null && response.data!.isNotEmpty) {
          carHistory.value = response.data!;
          change(response.data!, status: RxStatus.success());
          startDate.value = response.data![0]['startDate'] ?? '';
          endDate.value = response.data!.first['endDate'] ?? '';
          pricePerDay.value = response.data!.first['pricePerDay'] ?? '';
          brandModelName.value = response.data!.first['brandModelName'] ?? '';
          photoUrl.value = response.data!.first['photoUrl'] ?? '';
          carID.value = response.data!.first['carID'];
          // logger.log("car history $carHistory");
        } else {
          change(<String>[].obs, status: RxStatus.empty());
        }
      } else {
        logger.log("unable to get car history ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
      change(<String>[].obs, status: RxStatus.error(exception.toString()));
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    Get.delete<CarHistoryController>();
  }
}
