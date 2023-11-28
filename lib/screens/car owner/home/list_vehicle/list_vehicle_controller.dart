import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';


class ListVehicleController extends GetxController {
  Logger logger = Logger("Controller");
  RxBool isLoading = false.obs;
  PageController pageController = PageController();
  RxInt currentIndex = 0.obs;
  RxString phoneCode = '1'.obs;
  RxString flagEmoji = '🇺🇸'.obs;

  TextEditingController senderNameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController pickupAddressController = TextEditingController();
  TextEditingController pickupAddressNumberController = TextEditingController();
  TextEditingController pickupLandarkController = TextEditingController();
  TextEditingController receiverNameController = TextEditingController();
  TextEditingController receiverPhoneController = TextEditingController();
  TextEditingController receiverEmailController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController destinationNumberController = TextEditingController();
  TextEditingController destinationLandmarkController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController kilogramController = TextEditingController();

  ListVehicleController() {
    init();
  }

  void init() {
    logger.log("ListVehicleController Initialized");
  }

  @override
  void onInit() async {
    pageController.addListener(() {
      currentIndex.value = pageController.page?.round() ?? 0;
      update();
    });
    super.onInit();
  }


// routing methods
  void goBack() => routeService.goBack();

}
