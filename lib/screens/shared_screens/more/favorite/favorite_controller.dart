import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/favorite_cars_model.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class FavoriteController extends GetxController
    with StateMixin<List<FavoriteCarData>> {
  Logger logger = Logger('FavoritesController');
  FavoriteController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');

    getFavoriteCars();
  }

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  RxBool isLoading = false.obs;
  RxBool isDeletingFavCar = false.obs;
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

  Future<void> getFavoriteCars() async {
    change(<FavoriteCarData>[].obs, status: RxStatus.loading());
    try {
      final response = await renterService.getFavoriteCars();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten favorite cars ${response.data}");

        if (response.data == null || response.data!.isEmpty) {
          // If the list is empty
          change(<FavoriteCarData>[].obs, status: RxStatus.empty());
          [] = response.data!;
          // logger.log("cars $cars");
        } else {
          // If the list is not empty
          List<FavoriteCarData> favoriteCar = List<FavoriteCarData>.from(
            response.data!.map((car) => FavoriteCarData.fromJson(car)),
          );

          logger.log("recnt:: ${favoriteCar[0].percentageRate.toString()}");

          change(favoriteCar, status: RxStatus.success());
          update();
        }
      } else {
        logger.log("unable to get favorite cars ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
      change(<FavoriteCarData>[].obs,
          status: RxStatus.error(exception.toString()));
    }
  }

  Future<void> deleteFavoriteCar({required String carId}) async {
    isDeletingFavCar.value = true;
    try {
      final response = await renterService.deleteFavoriteCar(carId: carId);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("Car deleted from favorites:: ${response}");
        showSuccessSnackbar(message: response.message ?? '');
        await getFavoriteCars();
        Future.delayed(Duration(seconds: 2))
            .then((value) => Get.back(closeOverlays: true));
        // Get.back(closeOverlays: true);
      } else {
        logger.log("Unable to delete car from favorites:: ${response}");
        showErrorSnackbar(message: response.message ?? '');
      }
    } catch (exception) {
      logger.log("error:: ${exception.toString()}");
    } finally {
      isDeletingFavCar.value = false;
    }
  }
}
