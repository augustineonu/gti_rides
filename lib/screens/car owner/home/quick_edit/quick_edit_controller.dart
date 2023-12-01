import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/screens/car%20owner/home/list_vehicle/list_vehicle_screen.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';

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
    pageController.addListener(() {
      update();
    });
    super.onInit();
  }

  // variables
  RxBool isLoading = false.obs;
  PageController pageController = PageController();
  RxInt selectedIndex = 0.obs;
  RxString testString = "kkkk".obs;

  TextEditingController senderNameController = TextEditingController();

  List<Map<String, String>>  quickOptions =[
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
}
