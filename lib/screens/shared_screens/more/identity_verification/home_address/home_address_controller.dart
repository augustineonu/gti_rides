import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/image_response.dart';
import 'package:gti_rides/models/list_response_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';

enum IdType { nationalId, passport, driverLicense }

class HomeAddressController extends GetxController {
  Logger logger = Logger("Controller");

  Rx<UserModel> user = UserModel().obs;
  Rx<ListResponseModel> userKyc = ListResponseModel().obs;

  GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  HomeAddressController() {
    init();
  }

  void init() async {
    logger.log("HomeAddressController Initialized");
    // await getBiometricProfile();
    // user = userService.user;
    // logger.log("USER: ${user.value.toJson()}");

    // userKyc = userService.userKyc;
    // logger.log("USER Kyc Details: ${userKyc.value.toJson()}");
  }

  @override
  void onInit() async {
    update();

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  PageController pageController = PageController();
  TextEditingController homeAddressController = TextEditingController();
  TextEditingController licenseNoController = TextEditingController();
  TextEditingController expireyDateController = TextEditingController();
  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isImageUploadRequired = false.obs;
  // RxBool selectedIdType = false.obs;
  RxBool selectedNationalID = false.obs;
  RxBool selectedPassport = false.obs;
  RxBool selectedDriversLicense = false.obs;
  Rx<String> frontImageName = ''.obs;
  Rx<String> backImageName = ''.obs;
  Rx<String> frontPagePath = ''.obs;
  Rx<String> backPagePath = ''.obs;

  // list
  List<String> gender = [
    AppStrings.male,
    AppStrings.female,
  ];

  void goBack() => routeService.goBack();
  void routeToPaymentSummary() =>
      routeService.gotoRoute(AppLinks.paymentSummary);

  void openCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      frontPagePath.value = response.imagePath;
      frontImageName.value = response.imagePath.split('/').last;
      logger.log("image path :: ${frontPagePath.value}");
    }
  }

  void openFrontCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      // Check if frontPagePath is not null before accessing its value
      frontPagePath.value = response.imagePath;
      frontImageName.value = response.imagePath.split('/').last;
      logger.log("image path :: ${frontPagePath.value}");
    }
  }

  void openGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      logger.log("imagePath $frontPagePath");
      backPagePath.value = response.imagePath;
      frontPagePath.value = response.imagePath;
      backImageName.value = response.imagePath.split('/').last;
      frontImageName.value = response.imagePath.split('/').last;
    }
  }

  void openFrontGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      logger.log("imagePath $frontPagePath");
      frontPagePath.value = response.imagePath;
      frontImageName.value = response.imagePath.split('/').last;
    }
  }

  Future<void> getBiometricProfile() async {
    try {
      final response = await userService.getKycProfile();

      if (response.status == "success" || response.status_code == 200) {
        logger.log("User KYC ${response.data.toString()}");
        // Check if the response data list is not empty
        if (response.data != null || response.data != []) {
          userKyc.value = response;
        }
      }
    } catch (e) {
      logger.log("error rrr: $e");
      showErrorSnackbar(message: e.toString());
    }
  }

  bool validateImageUpload() {
    if (frontPagePath.value.isEmpty) {
      // Show an error message or handle it accordingly
      showErrorSnackbar(message: 'Please upload an image.');
      return false;
    }
    return true;
  }

  bool validateIdentityUpload() {
    if (frontPagePath.value.isEmpty && backPagePath.value.isEmpty) {
      // Show an error message or handle it accordingly
      showErrorSnackbar(message: 'Please upload an image.');
      return false;
    }
    return true;
  }

  Future<void> updateKyc() async {
    if (!updateFormKey.currentState!.validate() || !validateImageUpload()) {
      return;
    }

    isLoading.value = true;

    try {
      Future<dio.FormData> constructFormData() async {
        var formData = dio.FormData.fromMap({});

        if (homeAddressController.text.isNotEmpty && frontPagePath.isNotEmpty) {
          formData.fields
              .add(MapEntry('homeAddress', homeAddressController.text));
          formData.fields.add(MapEntry(
            'homeAddressProof',
            await dio.MultipartFile.fromFile(
              frontPagePath.value,
              filename: frontPagePath.value,
            ).toString(),
          ));
        }

        return formData;
      }

      final formData = await constructFormData();
      final result = await userService.updateKyc(payload: formData);

      if (result.status == "success" || result.status_code == 200) {
        routeService.goBack;
        logger.log("update KYC response ${result.data}");
        await showSuccessSnackbar(message: result.message!);
        final response = await userService.getKycProfile();
        if (response.status == "success" || response.status_code == 200) {
          final ListResponseModel userModel =
              ListResponseModel.fromJson(response.data?[0]);
          // Check if the response data list is not empty
          if (response.data != null || response.data != []) {
            userKyc.value = userModel;
            userService.setUserKyc(response.toJson());
            userKyc.refresh();
            update();
          }
          routeService.goBack;
          Navigator.pop;
        }

        routeService.goBack;
      } else {
        logger.log("error updating user: ${result.message}");
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

  Future<void> updateIdentityCard() async {
    if (!updateFormKey.currentState!.validate() || !validateIdentityUpload()) {
      return;
    }

    isLoading.value = true;

    try {
      Future<dio.FormData> constructFormData() async {
        var formData = dio.FormData.fromMap({});

        if (licenseNoController.text.isNotEmpty &&
            expireyDateController.text.isNotEmpty &&
            frontPagePath.isNotEmpty) {
          formData.fields
              .add(MapEntry('drivingLicenceNumber', licenseNoController.text));
          formData.fields.add(
              MapEntry('drivingLicenceExpireDate', expireyDateController.text));
          formData.fields.add(MapEntry(
            'drivingLicenceFrontPage',
            await dio.MultipartFile.fromFile(
              frontPagePath.value,
              filename: frontPagePath.value,
            ).toString(),
          ));
          formData.fields.add(MapEntry(
            'drivingLicenceBackPage',
            await dio.MultipartFile.fromFile(
              backPagePath.value,
              filename: backPagePath.value,
            ).toString(),
          ));
        }

        return formData;
      }

      final formData = await constructFormData();
      final result = await userService.updateKyc(payload: formData);

      if (result.status == "success" || result.status_code == 200) {
        routeService.goBack;
        logger.log("update KYC response ${result.data}");
        await showSuccessSnackbar(message: result.message!);
        final response = await userService.getKycProfile();
        if (response.status == "success" || response.status_code == 200) {
          final ListResponseModel userModel =
              ListResponseModel.fromJson(response.data?[0]);
          // Check if the response data list is not empty
          if (response.data != null || response.data != []) {
            userKyc.value = userModel;
            userService.setUserKyc(response.toJson());
            userKyc.refresh();
            update();
          }
          routeService.goBack;
          Navigator.pop;
        }

        routeService.goBack;
      } else {
        logger.log("error updating user: ${result.message}");
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
}