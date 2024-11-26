import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/drivers_model.dart' as driver;
import 'package:gti_rides/models/image_response.dart';
import 'package:gti_rides/models/list_response_model.dart';
import 'package:gti_rides/models/partner/car_list_model.dart';
import 'package:gti_rides/models/partner/doc_expiry_date_model.dart';
import 'package:gti_rides/models/renter/trip_data_model.dart';
import 'package:gti_rides/models/user/kyc_response_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/Partner/home/list_vehicle/list_vehicle_screen.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ListVehicleController extends GetxController {
  Logger logger = Logger("Controller");

  // var data = Get.find<DriversController>();

  Rx<ListResponseModel> brands = ListResponseModel().obs;
  RxList<dynamic>? vehicleYear = <dynamic>[].obs;
  RxList<dynamic>? brandModel = <dynamic>[].obs;
  RxList<dynamic>? states = <dynamic>[].obs;
  RxList<dynamic>? cities = <dynamic>[].obs;
  RxList<dynamic>? transmissions = <dynamic>[].obs;
  RxList<dynamic>? selectedFeatures = <dynamic>[].obs;
  RxList<dynamic>? carFeatures = <dynamic>[].obs;
  RxList<dynamic>? vehicleTypes = <dynamic>[].obs;
  RxList<dynamic>? vehicleSeats = <dynamic>[].obs;
  RxList<dynamic>? insurances = <dynamic>[].obs;
  RxList<dynamic>? drivers = <dynamic>[].obs;
  RxList<dynamic>? cars = <dynamic>[].obs;

  RxBool isDeletingCarPhoto = false.obs;
  RxBool isLoading = false.obs;
  RxBool isFromManageCars = false.obs;
  RxBool isLoading1 = false.obs;
  RxBool isGettingBrands = false.obs;
  RxBool isGettingBrandModel = false.obs;
  RxBool isGettingyear = false.obs;
  RxBool isAddingCar = false.obs;
  PageController pageController = PageController();
  RxInt currentIndex = 0.obs;
  RxString phoneCode = '1'.obs;
  RxString flagEmoji = '🇺🇸'.obs;
  RxString brandCode = ''.obs;
  RxString modelCode = ''.obs;
  // RxString? yearName;
  RxString? modelName;
  RxString? selectedBrand = 'Select'.obs;
  RxString yearCode = ''.obs;
  Rx<dynamic> vehicleTypeCode = ''.obs;
  RxString vehicleSeatCode = ''.obs;
  RxString stateCode = ''.obs;
  RxString cityCode = ''.obs;
  RxString transmissionCode = ''.obs;
  RxList<dynamic> featuresCode = <dynamic>[].obs;
  RxString insuranceCode = ''.obs;
  // Rx<String> pickedImagePath = ''.obs;
  Rx<String> startDateTime = ''.obs;
  Rx<String> endDateTime = ''.obs;
  // Rx<String> discountNoOfDays = ''.obs;
  Rx<String> selectedDriverId = ''.obs;
  Rx<String> carID = ''.obs;
  Rx<String> selectedPhotos = ''.obs;
  Rx<String> selectedPhotoName = ''.obs;
  Rx<String> realPhotoName = ''.obs;
  Rx<String> selectedRoadWorthinessPhoto = ''.obs;
  Rx<String> selectedRoadWorthinessPhotoName = ''.obs;
  Rx<String> realRoadWorthinessPhotoName = ''.obs;
  Rx<String> selectedInsurancePhotos = ''.obs;
  Rx<String> selectedInsurancePhotoName = ''.obs;
  Rx<String> realInsurancePhotoName = ''.obs;
  Rx<String> selectedInspectionPhotos = ''.obs;
  Rx<String> selectedInspectionPhotoName = ''.obs;
  Rx<String> realInspectionPhotoName = ''.obs;
  RxList<String> selectedVehiclePhotos = <String>[].obs;
  RxList<Photo> apiFetchedPhotos =
      <Photo>[].obs; // List of Photo objects from the API

  Rx<String> selectedVehiclePhoto = ''.obs;
  Rx<String> userVin = ''.obs;
  Rx<String> plateNumber = ''.obs;
  Rx<String> state = ''.obs;
  Rx<String> city = ''.obs;
  Rx<String> brandName = ''.obs;
  Rx<String> advisedRenterPrice = ''.obs;

  GlobalKey<FormState> vehicleTypeFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> vehicleInfoFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> documentationFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> availabilityFormKey = GlobalKey<FormState>();

  TextEditingController senderNameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController pickupAddressController = TextEditingController();
  TextEditingController pickupAddressNumberController = TextEditingController();
  TextEditingController pickupLandarkController = TextEditingController();
  TextEditingController receiverNameController = TextEditingController();
  TextEditingController receiverPhoneController = TextEditingController();
  TextEditingController receiverEmailController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController destinationNumberController = TextEditingController();
  TextEditingController destinationLandmarkController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController kilogramController = TextEditingController();
  TextEditingController vinController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  // TextEditingController advanceAmountController = TextEditingController();
  TextEditingController rentPerDayController = TextEditingController();
  TextEditingController discountPerDayController = TextEditingController();
  TextEditingController aboutVehicleController = TextEditingController();
  Rx<TextEditingController> fromController = TextEditingController().obs;
  Rx<TextEditingController> toController = TextEditingController().obs;
  TextEditingController licenseExpiryDateController = TextEditingController();
  TextEditingController roadWorthinessExpiryDateController =
      TextEditingController();
  TextEditingController insuranceExpiryDateController = TextEditingController();
  TextEditingController inspectionExpiryDateController =
      TextEditingController();
  Rx<String> licenseExpiryDate = "".obs;
  Rx<String> roadWorthinessExpiryDate = "".obs;
  Rx<String> insuranceExpiryDate = "".obs;
  Rx<String> inspectionExpiryDate = "".obs;

  Rx<String> advanceTime = ''.obs;
  RxInt initiPageIndex = 1.obs;
  DateTime? rawStartTime;
  DateTime? rawEndTime;

  Rx<String>? errorMessage = ''.obs;
  ListVehicleController() {
    init();
  }

  void init() async {
    logger.log("ListVehicleController Initialized");
    Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null) {
      startDateTime.value = arguments['start'] ?? '';
      endDateTime.value = arguments['end'] ?? '';
      isFromManageCars.value = arguments['isFromManageCars'] ?? false;
      carID.value = arguments['carID'] ?? '';
      // Now you have access to the passed data (emailOrPhone)
      logger.log('Received data: $arguments');
      await getCarHistory();
    }
    vinController = TextEditingController(text: userVin.value);
    plateNumberController = TextEditingController(text: plateNumber.value);
    aboutVehicleController = TextEditingController(text: aboutCar.value);
    rentPerDayController = TextEditingController(text: pricePerDay.value);
    discountPerDayController = TextEditingController(text: discountPrice.value);
    await getBrands();
    await getStates();
    await getTransmission();
    await getCarFeatures();
    await getVehicleType();
    await getVehicleSeats();
    await getDrivers();
    await getInsuranceType();
    // await getCarHistory();
    logger.log("oooooooooo");
  }

  @override
  void onInit() async {
    logger.log("ListVehicleController");
    super.onInit();
    await getDrivers();

    // if (isFromManageCars.value == true) {
    //   currentIndex.value = 1;

    pageController = PageController(initialPage: currentIndex.value);
    // }
    pageController.addListener(() {
      currentIndex.value = pageController.page?.round() ?? 0;
      update();
    });
  }

  // variables

  List<String> cameraInstructions = [
    "Ensure the car is thoroughly cleaned before taking photos",
    "Use a high-quality camera or smartphone with a high-resolution camera",
    "Take photos in good lighting to capture true colors and details",
    "Capture all angles including front, back, sides, and interior",
    "Highlight unique features and special upgrades"
  ];

  List<String> vehicleBrands = [
    AppStrings.allBrand,
    AppStrings.amGeneral,
    AppStrings.acura,
    AppStrings.alfaRomeo,
    AppStrings.astonMartin,
    AppStrings.audi,
    AppStrings.bmw,
    AppStrings.bentley,
    AppStrings.buick,
    AppStrings.cardilac,
    AppStrings.chevrolet,
    AppStrings.ferrari,
    AppStrings.ford,
    AppStrings.honda,
    AppStrings.hummer,
    AppStrings.hyundai,
    AppStrings.infiniti,
    AppStrings.kia,
    AppStrings.lexus,
    AppStrings.lotus,
    AppStrings.lucid,
    AppStrings.mazda,
    AppStrings.mrcedesBenz,
    AppStrings.mistubishi,
    AppStrings.nissan,
    AppStrings.oldmobile,
    AppStrings.polaris,
    AppStrings.porche,
    AppStrings.rollsRoyce,
    AppStrings.tesla,
    AppStrings.toyota,
    AppStrings.volvo,
  ];

  List<Map<String, dynamic>> drivers1 = [
    // {
    //   'name': 'John Doe',
    //   'details': '08180065778 | johndoe@gmail.com',
    // },
    // {
    //   'name': 'Pascal Odi',
    //   'details': '08180065778 | johndoe@gmail.com',
    // },
    // {
    //   'name': 'Mbang Ade',
    //   'details': '08180065778 | johndoe@gmail.com',
    // },
    // {
    //   'name': 'Mbang Ade',
    //   'details': '08180065778 | johndoe@gmail.com',
    // },
    // {
    //   'name': 'Mbang Ade',
    //   'details': '08180065778 | johndoe@gmail.com',
    // },
    // {
    //   'name': 'Mbang Ade',
    //   'details': '08180065778 | johndoe@gmail.com',
    // },
  ];

  RxString selectedView = 'select'.obs;
  RxString selectedBrandModel = 'select'.obs;
  ValueNotifier<Fruit> selectedItem = ValueNotifier<Fruit>(Fruit.apple);
  Rx<driver.Driver> selectedItem1 = Rx<driver.Driver>(
    driver.Driver(
      fullName: 'John Doe',
      driverEmail: '08180065778 | johndoe@gmail.com',
    ),
  );

  String? validateValue(String? value) {
    // Perform your custom validation logic here
    if (value == null || value.isEmpty) {
      return 'Please select a valid option.';
    }
    // Add more validation rules as needed
    return null;
  }

