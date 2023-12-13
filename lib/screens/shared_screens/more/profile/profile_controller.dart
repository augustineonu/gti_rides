import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/image_response.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  Logger logger = Logger('ProfileController');
   Rx<UserModel>  user = UserModel().obs;

  ProfileController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');

    logger.log("User:: $user");
  }

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  RxBool isLoading = false.obs;
  Rx<String> exampleText = "example".obs;
  Rx<String> pickedImagePath = ''.obs;

  onPageChanged(int index) {}
  @override
  void onInit() {
    super.onInit();

    user = userService.user;
  }

  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void goBack() => routeService.goBack();
  // void routeToSignUp() => routeService.gotoRoute(AppLinks.signUp);

  void openCamera() async {
    ImageResponse response =
        await imageService.pickImage(source: ImageSource.camera);
    pickedImagePath.value = response.imagePath;
    logger.log("image path :: ${pickedImagePath.value}");
  }

  void openGallery() async {
    ImageResponse response =
        await imageService.pickImage(source: ImageSource.gallery);
    pickedImagePath.value = response.imagePath;
  }

  Future<void> updateProfile() async {
    if (!updateFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final result = await userService.updateProfile(
        payload: {
          "fullName": fullNameController.text,
          "emailAddress": emailController.text,
          "phoneNumber": "12345678902",
          // "imagePath": pickedImagePath.value,
        });
        if (result.status == "success" || result.status_code == 200) {
          await showSuccessSnackbar(message: result.message!);
        } else {
          await showErrorSnackbar(message: result.message!);
           routeService.goBack;
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
    super.dispose();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
