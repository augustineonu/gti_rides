import 'dart:io';

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
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

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
  TextEditingController expiryDateController = TextEditingController();
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
  Rx<String> selectedExpiryDate = "".obs;

  // list
  List<String> gender = [
    AppStrings.male,
    AppStrings.female,
  ];

  void goBack() => routeService.goBack();
  void routeToPaymentSummary() =>
      routeService.gotoRoute(AppLinks.paymentSummary);

  Future<void> openCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      backPagePath.value = response.imagePath;
      backImageName.value = response.imagePath.split('/').last;
      logger.log("image path :: ${backPagePath.value}");

      // Extract the directory and file name
      int lastSeparator = backPagePath.value.lastIndexOf('/');
      String directory = lastSeparator != -1
          ? backPagePath.value.substring(0, lastSeparator)
          : backPagePath.value;
      backImageName.value = 'licenceBack.png';

      // Build the new path with the desired file name
      String newPath = '$directory/$backImageName';
      logger.log("Picked new path $newPath");

      // Rename the file
      File(backPagePath.value).renameSync(newPath);

      // Now update the selectedPhotos value
      backPagePath.value = newPath;
      logger.log("selected photo ${backPagePath.value}");
      routeService.goBack;
    }
  }

  Future<void> openFrontCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      // Check if frontPagePath is not null before accessing its value
      frontPagePath.value = response.imagePath;
      frontImageName.value = response.imagePath.split('/').last;
      logger.log("image path :: ${frontPagePath.value}");
      // Extract the directory and file name
      int lastSeparator = frontPagePath.value.lastIndexOf('/');
      String directory = lastSeparator != -1
          ? frontPagePath.value.substring(0, lastSeparator)
          : frontPagePath.value;
      frontImageName.value = 'licenceFront.png';

      // Build the new path with the desired file name
      String newPath = '$directory/$frontImageName';
      logger.log("Picked new path $newPath");

      // Rename the file
      File(frontPagePath.value).renameSync(newPath);

      // Now update the selectedPhotos value
      frontPagePath.value = newPath;
      logger.log("selected photo ${frontPagePath.value}");
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

  Future<void> openFrontGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      logger.log("imagePath $frontPagePath");
      frontPagePath.value = response.imagePath;
      frontImageName.value = response.imagePath.split('/').last;

      // Extract the directory and file name
      int lastSeparator = frontPagePath.value.lastIndexOf('/');
      String directory = lastSeparator != -1
          ? frontPagePath.value.substring(0, lastSeparator)
          : frontPagePath.value;

      frontImageName.value = 'licenceFront.png';

      // Build the new path with the desired file name
      String newPath = '$directory/$frontImageName';
      logger.log("Picked new path $newPath");

      // Rename the file
      File(frontPagePath.value).renameSync(newPath);

      // Now update the selectedPhotos value
      frontPagePath.value = newPath;
      logger.log("selected photo ${frontPagePath.value}");
      routeService.goBack;
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

  // formData.fields.add(MapEntry(
  //   'homeAddressProof',
  //   await dio.MultipartFile.fromFile(
  //     frontPagePath.value,
  //     filename: frontPagePath.value,
  //   ).toString(),
  // ));

  Future<void> updateKyc() async {
    if (!updateFormKey.currentState!.validate() || !validateImageUpload()) {
      return;
    }

    isLoading.value = true;
    final mimeTypeData =
        lookupMimeType(frontPagePath.value, headerBytes: [0xFF, 0xD8])!
            .split('/');
    String fileName = frontPagePath.split('/').last;

    try {
      Future<dio.FormData> constructFormData() async {
        var formData = dio.FormData.fromMap({});

        if (frontPagePath.isNotEmpty) {
          formData = dio.FormData.fromMap({
            'homeAddress': homeAddressController.text,
            'kycDocuments': await dio.MultipartFile.fromFile(
                frontPagePath.value,
                filename: fileName,
                contentType: MediaType(mimeTypeData[0], mimeTypeData[1]))
          });
        }

        return formData;
      }

      final formData = await constructFormData();
      logger.log("PATCH REQUEST DATA:: ${formData.fields.toString()}");
      logger.log("PATCH REQUEST DATA:: ${formData.files.toString()}");

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
    final mimeTypeData =
        lookupMimeType(frontPagePath.value, headerBytes: [0xFF, 0xD8])!
            .split('/');
    final roadMimeTypeData =
        lookupMimeType(backPagePath.value, headerBytes: [0xFF, 0xD8])!
            .split('/');

    try {
      var newFormData = dio.FormData.fromMap({
        "licenceNumber": licenseNoController.text,
        "licenceExpireDate": expiryDateController.text,
        "kycDocuments": [
          await dio.MultipartFile.fromFile(
            frontPagePath.value,
            contentType: MediaType(
              mimeTypeData[0],
              mimeTypeData[1],
            ),
          ),
          await dio.MultipartFile.fromFile(
            backPagePath.value,
            contentType: MediaType(
              mimeTypeData[0],
              mimeTypeData[1],
            ),
          ),
        ]
      });

      Future<dio.FormData> constructFormData() async {
        var formData = dio.FormData.fromMap({});

        if (licenseNoController.text.isNotEmpty &&
            expiryDateController.text.isNotEmpty &&
            frontPagePath.isNotEmpty) {
          formData.fields
              .add(MapEntry('drivingLicenceNumber', licenseNoController.text));
          formData.fields.add(
              MapEntry('drivingLicenceExpireDate', expiryDateController.text));
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
      final result = await userService.updateKyc(payload: newFormData);

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

  @override
  void onClose() {
    // timer.cancel(); // Cancel the timer when the controller is disposed.
    super.onClose();
    expiryDateController.text = selectedExpiryDate.value;
  }
}