// routing methods
  void goBack() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      // If already on the first page, pop the screen
      routeService.goBack();
    }
  }

  void goBack1() => routeService.goBack(closeOverlays: true);
  void routeToCreateDriver() {
    Get.back();
    routeService.gotoRoute(AppLinks.addDriver);
  }

  void routeToSelectDate() =>
      routeService.gotoRoute(AppLinks.chooseTripDate, arguments: {
        "appBarTitle": AppStrings.selectAvailabilityDate,
        "to": AppStrings.to,
        "from": AppStrings.from
      });

  Future<void> openCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      // Check if pickedImagePath is not null before accessing its value
      String originalPath = response.imagePath;
      String originalExtension = path.extension(originalPath).toLowerCase();

      realPhotoName.value = response.imagePath.split('/').last;
      selectedPhotoName.value = response.imagePath.split('/').last;
      selectedPhotos.value = (response.imagePath);
      logger.log("image path :: ${selectedPhotoName.value}");
      // Extract the directory and file name
      int lastSeparator = selectedPhotos.value.lastIndexOf('/');
      String directory = lastSeparator != -1
          ? selectedPhotos.value.substring(0, lastSeparator)
          : selectedPhotos.value;
      selectedPhotoName.value = 'vehicleLicense.png';

       // Check if the extension is valid (png or jpeg)
      if (![
        '.png',
        '.jpg',
      ].contains(originalExtension)) {
        logger.log("Unsupported file type: $originalExtension");
        // You might want to show an error message to the user here

        showErrorSnackbar(
            message:
                "Unsupported file type. Please upload a PNG or Jpeg file.");
        return;
      }

      var isLargeFile = await checkFileSize(
          path: response.imagePath, originalExtension: originalExtension);
      if (isLargeFile) {
        showErrorSnackbar(
            message:
                "Document size exceeds 2MB limit. Please choose a smaller file.");
        return;
      }

      // Build the new path with the desired file name
      String newPath = '$directory/$selectedPhotoName';
      logger.log("Picked new path $newPath");

      // Rename the file
      File(selectedPhotos.value).renameSync(newPath);

      // Now update the selectedPhotos value
      selectedPhotos.value = newPath;
      routeService.goBack;
    }
  }

