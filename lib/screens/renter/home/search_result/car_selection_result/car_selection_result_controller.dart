import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/partner/car_history_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/constants.dart';
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
      differenceInDays.value = arguments!['differenceInDays'] ?? 0;
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
  void onReady() { // called after the widget is rendered on screen
    // showIntroDialog();
    super.onReady();
  }



  
  

  Map<String, dynamic>? arguments = Get.arguments;

  ScrollController scrollController = ScrollController();
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
  RxBool isLiked = false.obs;
  RxBool isAddingFavCar = false.obs;
  RxBool isDeletingFavCar = false.obs;

  Rx<String> testString = "Hello".obs;
  Rx<String> carId = "".obs;
  Rx<String> startDateTime = "".obs;
  Rx<String> endDateTime = "".obs;
  RxList<dynamic>? reviews = <dynamic>[].obs;
  Rx<int> differenceInDays = 0.obs;
  Rx<String> pricePerDay = ''.obs;
  Rx<int> estimatedTotal = 0.obs;

  void goBack() => routeService.goBack();
  void routeToSearchFilter() => routeService.gotoRoute(AppLinks.searchFilter);
  void routeToReviews() => routeService
      .gotoRoute(AppLinks.reviews, arguments: {"carId": carId.value});
  void routeToViewCar({Object? arguments}) =>
      routeService.gotoRoute(AppLinks.viewCar, arguments: arguments);
  void routeToKycCheck() => routeService.gotoRoute(AppLinks.kycCheck);

  void onSelectInterState(bool value) => selectedInterState.value = value;
  void onSelectSecurityEscort(bool value) =>
      selectedSecurityEscort.value = value;
  void onSelectSelfPickUp(bool value) => selectedSelfPickUp.value = value;

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
          pricePerDay.value = carHistory.first.pricePerDay;
         estimatedTotal.value = await calculateEstimatedTotal(pricePerDay.value, differenceInDays.value);

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

Future<int> calculateEstimatedTotal(String pricePerDay, int difference) async {
  try {
    // Convert the pricePerDay string to double
    int price = int.parse(pricePerDay.replaceAll(',', ''));

    // Calculate the estimated total
    int estimatedTotal = price * difference;

    logger.log("Estimated total: ${estimatedTotal.toString()}");

    return estimatedTotal;
  } catch (e) {
    // Handle the case where the conversion fails
    logger.log("Error converting pricePerDay to double: $e");
    return 0; // or any default value
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
