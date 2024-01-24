import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/partner/car_list_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class ManageVehicleController extends GetxController
    with StateMixin<List<dynamic>> {
  Logger logger = Logger("Controller");

  ManageVehicleController() {
    init();
  }

  void init() async {
    logger.log("ManageVehicleController Initialized");
    await getAllCars();
    await getBookedCars();
  }

  @override
  void onInit() async {
    pageController.addListener(() {
      update();
    });
    // Get.find<ManageVehicleController>().onInit();

    super.onInit();
  }

  // variables
  RxList<CarData> carList = <CarData>[].obs;
  RxBool isLoading = false.obs;
  RxBool isFetchingCars = false.obs;
  RxBool isDeletingCar = false.obs;
  RxBool isAvailable = false.obs;
  PageController pageController = PageController();
  RxInt selectedIndex = 0.obs;
  RxString testString = "".obs;
  RxList<dynamic>? cars = <dynamic>[].obs;
  RxList<dynamic>? bookedCars = <dynamic>[].obs;

  TextEditingController senderNameController = TextEditingController();

  List<Map<String, String>> quickOptions = [
    {
      "imageUrl": ImageAssets.treashBin,
      "title": AppStrings.remove,
    },
    {
      "imageUrl": ImageAssets.pencilEdit,
      "title": AppStrings.quickEdit,
    },
    {
      "imageUrl": ImageAssets.pencilPlain,
      "title": AppStrings.edit,
    },
    {
      "imageUrl": ImageAssets.history,
      "title": AppStrings.carHistory,
    },
  ];

// routing methods
  void goBack() => routeService.goBack();
  void routeToQuickEdit({Object? arguments}) {
    if (Get.isBottomSheetOpen == true) {
      Get.back();
          Get.delete<ManageVehicleController>();

      routeService.gotoRoute(AppLinks.quickEdit, arguments: arguments);
    } else {
      routeService.gotoRoute(AppLinks.quickEdit, arguments: arguments);
    }
  }

  void routeToCarHistory({Object? arguments}) {
    if (Get.isBottomSheetOpen == true) {
      Get.back();
      routeService.gotoRoute(AppLinks.carHistory, arguments: arguments);
    } else {
      routeService.gotoRoute(AppLinks.carHistory, arguments: arguments);
    }
  }

  void onToggleCarAvailability(bool value) => isAvailable.value = value;
  void routeToListVehicle({Object? arguments}) {
    if (Get.isBottomSheetOpen == true) {
      Get.back();
      routeService.gotoRoute(AppLinks.listVehicle, arguments: arguments);
    } else {
      routeService.gotoRoute(AppLinks.listVehicle, arguments: arguments);
    }
  }

  Future<void> getAllCars() async {
    logger.log("get all cars called::::");
    change(<dynamic>[].obs, status: RxStatus.loading());
    try {
      final response = await partnerService.getCars(queryType: 'all');
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten cars ${response.data}");
        if (response.data == null || response.data!.isEmpty) {
          change(<dynamic>[].obs, status: RxStatus.empty());
          
          logger.log("cars $cars");
        } else {
          cars?.value = response.data!;
          change(response.data!, status: RxStatus.success());
          
          // change(response.data!.cast<CarData>(), status: RxStatus.success());
          update();
        }
        isFetchingCars.value = false;
      } else {
        logger.log("unable to get cars ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
      change(<dynamic>[].obs, status: RxStatus.error(exception.toString()));
    }
  }

  Future<void> getBookedCars() async {
    isFetchingCars.value = true;
    try {
      final response = await partnerService.getCars(queryType: 'booked');
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten booked cars ${response.data}");
        if (response.data != null) {
          bookedCars?.value = response.data!;
          logger.log("booked cars $bookedCars");
        }
        isFetchingCars.value = false;
      } else {
        logger.log("unable to get booked cars ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
    }
  }

  Future<void> deleteCar({required String carID}) async {
    isDeletingCar.value = true;
    try {
      final result = await partnerService.deleteCar(carID: carID);
      if (result.status == "success") {
        showSuccessSnackbar(message: result.message!);
        isDeletingCar.value = false;
        Future.delayed(const Duration(milliseconds: 1000), () {
          routeService.goBack(closeOverlays: true);
        });
      } else {
        logger.log("error deleting car:: ${result.message}");
        showErrorSnackbar(message: result.message ?? 'unable to delete car');
      }
    } catch (exception) {
      isDeletingCar.value = false;
      logger.log("error deleting car:: ${exception.toString()}");
      showErrorSnackbar(message: exception.toString());
    }
  }

  // @override
  // void dispose() {
  //   Get.delete<ManageVehicleController>();
  //   super.dispose();
  // }
}
