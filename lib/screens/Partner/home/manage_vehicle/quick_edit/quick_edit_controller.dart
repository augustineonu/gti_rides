import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/Partner/home/list_vehicle/list_vehicle_screen.dart';
import 'package:gti_rides/screens/Partner/home/manage_vehicle/car_history/car_history_controller.dart';
import 'package:gti_rides/screens/Partner/home/manage_vehicle/manage_vehicle_controller.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class QuickEditController extends GetxController {
  Logger logger = Logger("QuickEdit Controller");
  final manageVehicleController = Get.put(ManageVehicleController());
  final carHistoryController = Get.put(CarHistoryController());

  QuickEditController() {
    init();
  }

  void init() {
    logger.log("QuickEditController Initialized");
  }

  @override
  void onInit() async {
    Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null) {
      brandModelName.value = arguments['brandModelName'] ?? '';
      photoUrl.value = arguments['photoUrl'] ?? '';
      carID.value = arguments['carID'];

      startDateTime.value = formateDate(date: arguments['start'] ?? '');
      endDateTime.value =formateDate(date: arguments['end'] ?? '');
      pricePerDay.value = arguments['pricePerDay'] ?? '';

      // startDate.value = arguments["startDate"] ?? '';
      // endDate.value = arguments["endDate"] ?? '';
      enablePastDates.value = arguments['enablePastDates'] ?? true;
      isFromManageCars.value = arguments['isFromManageCars'] ?? false;

      // Now you have access to the passed data (emailOrPhone)
      logger.log('Received data $arguments');
    }
    pageController.addListener(() {
      update();
    });
    super.onInit();
    startDateController = TextEditingController(text: startDateTime.value);
    endDateController = TextEditingController(text: endDateTime.value);
    pricePerDayController = TextEditingController(text: pricePerDay.value);
  }

  GlobalKey<FormState> amountFormKey = GlobalKey<FormState>();
  // variables
  RxBool isLoading = false.obs;
  RxBool enablePastDates = true.obs;
  PageController pageController = PageController();
  RxInt selectedIndex = 0.obs;
  RxString testString = "".obs;
  RxString brandModelName = "".obs;
  RxString photoUrl = "".obs;
  RxString carID = "".obs;
  RxString startDateTime = "".obs;
  RxString endDateTime = "".obs;
  RxString pricePerDay = "".obs;
  Rx<bool> isFromManageCars = false.obs;
DateTime? rawStartTime;
DateTime? rawEndTime;


  TextEditingController senderNameController = TextEditingController();
  late TextEditingController pricePerDayController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;

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
  void goBack1() => routeService.goBack(closeOverlays: true);

  Future<void> quickEditCar() async {
    if (!amountFormKey.currentState!.validate()) {
      return;
    }
    if (startDateTime.value.isEmpty && endDateTime.value.isEmpty) {
      showErrorSnackbar(message: 'Kindly select availability date');
      return;
    }
    isLoading.value = true;

    try {
      final result = await partnerService.carQuickEdit(payload: {
        "startDate": rawStartTime!.toIso8601String(),
        "endDate": rawEndTime!.toIso8601String(),
        "pricePerDay": pricePerDayController.text
      }, carID: carID.value);
      if (result.status == "success") {
        showSuccessSnackbar(message: result.message!);

        // manageVehicleController.init();
        Future.delayed(const Duration(milliseconds: 1000), () {})
            .whenComplete(() {
          // Get.back(closeOverlays: true);
          if (isFromManageCars.value) {
            Get.offNamedUntil(
              AppLinks.manageVehicle,
              ModalRoute.withName(AppLinks.carOwnerLanding),
            );
          } else {
            Get.offNamedUntil(AppLinks.carHistory,
                ModalRoute.withName(AppLinks.carOwnerLanding),
                arguments: {
                  "carID": carID.value,
                });
          }
          manageVehicleController.getAllCars();
          carHistoryController.getCarHistory(modifiedCarID: carID.value);
        });
      } else {
        showErrorSnackbar(message: result.message!);
        logger.log("error editing car:: ${result.message!}");
        isLoading.value = false;
      }
    } catch (exception) {
      isLoading.value = false;
      showErrorSnackbar(message: exception.toString());
      logger.log("error editing car:: ${exception.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
