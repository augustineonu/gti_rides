import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:image_picker/image_picker.dart';

class FavoriteController extends GetxController {
  Logger logger = Logger('FavoritesController');
  FavoriteController() {
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

  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void goBack() => routeService.goBack();
  // void routeToSignUp() => routeService.gotoRoute(AppLinks.signUp);

  void openCamera() {
    final picked = imageService.pickImage(source: ImageSource.camera);
  }

  void openGallery() {
    imageService.pickImage(source: ImageSource.gallery);
  }
}
