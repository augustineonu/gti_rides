import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/screens/Partner/home/list_vehicle/list_vehicle_screen.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class QuickEditController extends GetxController {
  Logger logger = Logger("QuickEdit Controller");

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
      brandModelName.value = arguments['brandModelName'];
      photoUrl.value = arguments['photoUrl'];
      carID.value = arguments['carID'];

      startDateTime.value = arguments['start'] ?? '';
      endDateTime.value = arguments['end'] ?? '';

      // Now you have access to the passed data (emailOrPhone)
      logger.log('Received data $arguments');
    }
    pageController.addListener(() {
      update();
    });
    super.onInit();
  }

  GlobalKey<FormState> amountFormKey = GlobalKey<FormState>();
  // variables
  RxBool isLoading = false.obs;
  PageController pageController = PageController();
  RxInt selectedIndex = 0.obs;
  RxString testString = "".obs;
  RxString brandModelName = "".obs;
  RxString photoUrl = "".obs;
  RxString carID = "".obs;
  RxString startDateTime = "".obs;
  RxString endDateTime = "".obs;

  TextEditingController senderNameController = TextEditingController();
  TextEditingController pricePerDayController = TextEditingController();
  TextEditingController startDateController =
      TextEditingController(text: '01 Jan, 2024');
  TextEditingController endDateController = TextEditingController();

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
        "startDate": startDateTime.value,
        "endDate": endDateTime.value,
        "pricePerDay": pricePerDayController.text
      }, carID: carID.value);
      if (result.status == "success") {
        showSuccessSnackbar(message: result.message!);
        Future.delayed(const Duration(milliseconds: 1000), () {
          Get.back(closeOverlays: true);
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
