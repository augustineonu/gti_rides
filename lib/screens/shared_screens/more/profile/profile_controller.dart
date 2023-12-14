import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/image_response.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class ProfileController extends GetxController {
  Logger logger = Logger('ProfileController');
  Rx<UserModel> user = UserModel().obs;

  ProfileController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');

    logger.log("User:: $user");
  }

  TextEditingController fullNameController =
      TextEditingController(text: userService.user.value.fullName);
  TextEditingController emailController =
      TextEditingController(text: userService.user.value.emailAddress);
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
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      // Check if pickedImagePath is not null before accessing its value
      pickedImagePath.value = response.imagePath;
      logger.log("image path :: ${pickedImagePath.value}");
    }
  }

  void openGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      pickedImagePath.value = response.imagePath;
    }
  }

  Future<void> updateProfile() async {
    if (!updateFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      var formData = dio.FormData.fromMap({
        "fullName": fullNameController.text,
        'file': await dio.MultipartFile.fromFile(pickedImagePath!.value,
            filename: pickedImagePath!.value)
      });
      final result = await userService.updateProfile(payload: formData);

      if (result.status == "success" || result.status_code == 200) {
        await showSuccessSnackbar(message: result.message!);
        final response = await authService.getProfile();
        if (response.status == "success" || response.status_code == 200) {
          logger.log("refresh user details ${response.data.toString()}");
          final UserModel userModel = UserModel.fromJson(response.data[0]);
          userService.setCurrentUser(userModel.toJson());
        }
        routeService.offAllNamed(AppLinks.more);
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
