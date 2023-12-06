import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/image_response.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  Logger logger = Logger('ProfileController');
  ProfileController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
  }

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  RxBool isLoading = false.obs;
  Rx<String> exampleText = "example".obs;
  Rx<String> pickedImagePath = ''.obs;

  onPageChanged(int index) {}
  @override
  void onInit() {
    super.onInit();
  }

  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void goBack() => routeService.goBack();
  // void routeToSignUp() => routeService.gotoRoute(AppLinks.signUp);

  void openCamera() async {
     ImageResponse response = await imageService.pickImage(source: ImageSource.camera);
     pickedImagePath.value = response.imagePath;
     logger.log("image path :: ${pickedImagePath.value}");
  }

  void openGallery() async {
    ImageResponse response =
        await imageService.pickImage(source: ImageSource.gallery);
    pickedImagePath.value = response.imagePath;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
