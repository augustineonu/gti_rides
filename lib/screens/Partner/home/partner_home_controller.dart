import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/Partner/partner_landing_controller.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/token_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

import '../../../services/route_service.dart';

class PartnerHomeController extends GetxController
    with StateMixin<List<dynamic>> {
  Logger logger = Logger('PartnerHomeController');
  late Timer timer;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;
  // RxList<dynamic>? cars = <dynamic>[].obs;

  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  RxBool isFetchingCars = false.obs;
  Rx<String> exampleText = "example".obs;
  late PageController cardPageController;
  ScrollController scrollController = ScrollController();

  TextEditingController emailOrPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // PartnerLandingController landingController =
      // Get.put<PartnerLandingController>(PartnerLandingController());
      final landingController = PartnerLandingController();

  final cars = <dynamic>[].obs;

  PartnerHomeController() {
    init();
  }

  void init() async {
    logger.log('Controller initialized');
    await getAllCars();
  }

  onPageChanged(int index) {}
  @override
  void onInit() {
    super.onInit();

    cardPageController = PageController(initialPage: 0);

    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentIndex.value < 4) {
        currentIndex.value++;
      } else {
        currentIndex.value = 0;
      }

      if (scrollController.hasClients) {
        cardPageController.animateToPage(
          currentIndex.value,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void routeToSignUp() => routeService.gotoRoute(AppLinks.signUp);
  void routeToLandingPage() =>
      routeService.gotoRoute(AppLinks.carRenterLanding);
  void routeToSearchCity() => routeService.gotoRoute(AppLinks.searchCity);
  void routeToCarRenterLanding() =>
      routeService.gotoRoute(AppLinks.carRenterLanding);
  void routeTolistVehicle() => routeService.gotoRoute(AppLinks.listVehicle);
  void routeToManageVehicle() => routeService.gotoRoute(AppLinks.manageVehicle);
  void routeToCarHistory({Object? arguments}) =>
      routeService.gotoRoute(AppLinks.carHistory, arguments: arguments);

  void launchWebsite() => openUrl(AppStrings.websiteUrl);

  Future<void> switchProfileToRenter() async {
    isLoading.value = true;
    try {
      final result =
          await renterService.switchProfile(payload: {"userType": "renter"});

      if (result.status == "success" || result.status_code == 200) {
        await showSuccessSnackbar(message: result.message!);
        logger.log("success message::: ${result.message}");
        userService.user.value.userType = "renter";

        await tokenService
            .getNewAccessToken()
            .then(
                (value) => routeService.offAllNamed(AppLinks.carRenterLanding))
            .onError((error, stackTrace) async {
          logger.log("Error switching user");
          return showErrorSnackbar(message: "Error switching user");
        });
        // Future.delayed(Duration(seconds: 3));
        // await ;
      } else {
        await showErrorSnackbar(message: result.message!);
      }
    } catch (e) {
      logger.log("error rrr: $e");
      showErrorSnackbar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllCars() async {
    isFetchingCars.value = true;
    change(<dynamic>[].obs, status: RxStatus.loading());
    try {
      final response = await partnerService.getCars(queryType: 'all');
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten cars ${response.data}");

        if (response.data == null || response.data!.isEmpty) {
          // If the list is empty
          change(<dynamic>[].obs, status: RxStatus.empty());
          [] = response.data!;
          logger.log("cars $cars");
        } else {
          // If the list is not empty
          change(response.data!, status: RxStatus.success());
          cars.value = response.data!;
          update();
        }

        // isFetchingCars.value = false;
      } else {
        logger.log("unable to get cars ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
      change(<dynamic>[].obs, status: RxStatus.error(exception.toString()));
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    timer.cancel(); // Cancel the timer when the controller is disposed.
    super.onClose();
  }
}