//
  // Future<void> pickDocument() async {
  //   // ImageResponse? response =
  //   // await imageService.pickImage(source: ImageSource.gallery);
  //   ImageResponse? response = await imageService.pickDocument();
  //   if (response != null) {
  //     logger.log("Picked document ${selectedPhotoName.value}");
  //     realPhotoName.value = response.imagePath.split('/').last;
  //     selectedPhotos.value = response.imagePath;

  //     // Extract the directory and file name
  //     int lastSeparator = selectedPhotos.value.lastIndexOf('/');
  //     String directory = lastSeparator != -1
  //         ? selectedPhotos.value.substring(0, lastSeparator)
  //         : selectedPhotos.value;

  //     selectedPhotoName.value = 'vehicleLicense.png';

  //     // Build the new path with the desired file name
  //     String newPath = '$directory/$selectedPhotoName';
  //     logger.log("Picked new path $newPath");

  //     // Rename the file
  //     File(selectedPhotos.value).renameSync(newPath);

  //     // Now update the selectedPhotos value
  //     selectedPhotos.value = newPath;
  //     logger.log("selected document ${selectedPhotos.value}");
  //     routeService.goBack;
  //   }
  // }

  Future<bool> checkFileSize({
    required String path,
    required String originalExtension,
  }) async {
    // Check file size
    File file = File(path);
    int fileSizeInBytes = await file.length();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    if (originalExtension == '.pdf' ||
        originalExtension == '.doc' ||
        originalExtension == '.docx') {
      if (fileSizeInMB > 5) {
        Get.back();
        logger.log("File too large: ${fileSizeInMB.toStringAsFixed(2)} MB");
        showErrorSnackbar(
            message:
                "Document size exceeds 5MB limit. Please choose a smaller file.");
        return true;
      }
    } else {
      // Assuming all other files are images
      if (fileSizeInMB > 2) {
        Get.back();
        logger.log("File too large: ${fileSizeInMB.toStringAsFixed(2)} MB");
        showErrorSnackbar(
            message:
                "Image size exceeds 2MB limit. Please choose a smaller file.");
        return true;
      }
    }
    return false;
  }

  Future<void> pickDocument() async {
    ImageResponse? response = await imageService.pickDocument();
    if (response != null) {
      String originalPath = response.imagePath;
      String originalExtension = path.extension(originalPath).toLowerCase();

      // Check if the extension is valid (pdf or doc/docx)
      if (!['.pdf', '.doc', '.docx'].contains(originalExtension)) {
        logger.log("Unsupported file type: $originalExtension");
        // You might want to show an error message to the user here

        showErrorSnackbar(
            message: "Unsupported file type. Please upload a PDF or DOC file.");
        return;
      }

      var isLargeFile = await checkFileSize(
          path: originalPath, originalExtension: originalExtension);
      if (isLargeFile) {
        showErrorSnackbar(
            message:
                "Document size exceeds 5MB limit. Please choose a smaller file.");
        return;
      }

      String fileName = path.basename(originalPath);
      logger.log("Picked document: $fileName");

      // Extract the directory
      String directory = path.dirname(originalPath);

      // Create the new file name with the original extension
      String newFileName = 'vehicleLicense$originalExtension';
      String newPath = path.join(directory, newFileName);

      logger.log("New path: $newPath");

      try {
        // Rename the file
        File(originalPath).renameSync(newPath);

        // Update the selectedPhotos value
        selectedPhotos.value = newPath;
        selectedPhotoName.value = newFileName;
        realPhotoName.value = fileName;

        logger.log("Selected document: ${selectedPhotos.value}");
        // routeService.goBack();
      } catch (e) {
        logger.log("Error renaming file: $e");
        // Handle the error (e.g., show an error message to the user)
      }
    }
  }

  Future<void> openRoadWorthinessCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      String originalPath = response.imagePath;
      String originalExtension = path.extension(originalPath).toLowerCase();

      selectedRoadWorthinessPhoto.value = response.imagePath;
      selectedRoadWorthinessPhotoName.value =
          response.imagePath.split('/').last;
      realRoadWorthinessPhotoName.value = response.imagePath.split('/').last;

      int lastSeparator = selectedRoadWorthinessPhoto.value.lastIndexOf('/');
      String directory = lastSeparator != -1
          ? selectedRoadWorthinessPhoto.value.substring(0, lastSeparator)
          : selectedRoadWorthinessPhoto.value;
      selectedRoadWorthinessPhotoName.value = 'roadWorthiness.png';

      // Check if the extension is valid (png or jpeg)
      if (![
        '.png',
        '.jpg',
      ].contains(originalExtension)) {
        logger.log("Unsupported file type: $originalExtension");
        // You might want to show an error message to the user here

        showErrorSnackbar(
            message:
                "Unsupported file type. Please upload a PNG or Jpeg file.");
        return;
      }

      var isLargeFile = await checkFileSize(
          path: response.imagePath, originalExtension: originalExtension);
      if (isLargeFile) {
        showErrorSnackbar(
            message:
                "Document size exceeds 2MB limit. Please choose a smaller file.");
        return;
      }

      // Build the new path with the desired file name
      String newPath = '$directory/$selectedRoadWorthinessPhotoName';
      logger.log("Picked new path $newPath");

      // Rename the file
      File(selectedRoadWorthinessPhoto.value).renameSync(newPath);

      // Now update the selectedPhotos value
      selectedRoadWorthinessPhoto.value = newPath;
      routeService.goBack;
    }
  }

  // Future<void> openRoadWorthinessDocument() async {
  //   ImageResponse? response = await imageService.pickDocument();
  //   if (response != null) {
  //     selectedRoadWorthinessPhoto.value = response.imagePath;
  //     logger.log(
  //         "selectedRoadWorthinessPhoto: ${selectedRoadWorthinessPhoto.value}");
  //     selectedRoadWorthinessPhotoName.value =
  //         response.imagePath.split('/').last;
  //     realRoadWorthinessPhotoName.value = response.imagePath.split('/').last;

  //     int lastSeparator = selectedRoadWorthinessPhoto.value.lastIndexOf('/');
  //     String directory = lastSeparator != -1
  //         ? selectedRoadWorthinessPhoto.value.substring(0, lastSeparator)
  //         : selectedRoadWorthinessPhoto.value;
  //     selectedRoadWorthinessPhotoName.value = 'roadWorthiness.png';

  //     // Build the new path with the desired file name
  //     String newPath = '$directory/$selectedRoadWorthinessPhotoName';
  //     logger.log("Picked new path $newPath");

  //     // Rename the file
  //     File(selectedRoadWorthinessPhoto.value).renameSync(newPath);

  //     // Now update the selectedPhotos value
  //     selectedRoadWorthinessPhoto.value = newPath;
  //     routeService.goBack;
  //   }
  // }

  Future<void> openRoadWorthinessDocument() async {
    ImageResponse? response = await imageService.pickDocument();
    if (response != null) {
      String originalPath = response.imagePath;
      String originalExtension = path.extension(originalPath).toLowerCase();

      // Check if the extension is valid (pdf, doc, docx)
      if (!['.pdf', '.doc', '.docx'].contains(originalExtension)) {
        logger.log("Unsupported file type: $originalExtension");
        // You might want to show an error message to the user here
        return;
      }

      var isLargeFile = await checkFileSize(
          path: originalPath, originalExtension: originalExtension);
           if (isLargeFile) {
        showErrorSnackbar(
            message:
                "Document size exceeds 5MB limit. Please choose a smaller file.");
        return;
      }
      

      String fileName = path.basename(originalPath);
      logger.log("Picked document: $fileName");

      // Extract the directory
      String directory = path.dirname(originalPath);

      // Create the new file name with the original extension
      String newFileName = 'roadWorthiness$originalExtension';
      String newPath = path.join(directory, newFileName);

      logger.log("New path: $newPath");

      try {
        // Rename the file
        File(originalPath).renameSync(newPath);

        // Update the values
        selectedRoadWorthinessPhoto.value = newPath;
        selectedRoadWorthinessPhotoName.value = newFileName;
        realRoadWorthinessPhotoName.value = fileName;

        logger.log(
            "Selected Road Worthiness document: ${selectedRoadWorthinessPhoto.value}");
        // routeService.goBack();
      } catch (e) {
        logger.log("Error renaming file: $e");
        // Handle the error (e.g., show an error message to the user)
      }
    }
  }

  Future<void> openInsuranceCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      selectedInsurancePhotos.value = response.imagePath;
      selectedInsurancePhotoName.value = response.imagePath.split('/').last;
      realInsurancePhotoName.value = response.imagePath.split('/').last;

      int lastSeparator = selectedInsurancePhotos.value.lastIndexOf('/');
      String directory = lastSeparator != -1
          ? selectedInsurancePhotos.value.substring(0, lastSeparator)
          : selectedInsurancePhotos.value;
      selectedInsurancePhotoName.value = 'insuranceCertificate.png';

      // Build the new path with the desired file name
      String newPath = '$directory/$selectedInsurancePhotoName';
      logger.log("Picked new path $newPath");

      // Rename the file
      File(selectedInsurancePhotos.value).renameSync(newPath);

      // Now update the selectedPhotos value
      selectedInsurancePhotos.value = newPath;
      routeService.goBack;
    }
  }

  // Future<void> openInsuranceDocument() async {
  //   ImageResponse? response = await imageService.pickDocument();
  //   if (response != null) {
  //     selectedInsurancePhotos.value = response.imagePath;
  //     selectedInsurancePhotoName.value = response.imagePath.split('/').last;
  //     realInsurancePhotoName.value = response.imagePath.split('/').last;
  //     int lastSeparator = selectedInsurancePhotos.value.lastIndexOf('/');
  //     String directory = lastSeparator != -1
  //         ? selectedInsurancePhotos.value.substring(0, lastSeparator)
  //         : selectedInsurancePhotos.value;
  //     selectedInsurancePhotoName.value = 'insuranceCertificate.png';
  //     // Build the new path with the desired file name
  //     String newPath = '$directory/$selectedInsurancePhotoName';
  //     logger.log("Picked new path $newPath");
  //     // Rename the file
  //     File(selectedInsurancePhotos.value).renameSync(newPath);
  //     // Now update the selectedPhotos value
  //     selectedInsurancePhotos.value = newPath;
  //     routeService.goBack;
  //   }
  // }
  Future<void> openInsuranceDocument() async {
    ImageResponse? response = await imageService.pickDocument();
    if (response != null) {
      String originalPath = response.imagePath;
      String originalExtension = path.extension(originalPath).toLowerCase();

      // Check if the extension is valid (pdf, doc, docx)
      if (!['.pdf', '.doc', '.docx'].contains(originalExtension)) {
        logger.log("Unsupported file type: $originalExtension");
        // You might want to show an error message to the user here
        return;
      }

       var isLargeFile = await checkFileSize(
          path: originalPath, originalExtension: originalExtension);
      if (isLargeFile) {
        showErrorSnackbar(
            message:
                "Document size exceeds 5MB limit. Please choose a smaller file.");
        return;
      }

      String fileName = path.basename(originalPath);
      logger.log("Picked document: $fileName");

      // Extract the directory
      String directory = path.dirname(originalPath);

      // Create the new file name with the original extension
      String newFileName = 'insuranceCertificate$originalExtension';
      String newPath = path.join(directory, newFileName);

      logger.log("New path: $newPath");

      try {
        // Rename the file
        File(originalPath).renameSync(newPath);

        // Update the values
        selectedInsurancePhotos.value = newPath;
        selectedInsurancePhotoName.value = newFileName;
        realInsurancePhotoName.value = fileName;

        logger.log(
            "Selected Insurance document: ${selectedInsurancePhotos.value}");
        // routeService.goBack();
      } catch (e) {
        logger.log("Error renaming file: $e");
        // Handle the error (e.g., show an error message to the user)
      }
    }
  }

  Future<void> openInspectionCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      selectedInspectionPhotos.value = (response.imagePath);
      selectedInspectionPhotoName.value = (response.imagePath).split('/').last;
      realInspectionPhotoName.value = (response.imagePath).split('/').last;

      int lastSeparator = selectedInspectionPhotos.value.lastIndexOf('/');
      String directory = lastSeparator != -1
          ? selectedInspectionPhotos.value.substring(0, lastSeparator)
          : selectedInspectionPhotos.value;
      selectedInspectionPhotoName.value = 'inspectionReport.png';

      // Build the new path with the desired file name
      String newPath = '$directory/$selectedInspectionPhotoName';
      logger.log("Picked new path $newPath");

      // Rename the file
      File(selectedInspectionPhotos.value).renameSync(newPath);

      // Now update the selectedPhotos value
      selectedInspectionPhotos.value = newPath;
      routeService.goBack;
    }
  }

  // Future<void> openInspectionDocument() async {
  //   ImageResponse? response = await imageService.pickDocument();
  //   if (response != null) {
  //     selectedInspectionPhotos.value = (response.imagePath);
  //     selectedInspectionPhotoName.value = (response.imagePath).split('/').last;
  //     realInspectionPhotoName.value = (response.imagePath).split('/').last;

  //     int lastSeparator = selectedInspectionPhotos.value.lastIndexOf('/');
  //     String directory = lastSeparator != -1
  //         ? selectedInspectionPhotos.value.substring(0, lastSeparator)
  //         : selectedInspectionPhotos.value;
  //     selectedInspectionPhotoName.value = 'inspectionReport.png';

  //     // Build the new path with the desired file name
  //     String newPath = '$directory/$selectedInspectionPhotoName';
  //     logger.log("Picked new path $newPath");

  //     // Rename the file
  //     File(selectedInspectionPhotos.value).renameSync(newPath);

  //     // Now update the selectedPhotos value
  //     selectedInspectionPhotos.value = newPath;
  //     routeService.goBack;
  //   }
  // }

  Future<void> openInspectionDocument() async {
    ImageResponse? response = await imageService.pickDocument();
    if (response != null) {
      String originalPath = response.imagePath;
      String originalExtension = path.extension(originalPath).toLowerCase();

      // Check if the extension is valid (pdf, doc, docx)
      if (!['.pdf', '.doc', '.docx'].contains(originalExtension)) {
        logger.log("Unsupported file type: $originalExtension");
        // You might want to show an error message to the user here
        return;
      }

       var isLargeFile = await checkFileSize(
          path: originalPath, originalExtension: originalExtension);
      if (isLargeFile) {
        showErrorSnackbar(
            message:
                "Document size exceeds 5MB limit. Please choose a smaller file.");
        return;
      }

      String fileName = path.basename(originalPath);
      logger.log("Picked document: $fileName");

      // Extract the directory
      String directory = path.dirname(originalPath);

      // Create the new file name with the original extension
      String newFileName = 'inspectionReport$originalExtension';
      String newPath = path.join(directory, newFileName);

      logger.log("New path: $newPath");

      try {
        // Rename the file
        File(originalPath).renameSync(newPath);

        // Update the values
        selectedInspectionPhotos.value = newPath;
        selectedInspectionPhotoName.value = newFileName;
        realInspectionPhotoName.value = fileName;

        logger.log(
            "Selected Inspection document: ${selectedInsurancePhotos.value}");
        // routeService.goBack();
      } catch (e) {
        logger.log("Error renaming file: $e");
        // Handle the error (e.g., show an error message to the user)
      }
    }
  }

  Future<void> openVehiclePhotoCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      selectedVehiclePhotos.add(response.imagePath);
      selectedVehiclePhoto.value = response.imagePath;
    }
  }

  // Future<void> openVehiclePhotoGallery() async {
  //   ImageResponse? response =
  //       await imageService.pickImage(source: ImageSource.gallery);
  //   if (response != null) {
  //     selectedVehiclePhotos.add(response.imagePath);
  //     selectedVehiclePhoto.value = (response.imagePath);
  //     routeService.goBack;
  //   }
  // }

  final int maxAllowedPhotos = 10;

  Future<void> openVehiclePhotoGallery() async {
    List<ImageResponse> responses = await imageService.pickMultipleImages();

    if (responses != null) {
      for (ImageResponse response in responses) {
        // Check if the maximum allowed photos limit is reached
        if (selectedVehiclePhotos.length + apiFetchedPhotos.length <
            maxAllowedPhotos) {
          selectedVehiclePhotos.add(response.imagePath);
        } else {
          // Notify the user that the limit is reached
          showErrorSnackbar(
            message: 'You cannot upload more than $maxAllowedPhotos photos',
          );
          break; // Break the loop if the limit is reached
        }
      }
    }
  }

  // Function(List<String>) onChanged(){
  //   controller.selectedFeatures!.value
  // }

  Future<void> getBrands() async {
    try {
      //isGettingBrandModel.value = true;
      vehicleYear!.clear();
      isGettingBrands.value = true;
      final response = await partnerService.getBrand();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten brands ${response.data}");
        if (response.data != null && response.data != []) {
          brands.value.data = response.data;
          logger.log("brands ${brands.value.data}");
        }
      } else {
        logger.log("unable to get brands ${response.data}");
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("get brands error  $exception");
    } finally {
      isGettingBrands.value = false;
    }
  }

  final RxList<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ].obs;
  Rx<String>? selectedValue;
  String? selectedValue1 = 'Select';
  Rx<String>? selectedYearValue = 'Select'.obs;
  String? brandCode1;
  String? brandModelCode;

  Future<void> getVehicleYear(
      {required String brandCode, required String brandModelCode}) async {
    try {
      //isGettingBrands.value = true;
      isGettingyear.value = true;
      vehicleYear!.clear();
      selectedYearValue!.value = 'Select';
      final response = await partnerService.getVehicleYear(
          brandCode: brandCode, brandModelCode: brandModelCode);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten vehicle year ${response.data}");
        if (response.data != null && response.data != []) {
          // vehicleYear?.value = response.data!;
          vehicleYear!.assignAll(response.data!);
          isGettingyear.value = false;

          logger.log("vehicle year ${vehicleYear!.value}");
        } else {
          logger.log("no vehicle year ${response.data}");
        }
      } else {
        logger.log("unable to get vehicle year ${response.data}");
        showErrorSnackbar(message: response.message!);
        isGettingyear.value = false;
      }
    } catch (exception) {
      logger.log("get vehicle year error  $exception");
    } finally {
      isGettingyear.value = false;
    }
  }

  Future<void> getBrandModel({required String brandCode1}) async {
    try {
      isGettingBrandModel.value = true;
      // vehicleYear!.clear();
      final response =
          await partnerService.getBrandModel(brandCode: brandCode1);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten brand model ${response.data}");
        if (response.data != null && response.data != []) {
          brandModel?.value = response.data!;
          logger.log("brand model ${response.data}");
          isGettingBrandModel.value = false;
          // selectedValue1 = response.data!.first['brandModelName'];
          // brandCode.value = response.data!.first!["brandCode"];
          // modelCode.value = response.data!.first!["modelCode"];

          // await getVehicleYear(brandModelCode: modelCode.value, brandCode: brandCode.value);
        }
      } else {
        logger.log("unable to get brand model ${response.data}");
        showErrorSnackbar(message: response.message!);
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("get brand model error  $exception");
    } finally {
      isGettingBrandModel.value = false;
    }
  }

  Future<void> getStates() async {
    try {
      //isGettingBrands.value = true;
      final response = await partnerService.getStates();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten states ${response.data}");
        if (response.data != null && response.data != []) {
          states?.value = response.data!;
          logger.log("states ${brands.value.data}");
        }
      } else {
        logger.log("unable to get states ${response.data}");
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("get states error  $exception");
    }
  }

  Future<void> getCity({required String cityCode1}) async {
    try {
      //isGettingBrands.value = true;
      final response = await partnerService.getCity(cityCode: cityCode1);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten cities ${response.data}");
        if (response.data != null && response.data != []) {
          cities?.value = response.data!;
          // cityCode.value = response.data?.first['cityCode'];
          logger.log("cities ${brands.value.data}");
        }
      } else {
        logger.log("unable to get city ${response.data}");
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("get city error  $exception");
    }
  }

  Future<void> getTransmission() async {
    try {
      //isGettingBrands.value = true;
      final response = await partnerService.getTransmission();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten transmission ${response.data}");
        if (response.data != null && response.data != []) {
          transmissions?.value = response.data!;
          logger.log("transmissions: ${transmissions?.value}");
        }
      } else {
        logger.log("unable to get transmission ${response.data}");
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("transmission error  $exception");
    }
  }

  Future<void> getCarFeatures() async {
    try {
      //isGettingBrands.value = true;
      final response = await partnerService.getFeatures();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten car features ${response.data}");
        if (response.data != null && response.data != []) {
          carFeatures?.value = response.data!;
          logger.log("features ${carFeatures?.value}");
        }
      } else {
        logger.log("unable to car features ${response.data}");
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("get car features error  $exception");
    }
  }

  Future<void> getVehicleType() async {
    try {
      //isGettingBrands.value = true;
      final response = await partnerService.getVehicleType();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten vehicle Types ${response.data}");
        if (response.data != null && response.data != []) {
          vehicleTypes?.value = response.data!;
          logger.log("vehicle type ${vehicleTypes?.value}");
        }
      } else {
        logger.log("unable to vehicle Types ${response.data}");
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("get vehicle type error  $exception");
    }
  }

  Future<void> getVehicleSeats() async {
    try {
      //isGettingBrands.value = true;
      final response = await partnerService.getVehicleSeats();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten vehicle seats ${response.data}");
        if (response.data != null && response.data != []) {
          vehicleSeats?.value = response.data!;
          logger.log("seats ${vehicleSeats?.value}");
        }
      } else {
        logger.log("unable to vehicle seats ${response.data}");
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("get vehicle seats error  $exception");
    }
  }

  Future<void> getInsuranceType() async {
    try {
      //isGettingBrands.value = true;
      final response = await partnerService.getInsuranceType();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten insurance type ${response.data}");
        if (response.data != null && response.data != []) {
          insurances?.value = response.data!;
          logger.log("insurances ${insurances?.value}");
        }
      } else {
        logger.log("unable to get insurance type ${response.data}");
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("get insurance error  $exception");
    }
  }

  Future<void> getDrivers() async {
    try {
      //isGettingBrands.value = true;
      final response = await partnerService.getDrivers();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten drivers ${response.data}");
        if (response.data != null) {
          drivers?.value = response.data!;
          logger.log("drivers $drivers");
        }
      } else {
        logger.log("unable to get drivers ${response.data}");
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("get drivers error  $exception");
    }
  }

  List<String> requiredKycFields = ["dateOfBirth", "gender", "homeAddress"];
  List<String> missingKycFields = ["dateOfBirth", "gender", "homeAddress"];

  List<String> getMissingKycFields(KycData kycData) {
    List<String> missingKycFields1 = [];

    for (String field in requiredKycFields) {
      dynamic fieldValue = kycData.toJson()[field];
      logger.log("field value:: $fieldValue");

      // Directly add the field to missingKycFields if it's not present
      if (fieldValue == null || fieldValue.isEmpty) {
        missingKycFields1.add(field);
      }
    }

    return missingKycFields1;
  }

  Future<bool> getUserKyc() async {
    try {
      final kycResponse = await userService.getKycProfile();

      if (kycResponse.status == 'success' || kycResponse.status_code == 200) {
        if (kycResponse.data != null && kycResponse.data!.isNotEmpty) {
          Map<String, dynamic> firstKycItem = kycResponse.data!.first;

          // Check if the first item in the list is not empty
          if (firstKycItem.isNotEmpty) {
            missingKycFields.clear();
            KycData kycData = KycData.fromJson(firstKycItem);

            // Check missing fields and route accordingly
            missingKycFields = getMissingKycFields(kycData);

            // Use missingKycFields for further processing if needed
            if (missingKycFields.isNotEmpty) {
              // User has all KYC fields
              return false;
            } else {
              // User is missing KYC fields
              return true;
            }
          } else {
            // Route to KYC screen if data is empty
            // user has no KYC profile at all
            return false;
          }
        } else {
          // Route to KYC screen if data is empty
          // user has no KYC profile at all
          return false;
        }
      } else {
        logger.log(
            "Unable to fetch User KYC: ${kycResponse.message ?? "kyc error"}");
      }
    } catch (exception) {
      logger.log("Unable to fetch User KYC: $exception");
    }

    // Default to false if an error occurs
    return false;
  }

  Future<void> addCar() async {
    if (!vehicleTypeFormKey.currentState!.validate()) {
      return;
    }
    if (selectedBrandModel.value == 'Select' ||
        selectedYearValue!.value == 'Select') {
      showErrorSnackbar(message: 'All fields must be selected');
      return;
    }

    isLoading.value = true;
    try {
      List<String> originalMissingKycFields = List.from(missingKycFields);

      var hasKycFields = await getUserKyc();
      if (!hasKycFields) {
        // Route to KYC screen, and the rest of the function will be executed later
        routeService.gotoRoute(AppLinks.kycCheck, arguments: {
          "missingKycFields": originalMissingKycFields,
          "isCarListing": true,
          "tripData": TripData()
        });
        return;
      }

      // Continue with the logic to add a car
      await addCarLogic();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCarLogic() async {
    try {
      final response = await partnerService.addCar(data: {
        "brandCode": brandCode.value,
        "brandModelCode": modelCode.value,
        "yearCode": yearCode.value,
        "vin": vinController.text,
        "plateNumber": plateNumberController.text,
        "stateCode": stateCode.value,
        "cityCode": cityCode.value,
      }, param: isFromManageCars.isTrue ? "?carID=${carID.value}" : '');

      if (response.status == 'success' || response.status_code == 200) {
        logger.log("car added ${response.data}");
        if (response.data != null) {
          carID.value = response.data!["carID"];
          showSuccessSnackbar(message: response.message!);
          goToNextPage();
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  ScrollController scrollController = ScrollController();

  void goToNextPage() {
    currentIndex.value++;
    // scrollController.position.maxScrollExtent;
    // scrollController.jumpTo(0.0);

    pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future<void> addCarInfo() async {
    if (!vehicleInfoFormKey.currentState!.validate()) {
      return;
    }
    if (selectedFeatures!.isEmpty) {
      showErrorSnackbar(message: "Car Features is empty");
      return;
    }
    try {
      isLoading.value = true;
      final response = await partnerService.addCarInfo(data: {
        "about": aboutVehicleController.text,
        "transmissionCode": transmissionCode.value,
        "featureCode": featuresCode.value,
        "typeCode": vehicleTypeCode.value,
        "seatCode": vehicleSeatCode.value
      }, carId: carID.value);

      if (response.status == 'success' || response.status_code == 200) {
        logger.log("car info added ${response.data}");
        // if (response.data != null) {
        // cities?.value = response.data!;
        // logger.log("carID ${brands.value.data}");
        showSuccessSnackbar(message: response.message!);
        goToNextPage();
        // getCarHistory();
        // }
      } else {
        logger.log("unable to add car info${response.data}");
        isLoading.value = false;
        showErrorSnackbar(message: response.message.toString());
      }
    } catch (exception) {
      logger.log("add car info error  $exception");
      showErrorSnackbar(message: exception.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCarAvailability() async {
    if (!availabilityFormKey.currentState!.validate()) {
      return;
    }
    // if (selectedView.value == 'select') {
    //   showErrorSnackbar(message: 'Kindly select a driver');
    // }
    try {
      isLoading1.value = true;
      final response = await partnerService.addCarAvailability(payload: {
        "startDate": rawStartTime!.toIso8601String(),
        "endDate": rawEndTime!.toIso8601String(),
        "advanceDays": advanceTime.value,
        "pricePerDay": rentPerDayController.text,
        "discountDays": discountDays.value,
        "discountPrice": discountPerDayController.text,
        "driverID": selectedDriverId.value
      }, carID: carID.value);

      if (response.status == 'success' || response.status_code == 200) {
        logger.log("added availability ${response.data}");
        showSuccessSnackbar(message: response.message!);
        successDialog(
            title: AppStrings.vehicleInfoSubmitted,
            body: AppStrings.thankYouForYourPatience,
            buttonTitle: AppStrings.back,
            onTap: () {
              // routeService.goBack(closeOverlays: true);
              Get.offNamedUntil(
                AppLinks.manageVehicle,
                ModalRoute.withName(AppLinks.carOwnerLanding),
              );
            });
      } else {
        logger.log("unable to add car availability ${response.data}");
        showErrorSnackbar(message: response.message!);
        isLoading1.value = false;
      }
    } catch (exception) {
      logger.log("add car availability error  $exception");
      showErrorSnackbar(message: exception.toString());
    } finally {
      isLoading1.value = false;
    }
  }

  bool validateImageUpload() {
    if (selectedRoadWorthinessPhoto.isEmpty ||
        selectedPhotos.isEmpty ||
        selectedInspectionPhotos.isEmpty ||
        selectedInsurancePhotos.isEmpty) {
      // Show an error message or handle it accordingly
      showErrorSnackbar(message: 'Please upload an image.');
      return false;
    }
    return true;
  }

  bool validateImageUpload1() {
    if (selectedVehiclePhotos.isEmpty && apiFetchedPhotos.isEmpty) {
      // Show an error message or handle it accordingly
      showErrorSnackbar(message: 'Please upload an image.');
      return false;
    }
    if (selectedVehiclePhotos.length + apiFetchedPhotos.length < 6) {
      showErrorSnackbar(message: 'Kindly upload more photos.');
      return false;
    }
    return true;
  }

  // List<dio.MultipartFile> documentFiles = [];

  // documentFiles.add(await dio.MultipartFile.fromFile(
  //   selectedPhotos.value,
  //   filename: 'vehicleLicense',
  //   contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
  // ));

  // documentFiles.add(await dio.MultipartFile.fromFile(
  //   selectedRoadWorthinessPhoto.value,
  //   filename: 'roadWorthiness',
  //   contentType: MediaType(roadMimeTypeData[0], roadMimeTypeData[1]),
  // ));

  // documentFiles.add(await dio.MultipartFile.fromFile(
  //   selectedInsurancePhotos.value,
  //   filename: 'insuranceCertificate',
  //   contentType:
  //       MediaType(insuranceMimeTypeData[0], insuranceMimeTypeData[1]),
  // ));

  // documentFiles.add(await dio.MultipartFile.fromFile(
  //   selectedInspectionPhotos.value,
  //   filename: 'inspectionReport',
  //   contentType:
  //       MediaType(inspectionMimeTypeData[0], inspectionMimeTypeData[1]),
  // ));

  // data1 = dio.FormData.fromMap({
  //   'insuranceType': insuranceCode.value,
  //   "document": documentFiles,
  // });

  // logger.log("form files ${data1.files.toList()}");
  // logger.log("form field ${data1.fields.toList()}");

//////////////
  ///
  // Future<void> downloadAndSaveFile(
  //     String url, String fileName, Function(String) onDownloadComplete) async {
  //   try {
  //     final response = await dio.Dio().get<Uint8List>(
  //       url,
  //       options: dio.Options(responseType: dio.ResponseType.bytes),
  //     );
  //     logger.log("Photo downloaded: ${response.data}");

  //     final directory = await getApplicationDocumentsDirectory();
  //     final filePath = '${directory.path}/$fileName';

  //     logger.log("Saving to file path: $filePath");

  //     final file = File(filePath);
  //     await file.writeAsBytes(response.data!, flush: true);

  //     // Rename the file
  //     File(filePath).renameSync('${directory.path}/$fileName');

  //     // Invoke the callback with the new local file path
  //     onDownloadComplete(filePath);

  //     // Continue with further operations after the download is complete
  //   } catch (e) {
  //     // Handle any errors or exceptions that occur during the process
  //     print("Error downloading and saving image: $e");
  //   }
  // }

  Future<void> downloadAndSaveFile(
      String url, String fileName, Function(String) onDownloadComplete) async {
    try {
      final fileResponse = await dio.Dio().get<Uint8List>(
        url,
        options: dio.Options(responseType: dio.ResponseType.bytes),
      );
      logger.log("File downloaded: ${fileResponse.data}");

      final directory = await getApplicationDocumentsDirectory();

      // Extract file extension from the response headers or URL
      String fileExtension = _getFileExtension(fileResponse, url);

      // Construct the file name with the correct extension
      String fullFileName = '$fileName.$fileExtension';
      String filePath = path.join(directory.path, fullFileName);

      logger.log("Saving to file path: $filePath");

      final file = File(filePath);
      await file.writeAsBytes(fileResponse.data!, flush: true);

      // Invoke the callback with the new local file path
      onDownloadComplete(filePath);

      // Continue with further operations after the download is complete
    } catch (e) {
      // Handle any errors or exceptions that occur during the process
      print("Error downloading and saving file: $e");
    }
  }

  String _getFileExtension(dio.Response<Uint8List> response, String url) {
    // Try to get the file extension from the Content-Type header
    String? contentType = response.headers.value('content-type');
    if (contentType != null) {
      if (contentType.contains('pdf')) return 'pdf';
      if (contentType.contains('msword') ||
          contentType
              .contains('vnd.openxmlformats-officedocument.wordprocessingml'))
        return 'doc';
      if (contentType.contains('png')) return 'png';
      // Add more content type checks as needed
    }

    // If content type is not available or recognized, extract extension from the URL
    String extension = path.extension(url).toLowerCase();
    return extension.isNotEmpty ? extension.substring(1) : 'unknown';
  }

  Future<void> addCarDocument() async {
    if (!documentationFormKey.currentState!.validate() ||
        !validateImageUpload()) {
      return;
    }
    final mimeTypeData =
        lookupMimeType(selectedPhotos.value, headerBytes: [0xFF, 0xD8])!
            .split('/');
    final roadMimeTypeData = lookupMimeType(selectedRoadWorthinessPhoto.value,
            headerBytes: [0xFF, 0xD8])!
        .split('/');
    final insuranceMimeTypeData = lookupMimeType(selectedInsurancePhotos.value,
            headerBytes: [0xFF, 0xD8])!
        .split('/');
    final inspectionMimeTypeData = lookupMimeType(
            selectedInspectionPhotos.value,
            headerBytes: [0xFF, 0xD8])!
        .split('/');

    try {
      isLoading.value = true;

      // final formData = await constructFormData();
      logger.log("file path:: ${selectedRoadWorthinessPhoto.value.toString()}");
      final response = await partnerService.addCarDocument(
          payload: dio.FormData.fromMap({
            'insuranceType': insuranceCode.value,
            // 'document': await dio.MultipartFile.fromFile(selectedPhotos.value,
            //     filename: selectedPhotoName.value,
            //     contentType: MediaType(mimeTypeData[0], mimeTypeData[1]))
            'document': [
              await dio.MultipartFile.fromFile(
                selectedPhotos.value,
                // filename: 'vehicleLicense',
                contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
              ),
              await dio.MultipartFile.fromFile(
                selectedRoadWorthinessPhoto.value,
                // filename: 'roadWorthiness',
                contentType:
                    MediaType(roadMimeTypeData[0], roadMimeTypeData[1]),
              ),
              await dio.MultipartFile.fromFile(
                selectedInsurancePhotos.value,
                // filename: 'insuranceCertificate',
                contentType: MediaType(
                    insuranceMimeTypeData[0], insuranceMimeTypeData[1]),
              ),
              await dio.MultipartFile.fromFile(
                selectedInspectionPhotos.value,
                // filename: 'inspectionReport',
                contentType: MediaType(
                    inspectionMimeTypeData[0], inspectionMimeTypeData[1]),
              ),
            ]
          }),
          carID: carID.value);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("car document added ${response.message}");
        await addCarDocumentExpireDate();

        showSuccessSnackbar(message: response.message!);
        goToNextPage();
        // getCarHistory();
      } else {
        logger.log("unable to add document ${response.data}");
        showErrorSnackbar(message: response.message!);
        isLoading.value = false;
      }
    } catch (exception) {
      logger.log("add car doc error  $exception");
      showErrorSnackbar(message: exception.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCarDocumentExpireDate() async {
    // isDeletingCarPhoto.value = true;
    // You might want to call an API to delete the photo on the server as well
    var data = json.encode([
      {"documentName": "vehicleLicense", "expireDate": licenseExpiryDate.value},
      {
        "documentName": "roadWorthiness",
        "expireDate": roadWorthinessExpiryDate.value
      },
      {
        "documentName": "insuranceCertificate",
        "expireDate": inspectionExpiryDate.value
      },
      {
        "documentName": "inspectionReport",
        "expireDate": inspectionExpiryDate.value
      },
    ]);

    try {
      final response = await partnerService.addCarDocumentExpireDate(
          payload: data, carId: carID.value);
      if (response.status == 'success' || response.status_code == 200) {
        // showSuccessSnackbar(message: 'Photo deleted successfully');
        logger.log("car document expriry success");
      } else {
        logger.log("Unable to delete car photo");
      }
    } catch (e) {
      logger.log("eror:: ${e.toString()}");
    } finally {
      // isDeletingCarPhoto.value = false;
    }
  }

  Future<void> addCarPhoto() async {
    if (!validateImageUpload1()) {
      return;
    }

    final mimeTypeData =
        lookupMimeType(selectedVehiclePhoto.value, headerBytes: [0xFF, 0xD8])!
            .split('/');
    String fileName = selectedVehiclePhoto.split('/').last;

    try {
      isLoading.value = true;
      // var data = dio.FormData();
      // Future<dio.FormData> constructFormData() async {
      // List<dio.MultipartFile> files = [];
      var formData = dio.FormData.fromMap({});

      // formData.files.add(
      //   // await dio.MultipartFile.fromFile(filePath, filename: filePath)
      //   MapEntry(
      //       'photo',
      //       (await dio.MultipartFile.fromFile(
      //         filePath,
      //         filename: filePath,
      //       ))),
      // );
      // data = dio.FormData.fromMap({
      //   'photo': formData,
      // });

      // ***********************************************//

      //>>>>>>>>>>>>>>>>
      // for (var filePath in selectedVehiclePhotos) {
      //   formData = dio.FormData.fromMap({
      //     'photos': await dio.MultipartFile.fromFile(
      //       filePath,
      //       filename: filePath,
      //       contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      //     )
      //   });
      // }
      List<dio.MultipartFile> files = [];

      for (var filePath in selectedVehiclePhotos) {
        final mimeTypeData =
            lookupMimeType(filePath, headerBytes: [0xFF, 0xD8])!.split('/');
        String fileName = filePath.split('/').last;

        files.add(await dio.MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ));
      }

      formData = dio.FormData.fromMap({'image': files});

      // formData = dio.FormData.fromMap({
      //   'photos': await dio.MultipartFile.fromFile(selectedVehiclePhoto.value,
      //       filename: fileName,
      //       contentType: MediaType(mimeTypeData[0], mimeTypeData[1]))
      // });

      logger.log("POST REQUEST DATA:: ${formData.fields.toString()}");
      logger.log("POST REQUEST DATA:: ${formData.files.toString()}");
      //   return data;
      // }

      // final formData = await constructFormData();
      final response = await partnerService.addCarPhoto(
          payload: formData, carID: carID.value);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("car photos added ${response.message}");
        showSuccessSnackbar(message: response.message!);
        goToNextPage();
        // getCarHistory();
      } else {
        logger.log("unable to add car photos ${response.data}");
        showErrorSnackbar(message: response.message!);
        isLoading.value = false;
      }
    } catch (exception) {
      logger.log(" add car photo error  $exception");
      showErrorSnackbar(
          message: exception.toString().contains('Map<String, dynamic>')
              ? "Sorry, unknown error "
              : exception.toString());
    } finally {
      isLoading.value = false;
    }
  }

  RxList<dynamic> carHistory = RxList<dynamic>();
  RxList<CarListData> carHistory1 = RxList<CarListData>();
  RxString startDate = ''.obs;
  RxString endDate = ''.obs;
  RxString pricePerDay = ''.obs;
  Rx<bool> isFetchingCarDetails = false.obs;
  Rx<String> aboutCar = ''.obs;
  Rx<String> transmission = ''.obs;
  Rx<String> vehicleType = ''.obs;
  Rx<String> numberOfSeats = ''.obs;
  Rx<String> insurance = ''.obs;
  Rx<String> discountDays = ''.obs;
  Rx<String> discountPrice = ''.obs;
  // Rx<String> carType = ''.obs;
  // Rx<String> seatCode = ''.obs;
  // Rx<String> brandCode = ''.obs;
  RxList<String> features = <String>[].obs;

  String extractDocumentName(String? documentURL) {
    if (documentURL == null || documentURL.isEmpty) {
      return ''; // or throw an error, depending on your requirements
    }

    final segments = documentURL.split('--');
    return segments.last.split('?').first;
  }

  Future<void> deleteFetchedPhoto(String photoCode) async {
    isDeletingCarPhoto.value = true;
    // You might want to call an API to delete the photo on the server as well

    try {
      final response = await partnerService.deleteCarPhoto(carID: photoCode);
      if (response.status == 'success' || response.status_code == 200) {
        apiFetchedPhotos.removeWhere((photo) => photo.photoCode == photoCode);
        showSuccessSnackbar(message: 'Photo deleted successfully');
      } else {
        logger.log("Unable to delete car photo");
      }
    } catch (e) {
      logger.log("eror:: ${e.toString()}");
    } finally {
      isDeletingCarPhoto.value = false;
    }
  }

  Future<void> getCarHistory() async {
    isFetchingCarDetails.value = true;

    try {
      final response = await partnerService.getOnCar(carId: carID.value);

      if (response.status == 'success' || response.status_code == 200) {
        final carData = response.data;

        logger.log("gotten car history $carData");

        if (carData != null && carData.isNotEmpty) {
          carHistory.value = carData;

          final firstCar = carData.first;
          CarListData carListData = CarListData.fromJson(response.data?.first);

          userVin.value = firstCar['vin'];
          plateNumber.value = firstCar['plateNumber'];
          state.value = firstCar['state'][0]["stateName"];
          city.value = firstCar['city'].isNotEmpty
              ? firstCar['city'][0]["cityName"]
              : "";
          logger.log("city value:: ${city.value}");
          stateCode.value = firstCar['state'].isNotEmpty
              ? firstCar['state'][0]["stateCode"]
              : '';
          brandName.value = firstCar['brand'].isNotEmpty
              ? firstCar['brand'][0]["brandName"]
              : '';
          brandCode.value = firstCar['brand'].isNotEmpty
              ? firstCar['brand'][0]['brandCode']
              : '';
          modelCode.value = firstCar['brandModel'].isNotEmpty
              ? firstCar['brandModel'][0]['modelCode']
              : '';
          yearCode.value = firstCar['modelYear'].isNotEmpty
              ? firstCar['modelYear'][0]['yearCode']
              : '';
          cityCode.value = firstCar['city'].isNotEmpty
              ? firstCar['city'][0]['cityCode']
              : '';

          await getBrandModel(brandCode1: brandCode.value);
          await getVehicleYear(
              brandCode: brandCode.value, brandModelCode: modelCode.value);
          selectedYearValue!.value = firstCar['modelYear'].isNotEmpty
              ? firstCar['modelYear'][0]["yearName"]
              : '';

          selectedBrandModel.value = firstCar['brandModel'][0]['modelName'];

          // vehicle info
          aboutCar.value = firstCar['about'] ?? '';
          transmission.value = firstCar['transmission'].isNotEmpty
              ? firstCar['transmission'][0]['transmissionName']
              : '';
          transmissionCode.value = firstCar['transmission'].isNotEmpty
              ? firstCar["transmission"][0]["transmissionCode"]
              : '';
          logger.log("transmission code:: ${transmissionCode.value}");

          selectedFeatures!.value = (firstCar['feature'] as List).isNotEmpty
              ? (firstCar['feature'] as List)
                  .map((feature) => feature['featuresName'])
                  .toList()
              : [];

          logger.log("features :: ${selectedFeatures!.value}");

          featuresCode.value = (firstCar['feature'] as List).isNotEmpty
              ? (firstCar['feature'] as List)
                  .map((feature) => feature['featuresCode'])
                  .toList()
              : [];

          logger.log("features code:: ${featuresCode.value}");

          if (carListData.document != null &&
              carListData.document!.isNotEmpty) {
            final licenseDocUrl = carListData.document![3].documentUrl;
            final inspectionDocUrl = carListData.document![1].documentUrl;
            final insuranceDocUrl = carListData.document![0].documentUrl;
            final roadWorthinessDocUrl = carListData.document![2].documentUrl;

            // vehicle License
            if (licenseDocUrl != null) {
              await downloadAndSaveFile(licenseDocUrl, 'vehicleLicense.png',
                  (filePath) {
                selectedPhotos.value = filePath;
                selectedPhotoName.value = 'vehicleLicense.png';
                realPhotoName.value = filePath.split('/').last;

                logger.log("extracted name: ${selectedPhotoName.value}");
              });
            }

            // vehicle inspection
            if (inspectionDocUrl != null) {
              await downloadAndSaveFile(
                  inspectionDocUrl, 'inspectionReport.png', (filePath) {
                selectedInspectionPhotos.value = filePath;
                selectedInspectionPhotoName.value = 'inspectionReport.png';
                realInspectionPhotoName.value = filePath.split('/').last;

                logger.log("extracted name: ${selectedInspectionPhotos.value}");
              });
            }

            // roadWorthiness
            if (roadWorthinessDocUrl != null) {
              await downloadAndSaveFile(
                  roadWorthinessDocUrl, 'roadWorthiness.png', (filePath) {
                selectedRoadWorthinessPhoto.value = filePath;
                realRoadWorthinessPhotoName.value = filePath.split('/').last;
                selectedRoadWorthinessPhotoName.value = 'roadWorthiness.png';

                logger.log(
                    "extracted name: ${selectedRoadWorthinessPhotoName.value}");
              });
            }

            insurance.value = carListData.insurance!.first.insuranceName!;
            insuranceCode.value = carListData.insurance!.first.insuranceCode!;

            // insurance photos
            if (insuranceDocUrl != null) {
              await downloadAndSaveFile(
                  insuranceDocUrl, 'insuranceCertificate.png', (filePath) {
                selectedInsurancePhotos.value = filePath;
                selectedInsurancePhotoName.value = 'insuranceCertificate.png';
                realInsurancePhotoName.value = filePath.split('/').last;

                logger.log("extracted name: ${selectedInsurancePhotos.value}");
              });
            }
            DateTime? licenseRawDate;
            DateTime? roadWorthinessRawDate;
            DateTime? insuranceRawDate;
            DateTime? inspectionRawDate;
            // documents expiry dates
            // license
            licenseRawDate = (carListData.document != null &&
                    carListData.document!.isNotEmpty
                ? carListData.document![3].expireDate
                : null)!;

            licenseExpiryDate.value = formatDate(licenseRawDate);
            // road worthiness
            roadWorthinessRawDate = (carListData.document != null &&
                    carListData.document!.isNotEmpty
                ? carListData.document![2].expireDate
                : null)!;
            roadWorthinessExpiryDate.value = formatDate(roadWorthinessRawDate);
            // insurance
            insuranceRawDate = (carListData.document != null &&
                    carListData.document!.isNotEmpty
                ? carListData.document![0].expireDate
                : null)!;
            insuranceExpiryDate.value = formatDate(insuranceRawDate);
            // inspection
            inspectionRawDate = (carListData.document != null &&
                    carListData.document!.isNotEmpty
                ? carListData.document![1].expireDate
                : null)!;
            inspectionExpiryDate.value = formatDate(inspectionRawDate);
          }

          // selectedInspectionPhotos.value =
          //     firstCar['document'][0]["documentURL"];
          // // availability
          if (firstCar['startDate'] != null &&
              firstCar['startDate'].isNotEmpty) {
            startDateTime.value = isSingleDateSelection(
                date: DateTime.parse(firstCar['startDate'] ?? ''));

            rawStartTime = DateTime.parse(firstCar['startDate'] ?? '');

            endDateTime.value = isSingleDateSelection(
                date: DateTime.parse(firstCar['endDate'] ?? ''));
            rawEndTime = DateTime.parse(firstCar['endDate'] ?? '');
          }
          advanceTime.value = firstCar['advanceDays'] ?? '';
          pricePerDay.value = firstCar['pricePerDay'] ?? '';
          discountDays.value = firstCar['discountDays'] ?? '';
          // discountNoOfDays
          discountPrice.value = firstCar['discountPrice'] ?? '';
          selectedView.value = firstCar["driver"].isNotEmpty
              ? firstCar["driver"][0]["fullName"]
              : '';
          // TODO:
          selectedDriverId.value = (carListData.driver!.isNotEmpty
              ? carListData.driver!.first.driverID
              : '')!;

          await getCity(cityCode1: stateCode.value);

          vehicleType.value = firstCar["type"].isNotEmpty
              ? firstCar["type"][0]["typeName"]
              : '';
          numberOfSeats.value = firstCar["seat"].isNotEmpty
              ? firstCar["seat"][0]["seatName"]
              : '';
          vehicleTypeCode.value = firstCar["type"].isNotEmpty
              ? firstCar["type"][0]["typeCode"]
              : '';
          vehicleSeatCode.value = firstCar["seat"].isNotEmpty
              ? firstCar["seat"][0]["seatCode"]
              : '';

          apiFetchedPhotos.assignAll(carListData.photo ?? []);
          logger.log("photos:: ${apiFetchedPhotos}");
          logger.log("photos:: ${carListData.photo!.length}");

          logger.log("car history $carHistory");
          isFetchingCarDetails.value = false;
        } else {
          showSuccessSnackbar(message: 'no data');
        }
      } else {
        logger.log("unable to get car history ${response.data}");
      }
    } catch (exception) {
      logger.log("get car history error  $exception");
    } finally {
      isFetchingCarDetails.value = false;
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void dispose() {
    selectedValue1 = 'Select'; // Set it back to the default value
    super.dispose();
  }
}
