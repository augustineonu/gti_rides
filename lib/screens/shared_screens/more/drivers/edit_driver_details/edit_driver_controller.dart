import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/models/image_response.dart';
import 'package:gti_rides/route/app_links.dart';
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

class EditDriversController extends GetxController {
  Logger logger = Logger('EditDriversController');
  EditDriversController() {
    init();
  }

  void init() async{
    logger.log('Controller initialized');

    await getDrivers();

      Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null) {
      driverEmail.value = arguments['driverEmail'] ?? '';
      driverNumber.value = arguments['driverNumber'] ?? '';
      fullName.value = arguments['fullName'] ?? '';
      fullName.value = arguments['fullName'] ?? '';
      driverID.value = arguments['driverID'] ?? '';

      // Now you have access to the passed data (emailOrPhone)
      logger.log('Received email or phone: $arguments');
    }
    fullNameController.text = fullName.value;
    phoneNoController.text = driverNumber.value;
    emailController.text = driverEmail.value;
  }

  RxList<dynamic>? drivers = <dynamic>[].obs;

  GlobalKey<FormState> createDriverFormKey = GlobalKey<FormState>();

  // late Timer timer;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;

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
  Rx<String> pickedImageName = "".obs;
    Rx<String> driverEmail = ''.obs;
  Rx<String> driverNumber = ''.obs;
  Rx<String> fullName = ''.obs;
  Rx<String> driverID = ''.obs;

  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void goBack() => routeService.goBack();
  void goBack1() => routeService.goBack(closeOverlays: true);
  void routeToAddDriver() => routeService.gotoRoute(AppLinks.addDriver);
  void routeToAddDriver1({Object? arguments}) => routeService.gotoRoute(AppLinks.addDriver,
 arguments: arguments
  );
  void routeToHome() => routeService.gotoRoute(AppLinks.carOwnerLanding);

  bool validateImageUpload() {
    if (pickedImagePath.value.isEmpty) {
      // Show an error message or handle it accordingly
      showErrorSnackbar(message: 'Please upload an image.');
      return false;
    }
    return true;
  }

  Future<void> openCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      // Check if frontPagePath is not null before accessing its value
      pickedImagePath.value = response.imagePath;
      pickedImageName.value = response.imagePath.split('/').last;
      logger.log("image path :: ${pickedImagePath.value}");
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

  Future<void> createDriver() async {
    if (!createDriverFormKey.currentState!.validate() ||
        !validateImageUpload()) {
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
            'licenseUpload': [
              await dio.MultipartFile.fromFile(pickedImagePath.value,
                  filename: pickedImagePath.value)
            ],
            // 'fullName': fullNameController.text,
            // 'driverNumber': phoneNoController.text,
            // 'driverEmail': emailController.text,
            'licenseNumber': licenceNoController.text,
            'expireDate': licenceExpiryDateController.text
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

      final formData = await constructFormData();
      final response = await partnerService.updateLicensePhoto(payload: formData,
      driverID: driverID.value);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("driver profile updated ${response.message!}");
        showSuccessSnackbar(message: response.message!);
        Future.delayed(const Duration(seconds: 2)).then((value) => 
         routeService.goBack(closeOverlays: true));

      } else {
        logger.log("unable to update drivers ${response.data}");
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
    try {
      final response = await partnerService.getDrivers();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten drivers ${response.data}");
        if (response.data != null) {
          drivers?.value = response.data! as dynamic;
          logger.log("drivers $drivers");
        }
      } else {
        logger.log("unable to get drivers ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
    }
  }

  

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    // timer.cancel(); // Cancel the timer when the controller is disposed.
    super.onClose();
  }
}
