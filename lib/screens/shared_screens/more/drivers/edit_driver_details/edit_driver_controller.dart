import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/models/image_response.dart';
import 'package:gti_rides/models/user_driver.dart';
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
import 'package:path_provider/path_provider.dart';

class EditDriversController extends GetxController {
  Logger logger = Logger('EditDriversController');
  EditDriversController() {
    init();
  }

  void init() async {
    logger.log('Controller initialized');

    // await getDrivers();

    Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null) {
      driverEmail.value = arguments['driverEmail'] ?? '';
      driverNumber.value = arguments['driverNumber'] ?? '';
      fullName.value = arguments['fullName'] ?? '';
      fullName.value = arguments['fullName'] ?? '';
      driverID.value = arguments['driverID'] ?? '';

      await getOneDriver();

      // Now you have access to the passed data (emailOrPhone)
      logger.log('Received email or phone: $arguments');
    }
    fullNameController.text = fullName.value;
    phoneNoController.text = driverNumber.value;
    emailController.text = driverEmail.value;
  }

  RxList<UserDriverData>? drivers = <UserDriverData>[].obs;

  GlobalKey<FormState> createDriverFormKey = GlobalKey<FormState>();

  // late Timer timer;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool gettingDriverIfo = false.obs;

  // late PageController cardPageController;
  ScrollController scrollController = ScrollController();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController licenceNoController = TextEditingController();
  // TextEditingController licenceExpiryDateController = TextEditingController();

  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  Rx<String> exampleText = "".obs;
  Rx<String> pickedImagePath = "".obs;
  Rx<String> pickedImageName = "".obs;
  Rx<String> driverEmail = ''.obs;
  Rx<String> driverNumber = ''.obs;
  Rx<String> fullName = ''.obs;
  Rx<String> driverID = ''.obs;

  Rx<String> pickedImageBackPath = "".obs;
  Rx<String> pickedImageBackName = "".obs;
  Rx<String> selectedExpiryDate = "".obs;

  void obscurePassword() => showPassword.value = !showPassword.value;
  // update();

  // navigation method
  void goBack() => routeService.goBack();
  void goBack1() => routeService.goBack(closeOverlays: true);
  void routeToAddDriver() => routeService.gotoRoute(AppLinks.addDriver);
  void routeToAddDriver1({Object? arguments}) =>
      routeService.gotoRoute(AppLinks.addDriver, arguments: arguments);
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

  Future<void> openGalleryBackPage() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      logger.log("imagePath $pickedImageBackPath");
      pickedImageBackPath.value = response.imagePath;
      pickedImageBackName.value = response.imagePath.split('/').last;
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

  bool validateText() {
    if (selectedExpiryDate.value.isEmpty) {
      // Show an error message or handle it accordingly
      showErrorSnackbar(message: 'License expiry date is required');
      return false;
    }
    return true;
  }

  Future<void> createDriver() async {
    if (!createDriverFormKey.currentState!.validate() ||
        !validateImageUpload() ||
        !validateText()) {
      return;
    }
    try {
      isLoading.value = true;

      final response = await partnerService.updateLicensePhoto(
          payload: dio.FormData.fromMap({
            // 'fullName': fullNameController.text,
            'driverNumber': phoneNoController.text,
            // 'driverEmail': emailController.text,
            'licenseNumber': licenceNoController.text,
            'licenceExpireDate': selectedExpiryDate.value,
            'driverDocuments': [
              await dio.MultipartFile.fromFile(
                pickedImagePath.value,
                // // filename: 'vehicleLicense',
                // contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
              ),
              await dio.MultipartFile.fromFile(
                pickedImageBackPath.value,
                // filename: 'roadWorthiness',
                // contentType:
                //     MediaType(roadMimeTypeData[0], roadMimeTypeData[1]),
              ),
            ]
          }),
          driverID: driverID.value);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("driver profile updated ${response.message!}");
        showSuccessSnackbar(message: response.message!);
        Future.delayed(const Duration(seconds: 2))
            .then((value) => routeService.goBack(closeOverlays: true));
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

  Future<void> getOneDriver() async {
    gettingDriverIfo.value = true;
    try {
      final response =
          await partnerService.getOneDriver(driverId: driverID.value);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten driver details ${response.data}");
        if (response.data != null) {
          drivers?.value = response.data!
              .map((driver) => UserDriverData.fromJson(driver))
              .toList();
          licenceNoController.text = drivers!.first.licenseNumber ?? '';
          selectedExpiryDate.value = drivers!.first.licenceExpireDate ?? '';
          if (drivers!.first.licenceFront != null &&
              drivers!.first.licenceBack != null) {
            selectedExpiryDate.value = drivers!.first.licenceExpireDate ?? '';
            await downloadAndSaveImage(
                drivers!.first.licenceFront!, 'licenceFront.png', (filePath) {
              pickedImagePath.value = filePath;
              pickedImageName.value = 'licenceFront.png';

              logger.log("extracted name: ${pickedImageName.value}");
            });
            await downloadAndSaveImage(
                drivers!.first.licenceBack!, 'licenceBack.png', (filePath) {
              pickedImageBackPath.value = filePath;
              pickedImageBackName.value = 'licenceBack.png';

              logger.log("extracted name: ${pickedImageBackName.value}");
            });
          }
          gettingDriverIfo.value = false;
          // licenceNoController.text = response[""]
          logger.log("driver $drivers");
        }
      } else {
        logger.log("unable to get driver ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
    } finally {
      gettingDriverIfo.value = false;
    }
  }

  Future<void> downloadAndSaveImage(
      String url, String fileName, Function(String) onDownloadComplete) async {
    try {
      final response = await dio.Dio().get<Uint8List>(
        url,
        options: dio.Options(responseType: dio.ResponseType.bytes),
      );
      // logger.log("Photo downloaded: ${response.data}");

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      logger.log("Saving to file path: $filePath");

      final file = File(filePath);
      await file.writeAsBytes(response.data!, flush: true);

      // Rename the file
      File(filePath).renameSync('${directory.path}/$fileName');

      // Invoke the callback with the new local file path
      onDownloadComplete(filePath);

      // Continue with further operations after the download is complete
    } catch (e) {
      // Handle any errors or exceptions that occur during the process
      print("Error downloading and saving image: $e");
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
