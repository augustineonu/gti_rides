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

  final ScrollController scrollController = ScrollController();
  final ScrollController bookedCarsScrollController = ScrollController();

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
     scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoadingMore.value) {
        getAllCars(isLoadMore: true);
      }
    });

    bookedCarsScrollController.addListener(() {
      if (bookedCarsScrollController.position.pixels == bookedCarsScrollController.position.maxScrollExtent &&
          !isLoadingMoreBooked.value) {
        getBookedCars(isLoadingMore: true);
      }
    });

    super.onInit();
  }

  // variables
  RxList<CarListData> carList = <CarListData>[].obs;
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

  Future<void> onToggleCarAvailability(bool value,
      {required String carId}) async {
    try {
      // Determine the payload based on the desired availability state
      final String availabilityPayload = value ? "available" : "notAvailable";

      final response = await partnerService.toggleCarAvailability(
        payload: {"availability": availabilityPayload},
        carID: carId,
      );

      if (response.status == 'success' || response.status_code == 200) {
        // isAvailable.value = value;
        getAllCars();

        update();
      } else {
        logger.log("error: ${response.message ?? " error message"}");
      }
    } catch (e) {
      logger.log("error: changing car availability");
    }
  }

  void routeToListVehicle({Object? arguments}) {
    if (Get.isBottomSheetOpen == true) {
      Get.back();
      routeService.gotoRoute(AppLinks.listVehicle, arguments: arguments);
    } else {
      routeService.gotoRoute(AppLinks.listVehicle, arguments: arguments);
    }
  }

  
  
  var skip = 0;
  final int limit = 10;
  RxBool isLoadingMore = false.obs;

  Future<void> getAllCars({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isLoadingMore.value = true;
      skip += limit;
    } else {
      skip = 0;
      isLoadingMore.value = false;
    }
    isFetchingCars.value = true;

    try {
      final response = await partnerService.getCars(
        queryType: 'all',
        skip: skip,
        limit: limit,
      );

      if (response.status == 'success' || response.status_code == 200) {
        if (response.data == null || response.data!.isEmpty) {
          if (!isLoadMore) {
            change(<CarListData>[].obs, status: RxStatus.empty());
          }
        } else {
          if (isLoadMore) {
            cars!.addAll(response.data!);
          } else {
            cars!.value = response.data!;
          }
          change(cars, status: RxStatus.success());
        }
      } else {
        logger.log("Unable to get cars: ${response.data}");
      }
    } catch (exception) {
      logger.log("Error: $exception");
      if (!isLoadMore) {
        change(<CarListData>[].obs,
            status: RxStatus.error(exception.toString()));
      }
    } finally {
      isFetchingCars.value = false;
      isLoadingMore.value = false;
    }
  }

  var skipBooked = 0;
  final int limitBooked = 10;
  RxBool isLoadingMoreBooked = false.obs;
  Future<void> getBookedCars({bool isLoadingMore = false}) async {
    isFetchingCars.value = true;

    if (isLoadingMore) {
      isLoadingMoreBooked.value = true;
      skipBooked += limitBooked;
    } else {
      skipBooked = 0;
      isFetchingCars.value = true;
    }
    try {
      final response = await partnerService.getCars(
        queryType: 'booked',
        skip: skipBooked,
        limit: limitBooked,
      );
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten booked cars ${response.data}");
        if (response.data != null) {
          if (isLoadingMore) {
            bookedCars!.addAll(response.data!);
          } else {
            bookedCars?.value = response.data!;
          }
          logger.log("booked cars $bookedCars");
        }
        isFetchingCars.value = false;
      } else {
        logger.log("unable to get booked cars ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
    } finally {
      isLoadingMoreBooked.value = false;
    }
  }

  Future<void> deleteCar({required String carID}) async {
    isDeletingCar.value = true;
    try {
      final result = await partnerService.deleteCar(carID: carID);
      if (result.status == "success") {
        showSuccessSnackbar(message: result.message!);
        isDeletingCar.value = false;
        update();
        // Future.delayed(const Duration(milliseconds: 1000), () {
        // routeService.goBack(closeOverlays: true);
        // });
        Get.offNamedUntil(
          AppLinks.manageVehicle,
          ModalRoute.withName(AppLinks.carOwnerLanding),
        );
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
