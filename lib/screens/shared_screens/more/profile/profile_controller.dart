import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/image_response.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/token_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

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
  String pickedImagePath1 = '';

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
      pickedImagePath1 = response.imagePath;
      logger.log("image path :: ${pickedImagePath.value}");
      pickedImagePath1 = response.imagePath;
      logger.log("image path 1 :: ${pickedImagePath1}");
    }
  }

  void openGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      logger.log("Picked image $pickedImagePath");
      pickedImagePath.value = response.imagePath;
    }
  }

  Future<void> updateProfile1() async {
    if (!updateFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    var header = {
      'Authorization': 'Bearer ${tokenService.accessToken.value}',
      "Accept": "*/*",
      'Content-Type': 'multipart/form-data'
    };
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(
          'https://squid-app-9sdyd.ondigitalocean.app/user/profile/editProfile'),
    );
    String fileName = pickedImagePath.split('/').last;
    final mimeTypeData =
        lookupMimeType(pickedImagePath.value, headerBytes: [0xFF, 0xD8])!
            .split('/');

    request.fields.addAll({
      'fullName': fullNameController.text,
    });
    request.files.add(await http.MultipartFile.fromPath(
        'profilePic', pickedImagePath.value,
        filename: fileName,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
    request.headers.addAll(header);

    try {
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      logger.log("response: ${responseBody}");
      logger.log("response: ${response.statusCode}");

      // final result = await userService.updateProfile(payload: formData);

      // if (result.status == "success" || result.status_code == 200) {
      //   await showSuccessSnackbar(message: result.message!);
      //   final response = await authService.getProfile();
      //   if (response.status == "success" || response.status_code == 200) {
      //     logger.log("refresh user details ${response.data.toString()}");
      //     final UserModel userModel = UserModel.fromJson(response.data?[0]);
      //     userService.setCurrentUser(userModel.toJson());
      //     routeService.goBack;
      //   }
      //   // routeService.offAllNamed(AppLinks.more);
      //   routeService.goBack;
      // } else {
      //   logger.log("error updating user: ${result.message}");
      //   await showErrorSnackbar(message: result.message!);
      //   routeService.goBack;
      // }
    } catch (e) {
      logger.log("error rrr: $e");
      showErrorSnackbar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    if (!updateFormKey.currentState!.validate()) {
      return;
    }
    dio.Dio dioCall = dio.Dio();

    isLoading.value = true;

    try {
      final mimeTypeData =
          lookupMimeType(pickedImagePath.value, headerBytes: [0xFF, 0xD8])!
              .split('/');
      String fileName = pickedImagePath.split('/').last;

      var formData = dio.FormData.fromMap({
        'fullName': fullNameController.text,
        'profilePic': await dio.MultipartFile.fromFile(pickedImagePath.value,
            filename: fileName,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]))
      });

      logger.log("PATCH REQUEST DATA:: ${formData.fields.toString()}");
      logger.log("PATCH REQUEST DATA:: ${formData.files.toString()}");

      final response = await dioCall.put(
          'https://squid-app-9sdyd.ondigitalocean.app/user/profile/editProfile',
          data: formData,
          options: dio.Options(
            method: 'PUT',
            headers: {
              'Authorization': 'Bearer ${tokenService.accessToken.value}',
              "Accept": "*/*",
              'Content-Type': 'multipart/form-data'
            },
          ));

      logger.log("response: ${response.data}");
      logger.log("response: ${response.statusCode}");

      // final result = await userService.updateProfile(payload: formData);

      // if (result.status == "success" || result.status_code == 200) {
      //   await showSuccessSnackbar(message: result.message!);
      //   final response = await authService.getProfile();
      //   if (response.status == "success" || response.status_code == 200) {
      //     logger.log("refresh user details ${response.data.toString()}");
      //     final UserModel userModel = UserModel.fromJson(response.data?[0]);
      //     userService.setCurrentUser(userModel.toJson());
      //     routeService.goBack;
      //   }
      //   // routeService.offAllNamed(AppLinks.more);
      //   routeService.goBack;
      // } else {
      //   logger.log("error updating user: ${result.message}");
      //   await showErrorSnackbar(message: result.message!);
      //   routeService.goBack;
      // }
    } catch (e) {
      logger.log("error rrr: $e");
      showErrorSnackbar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile2() async {
    if (!updateFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    final mimeTypeData =
        lookupMimeType(pickedImagePath.value, headerBytes: [0xFF, 0xD8])!
            .split('/');
    String fileName = pickedImagePath.split('/').last;

    try {
      Future<dio.FormData> constructFormData() async {
        var formData = dio.FormData.fromMap({});

        // Check if imagePath is not empty before adding the image file to formData
        if (pickedImagePath.value.isNotEmpty) {
          // formData.
          formData = dio.FormData.fromMap({
            'fullName': fullNameController.text,
            'profilePic': await dio.MultipartFile.fromFile(
                pickedImagePath.value,
                filename: fileName,
                contentType: MediaType(mimeTypeData[0], mimeTypeData[1]))
          });
        } else {
          formData = dio.FormData.fromMap({
            'fullName': fullNameController.text,
          });
        }
        logger.log("form field ${formData.length}");
        return formData;
      }

      final formData = await constructFormData();
      logger.log("PATCH REQUEST DATA:: ${formData.fields.toString()}");
      logger.log("PATCH REQUEST DATA:: ${formData.files.toString()}");
      final result = await userService.updateProfile(payload: formData);

      if (result.status == "success" || result.status_code == 200) {
        final response = await authService.getProfile();
        if (response.status == "success" || response.status_code == 200) {
          logger.log("refresh user details ${response.data.toString()}");
          final UserModel userModel = UserModel.fromJson(response.data?[0]);
          userService.setCurrentUser(userModel.toJson());
        }
        await showSuccessSnackbar(message: result.message!);
        Future.delayed(Duration(seconds: 3))
            .then((value) => routeService.goBack(closeOverlays: true));
        // routeService.offAllNamed(AppLinks.more);
        // routeService.goBack;
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

  Future<void> updateCar() async {
    final data = dio.FormData.fromMap({
      'files': [
        await dio.MultipartFile.fromFile(pickedImagePath1,
            filename: pickedImagePath1)
      ],
      'fullName': 'John Maduka'
    });

    final result =
        await partnerService.addCarPhoto(payload: data, carID: 'NVhdexYY6r');
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
