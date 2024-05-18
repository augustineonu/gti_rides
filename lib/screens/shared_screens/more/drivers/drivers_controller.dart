import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/models/image_response.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/Partner/home/list_vehicle/list_vehicle_controller.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:dio/dio.dart' as dio;
import 'package:gti_rides/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class DriversController extends GetxController with StateMixin<List<dynamic>> {
  Logger logger = Logger('DriversController');
  final listVehicleController = Get.put(ListVehicleController());
  DriversController() {
    init();
  }

  void init() async {
    logger.log('Controller initialized');

    await getDrivers();
  }

  @override
  onInit() async {
    super.onInit();

    Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null) {
      licenceExpiryDateController =
          TextEditingController(text: selectedExpiryDate.value);
    }
  }

  RxList<dynamic>? drivers = <dynamic>[].obs;

  GlobalKey<FormState> createDriverFormKey = GlobalKey<FormState>();

  // late Timer timer;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isFetchingDrivers = false.obs;

  // late PageController cardPageController;
  ScrollController scrollController = ScrollController();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController licenceNoController = TextEditingController();
  TextEditingController licenceExpiryDateController = TextEditingController();

  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  Rx<String> exampleText = "".obs;
  Rx<String> pickedImagePath = "".obs;
  Rx<String> pickedImageBackPath = "".obs;
  Rx<String> pickedImageName = "".obs;
  Rx<String> pickedImageBackName = "".obs;
  Rx<String> startDateTime = "".obs;
  Rx<String> endDateTime = "".obs;
  Rx<String> selectedExpiryDate = "".obs;

  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void goBack() => routeService.goBack();
  void goBack1() => routeService.goBack(closeOverlays: true);
  void routeToAddDriver() => routeService.gotoRoute(AppLinks.addDriver);
  void routeToEditDriver({Object? arguments}) =>
      routeService.gotoRoute(AppLinks.editDriver, arguments: arguments);
  void routeToHome() => routeService.gotoRoute(AppLinks.carOwnerLanding);

  bool validateImageUpload() {
    if (pickedImagePath.value.isEmpty) {
      // Show an error message or handle it accordingly
      showErrorSnackbar(message: 'Please upload an image.');
      return false;
    }
    return true;
  }

  bool validateText() {
    if (selectedExpiryDate.value.isEmpty) {
      // Show an error message or handle it accordingly
      showErrorSnackbar(message: 'License expiry date is required');
      return false;
    }
    return true;
  }

  Future<void> openCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      // Check if frontPagePath is not null before accessing its value
      pickedImageName.value = response.imagePath.split('/').last;
      pickedImagePath.value = response.imagePath;
      logger.log("image path :: ${pickedImagePath.value}");
      // Extract the directory and file name
      int lastSeparator = pickedImagePath.value.lastIndexOf('/');
      String directory = lastSeparator != -1
          ? pickedImagePath.value.substring(0, lastSeparator)
          : pickedImagePath.value;
      pickedImageName.value = 'licenceFront.png';

      // Build the new path with the desired file name
      String newPath = '$directory/$pickedImageName';
      logger.log("Picked new path $newPath");

      // Rename the file
      File(pickedImagePath.value).renameSync(newPath);

      // Now update the selectedPhotos value
      pickedImagePath.value = newPath;
    }
  }

  Future<void> openCameraBackPage() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      // Check if frontPagePath is not null before accessing its value
      pickedImageBackPath.value = response.imagePath;
      pickedImageBackName.value = response.imagePath.split('/').last;
      logger.log("image path :: ${pickedImageBackPath.value}");
      // Extract the directory and file name
      int lastSeparator = pickedImageBackPath.value.lastIndexOf('/');
      String directory = lastSeparator != -1
          ? pickedImageBackPath.value.substring(0, lastSeparator)
          : pickedImageBackPath.value;
      pickedImageBackName.value = 'licenceBack.png';

      // Build the new path with the desired file name
      String newPath = '$directory/$pickedImageBackName';
      logger.log("Picked new path $newPath");

      // Rename the file
      File(pickedImageBackPath.value).renameSync(newPath);

      // Now update the selectedPhotos value
      pickedImageBackPath.value = newPath;
    }
  }

  Future<void> openGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      logger.log("imagePath $pickedImagePath");
      pickedImagePath.value = response.imagePath;
      pickedImageName.value = response.imagePath.split('/').last;
    }
  }

  Future<void> openGalleryBackPage() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      logger.log("imagePath $pickedImageBackPath");
      pickedImageBackPath.value = response.imagePath;
      pickedImageBackName.value = response.imagePath.split('/').last;
    }
  }

  Future<void> createDriver() async {
    if (!createDriverFormKey.currentState!.validate() ||
        !validateImageUpload() ||
        !validateText()) {
      return;
    }
    try {
      isLoading.value = true;
      var data = dio.FormData();
      Future<dio.FormData> constructFormData() async {
        var formData = dio.FormData.fromMap({});

        // Check if fullName is not empty before adding it to formData
        if (fullNameController.text.isNotEmpty &&
            phoneNoController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            licenceNoController.text.isNotEmpty &&
            licenceExpiryDateController.text.isNotEmpty) {
          // formData.fields.add(MapEntry('fullName', fullNameController.text));
          // formData.fields.add(MapEntry('driverNumber', phoneNoController.text));
          // formData.fields.add(MapEntry('driverEmail', emailController.text));
          // formData.fields
          //     .add(MapEntry('licenseNumber', licenceNoController.text));
          // formData.fields
          //     .add(MapEntry('expireDate', licenceExpiryDateController.text));
          data = dio.FormData.fromMap({
            'files': [
              await dio.MultipartFile.fromFile(pickedImagePath.value,
                  filename: pickedImagePath.value)
            ],
            'fullName': fullNameController.text,
            'driverNumber': phoneNoController.text,
            'driverEmail': emailController.text,
            'licenseNumber': licenceNoController.text,
            'licenceExpireDate': licenceExpiryDateController.text
          });
        }
        // Check if imagePath is not empty before adding the image file to formData
        // if (pickedImagePath.value.isNotEmpty) {
        //   // formData.
        //   formData.fields.add(MapEntry(
        //     'licenseUpload',
        //     await dio.MultipartFile.fromFile(
        //       pickedImagePath.value,
        //       filename: pickedImagePath.value,
        //     ).toString(),
        //   ));
        // }
        logger.log("form field ${data.length}");
        return data;
      }

      final newFormData = {
        'fullName': fullNameController.text,
        'driverNumber': phoneNoController.text,
        'driverEmail': emailController.text,
        'licenseNumber': licenceNoController.text,
        'licenceExpireDate': selectedExpiryDate.value,
        'files': [
          pickedImagePath.value,
          pickedImageBackPath.value
          // await dio.MultipartFile.fromFile(
          //   pickedImagePath.value,
          //   // contentType: MediaType(
          //   //   mimeTypeData[0],
          //   //   mimeTypeData[1],
          //   // ),
          // ),
          // await dio.MultipartFile.fromFile(
          //   pickedImageBackPath.value,
          //   // contentType: MediaType(
          //   //   backPageMimeTypeData[0],
          //   //   backPageMimeTypeData[1],
          //   // ),
          // ),
        ],
      };

      // logger.log("values: $newFormData");
      // isLoading.value = false;
      // return;

      final formData = await constructFormData();
      final response = await partnerService.addDriver(payload: newFormData);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("driver created ${response.message}");
        await listVehicleController.getDrivers();
        await getDrivers();

        successDialog(
            title: AppStrings.driverAddedMessage,
            body: AppStrings.thankYouForAddingDriver,
            buttonTitle: AppStrings.cont,
            onTap: goBack1);
        // if (response.data != null) {
        //   // drivers = response.data!;
        //   // logger.log("drivers $drivers");
        // }
      } else {
        logger.log("unable to get drivers ${response.data}");
        showErrorSnackbar(message: response.message!);
        isLoading.value = false;
      }
    } catch (exception) {
      logger.log("error  $exception");
      showErrorSnackbar(message: exception.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getDrivers() async {
    isFetchingDrivers.value = true;
    change([].obs, status: RxStatus.loading());

    try {
      final response = await partnerService.getDrivers();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten drivers ${response.data}");
        // await Future.delayed(Duration(days: 1));
        if (response.data != null) {
          drivers?.value = response.data! as dynamic;
          change(response.data as dynamic, status: RxStatus.success());
          logger.log("drivers $drivers");
        } else {
          change([].obs, status: RxStatus.empty());
        }
        isFetchingDrivers.value = false;
      } else {
        logger.log("unable to get drivers ${response.data}");
        change(
          [].obs,
          status: RxStatus.error(response.message ?? 'An error occured'),
        );
      }
    } catch (exception) {
      change(
        [].obs,
        status: RxStatus.error(exception.toString()),
      );
      logger.log("error  $exception");
    }
  }

  @override
  void dispose() {
    // timer.cancel();
    fullNameController.dispose();
    emailController.dispose();
    phoneNoController.dispose();

    super.dispose();
  }

  @override
  void onClose() {
    // timer.cancel(); // Cancel the timer when the controller is disposed.
    super.onClose();
    fullNameController.clear();
    emailController.clear();
    phoneNoController.clear();
    licenceNoController.clear();

    licenceExpiryDateController.text = selectedExpiryDate.value;
  }
}
