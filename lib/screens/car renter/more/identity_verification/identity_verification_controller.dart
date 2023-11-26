import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';

enum IdType { nationalId, passport, driverLicense }


class IdentityVerificationController extends GetxController {
  Logger logger = Logger("Controller");

  IdentityVerificationController() {
    init();
  }

  void init() {
    logger.log("IdentityVerificationController Initialized");
  }

  @override
  void onInit() async {
    update();

    super.onInit();
  }
  
  PageController pageController = PageController();
  TextEditingController homeAddressController = TextEditingController();
  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;
  // RxBool selectedIdType = false.obs;
  RxBool selectedNationalID = false.obs;
  RxBool selectedPassport = false.obs;
  RxBool selectedDriversLicense = false.obs;

  Rx<String> testString = 'hello world'.obs;

  void goBack() => routeService.goBack();
  void routeToPaymentSummary() =>
      routeService.gotoRoute(AppLinks.paymentSummary);
  void routeToProofOfIdentity() =>
      routeService.gotoRoute(AppLinks.proofOfIdentity);
  void routeToHomeAddress() =>
      routeService.gotoRoute(AppLinks.homeAddress);
  void routeToOfficeAddress() =>
      routeService.gotoRoute(AppLinks.officeAddress);
  void routeToOccupation() =>
      routeService.gotoRoute(AppLinks.occupation);
  void routeToEmergencyContactn() =>
      routeService.gotoRoute(AppLinks.emergencyContact);

      // void onSelectIdType() => selectedIdType.value = !selectedIdType.value;

      Rx<IdType> selectedIdType = IdType.nationalId.obs;

void onSelectIdType(IdType idType) {
  selectedIdType.value = idType;
}

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

  void onClickPrevious() {
    if (currentIndex > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
