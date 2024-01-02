import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/Partner/home/list_vehicle/list_vehicle_screen.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';

class ManageVehicleController extends GetxController {
  Logger logger = Logger("Controller");

  ManageVehicleController() {
    init();
  }

  void init() {
    logger.log("ManageVehicleController Initialized");
  }

  @override
  void onInit() async {
    pageController.addListener(() {
      update();
    });
    super.onInit();
  }

  // variables
  RxBool isLoading = false.obs;
  PageController pageController = PageController();
  RxInt selectedIndex = 0.obs;
  RxString testString = "".obs;
  RxList<dynamic>? cars = <dynamic>[].obs;

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
  void routeToQuickEdit() => routeService.gotoRoute(AppLinks.quickEdit);
  void routeToCarHistory() => routeService.gotoRoute(AppLinks.carHistory);

  Future<void> getCars() async {
    try {
      final response = await partnerService.getCars();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten cars ${response.data}");
        if (response.data != null) {
          cars?.value = response.data!;
          logger.log("cars $cars");
        }
      } else {
        logger.log("unable to get cars ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
    }
  }
}
