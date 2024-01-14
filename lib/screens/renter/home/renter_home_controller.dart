// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/recently_viewed_car_model.dart';
import 'package:gti_rides/models/user_model.dart';

import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/token_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

import '../../../services/route_service.dart';

class CarRenterHomeController extends GetxController {
  Logger logger = Logger('CarRenterHomeController');
  Rx<UserModel> user = UserModel().obs;

  late Timer timer;
  RxInt currentIndex = 0.obs;

  RxBool isLoading = false.obs;
  RxBool isSwitchingProfile = false.obs;
  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  Rx<String> exampleText = "example".obs;
  late PageController cardPageController;
  ScrollController scrollController = ScrollController();

  TextEditingController emailOrPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  CarRenterHomeController() {
    init();
  }

  void init() {
    logger.log('CarRenterHomeController initialized');
    user = userService.user;

    logger.log("USER: ${user.value.toJson()}");
  }

  onPageChanged(int index) {}
  @override
  void onInit() {
    super.onInit();
    cardPageController = PageController(initialPage: 0);

    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentIndex.value < 2) {
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

  // variables

  final List<RecentlyViewCarModel> recentlyViewedCar = [
    RecentlyViewCarModel(
        imageUrl: 'assets/images/range.png',
        carModel: '2012 KIA Sportage',
        ratings: '78',
        trips: '25',
        pricePerDay: '250,000'),
    RecentlyViewCarModel(
        imageUrl: 'assets/images/range.png',
        carModel: '2015 Range',
        ratings: '83',
        trips: '14',
        pricePerDay: '350,000'),
    RecentlyViewCarModel(
        imageUrl: 'assets/images/range.png',
        carModel: '2018 Chevrolet',
        ratings: '60',
        trips: '16',
        pricePerDay: '270,000'),
  ];

  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void routeToSignUp() => routeService.gotoRoute(AppLinks.signUp);
  void routeToLandingPage() =>
      routeService.gotoRoute(AppLinks.carRenterLanding);
  void routeToSearchCity() => routeService.gotoRoute(AppLinks.searchCity);
  void routeToCarOwnerLanding() =>
      routeService.offAllNamed(AppLinks.carOwnerLanding);
  void routeToCarSelectionResult() =>
      routeService.gotoRoute(AppLinks.carSelectionResult);

void launchWebsite() => openUrl(AppStrings.websiteUrl);

  Future<void> switchProfileToOwner() async {
    isLoading.value = true;
    try {
      final result =
          await renterService.switchProfile(payload: {"userType": "partner"});

      if (result.status == "success" || result.status_code == 200) {
        await showSuccessSnackbar(message: result.message!);
        await tokenService.getNewAccessToken();
        await routeService.offAllNamed(AppLinks.carOwnerLanding);
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
