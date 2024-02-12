import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/drivers_model.dart' as driver;
import 'package:gti_rides/models/image_response.dart';
import 'package:gti_rides/models/list_response_model.dart';
import 'package:gti_rides/models/partner/car_list_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/Partner/home/list_vehicle/list_vehicle_screen.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

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
  Rx<String> discountNoOfDays = ''.obs;
  Rx<String> selectedDriverId = ''.obs;
  Rx<String> carID = ''.obs;
  Rx<String> selectedPhotos = ''.obs;
  Rx<String> selectedPhotoName = ''.obs;
  Rx<String> selectedRoadWorthinessPhoto = ''.obs;
  Rx<String> selectedRoadWorthinessPhotoName = ''.obs;
  Rx<String> selectedInsurancePhotos = ''.obs;
  Rx<String> selectedInsurancePhotoName = ''.obs;
  Rx<String> selectedInspectionPhotos = ''.obs;
  Rx<String> selectedInspectionPhotoName = ''.obs;
  RxList<String> selectedVehiclePhotos = <String>[].obs;
  Rx<String> selectedVehiclePhoto = ''.obs;
  Rx<String> userVin = ''.obs;
  Rx<String> plateNumber = ''.obs;
  Rx<String> state = ''.obs;
  Rx<String> city = ''.obs;
  Rx<String> brandName = ''.obs;

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
  Rx<String> advanceAmount = ''.obs;
  RxInt initiPageIndex = 1.obs;

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
      carID.value = arguments['carID'];
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
    // Access the arguments using Get.arguments

    // if (isFromManageCars.value == true) {
    //   currentIndex.value = 1;
    //   pageController = PageController(initialPage: currentIndex.value);
    //   // pageController.addListener(() {
    //     // currentIndex.value = pageController.page?.round() ?? 0;
    //     update();
    //   // });
    // }
  }

  @override
  void onInit() async {
    logger.log("ListVehicleController");
    super.onInit();

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
      selectedPhotoName.value = response.imagePath.split('/').last;
      selectedPhotos.value = (response.imagePath);
      logger.log("image path :: ${selectedPhotoName.value}");
      // Extract the directory and file name
      int lastSeparator = selectedPhotos.value.lastIndexOf('/');
      String directory = lastSeparator != -1
          ? selectedPhotos.value.substring(0, lastSeparator)
          : selectedPhotos.value;
      selectedPhotoName.value = 'vehicleLicense.png';

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

  // Future<void> openGallery1() async {
  //   ImageResponse? response =
  //       await imageService.pickImage(source: ImageSource.gallery);
  //   if (response != null) {
  //     logger.log("Picked image $selectedPhotoName");
  //     selectedPhotoName.value = response.imagePath.split('/').last;
  //     selectedPhotos.value = (response.imagePath);
  //     routeService.goBack;
  //   }
  // }

  Future<void> openGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      logger.log("Picked image ${selectedPhotoName.value}");
      selectedPhotos.value = response.imagePath;

      // Extract the directory and file name
      int lastSeparator = selectedPhotos.value.lastIndexOf('/');
      String directory = lastSeparator != -1
          ? selectedPhotos.value.substring(0, lastSeparator)
          : selectedPhotos.value;

      selectedPhotoName.value = 'vehicleLicense.png';

      // Build the new path with the desired file name
      String newPath = '$directory/$selectedPhotoName';
      logger.log("Picked new path $newPath");

      // Rename the file
      File(selectedPhotos.value).renameSync(newPath);

      // Now update the selectedPhotos value
      selectedPhotos.value = newPath;
      logger.log("selected photo ${selectedPhotos.value}");
      routeService.goBack;
    }
  }

  Future<void> openRoadWorthinessCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      selectedRoadWorthinessPhoto.value = response.imagePath;
      selectedRoadWorthinessPhotoName.value =
          response.imagePath.split('/').last;

      int lastSeparator = selectedRoadWorthinessPhoto.value.lastIndexOf('/');
      String directory = lastSeparator != -1
          ? selectedRoadWorthinessPhoto.value.substring(0, lastSeparator)
          : selectedRoadWorthinessPhoto.value;
      selectedRoadWorthinessPhotoName.value = 'roadWorthiness.png';

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

  Future<void> openRoadWorthinessGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      selectedRoadWorthinessPhoto.value = response.imagePath;
      logger.log(
          "selectedRoadWorthinessPhoto: ${selectedRoadWorthinessPhoto.value}");
      selectedRoadWorthinessPhotoName.value =
          response.imagePath.split('/').last;

      int lastSeparator = selectedRoadWorthinessPhoto.value.lastIndexOf('/');
      String directory = lastSeparator != -1
          ? selectedRoadWorthinessPhoto.value.substring(0, lastSeparator)
          : selectedRoadWorthinessPhoto.value;
      selectedRoadWorthinessPhotoName.value = 'roadWorthiness.png';

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

  Future<void> openInsuranceCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      selectedInsurancePhotos.value = response.imagePath;
      selectedInsurancePhotoName.value = response.imagePath.split('/').last;

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

  Future<void> openInsuranceGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      selectedInsurancePhotos.value = response.imagePath;
      selectedInsurancePhotoName.value = response.imagePath.split('/').last;

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

  Future<void> openInspectionCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      selectedInspectionPhotos.value = (response.imagePath);
      selectedInspectionPhotoName.value = (response.imagePath).split('/').last;

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

  Future<void> openInspectionGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      selectedInspectionPhotos.value = (response.imagePath);
      selectedInspectionPhotoName.value = (response.imagePath).split('/').last;

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

  Future<void> openVehiclePhotoCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      selectedVehiclePhotos.add(response.imagePath);
      selectedVehiclePhoto.value = response.imagePath;
    }
  }

  Future<void> openVehiclePhotoGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      selectedVehiclePhotos.add(response.imagePath);
      selectedVehiclePhoto.value = (response.imagePath);
      routeService.goBack;
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
      logger.log("error  $exception");
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
          logger.log("msg ${brands.value.data}");
        } else {
          logger.log("no vehicle year ${response.data}");
        }
      } else {
        logger.log("unable to get vehicle year ${response.data}");
        showErrorSnackbar(message: response.message!);
        isGettingyear.value = false;
      }
    } catch (exception) {
      logger.log("error  $exception");
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
      logger.log("error  $exception");
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
      logger.log("error  $exception");
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
      logger.log("error  $exception");
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
          logger.log("msg ${transmissions?.value}");
        }
      } else {
        logger.log("unable to get transmission ${response.data}");
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("error  $exception");
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
          logger.log("msg ${carFeatures?.value}");
        }
      } else {
        logger.log("unable to car features ${response.data}");
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("error  $exception");
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
          logger.log("msg ${vehicleTypes?.value}");
        }
      } else {
        logger.log("unable to vehicle Types ${response.data}");
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("error  $exception");
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
      logger.log("error  $exception");
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
      logger.log("error  $exception");
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
      logger.log("error  $exception");
    }
  }

  Future<void> addCar() async {
    if (!vehicleTypeFormKey.currentState!.validate()) {
      return;
    }
    if(selectedBrandModel.value == 'Select' || selectedYearValue!.value == 'Select'){
      showErrorSnackbar(message: 'All fields must be selected');
      return;
    }

    try {
      isLoading.value = true;
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
          // cities?.value = response.data!;
          logger.log("carID ${brands.value.data}");
          carID.value = response.data!["carID"];
          showSuccessSnackbar(message: response.message!);
          goToNextPage();
          // getCarHistory();
        }
      } else {
        logger.log("unable to add car${response.data}");
        isLoading.value = false;
        showErrorSnackbar(message: response.message.toString());
      }
    } catch (exception) {
      logger.log("error  $exception");
      showErrorSnackbar(message: exception.toString());
    } finally {
      isLoading.value = false;
    }
  }
    ScrollController scrollController = ScrollController();


  void goToNextPage() {
    currentIndex.value++;
    scrollController.position.maxScrollExtent;
    pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
 
 
  }

  Future<void> addCarInfo() async {
    if (!vehicleInfoFormKey.currentState!.validate()) {
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
      logger.log("error  $exception");
      showErrorSnackbar(message: exception.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCarAvailability() async {
     if (!availabilityFormKey.currentState!.validate()) {
      return;
    }
    if(selectedView.value == 'select'){
      showErrorSnackbar(message: 'Kindly select a driver');
    }
    try {
      isLoading1.value = true;
      final response = await partnerService.addCarAvailability(
          payload: {
            "startDate": startDateTime.value,
            "endDate": endDateTime.value,
            "advanceDays": advanceAmount.value,
            "pricePerDay": rentPerDayController.text,
            "discountDays": discountNoOfDays.value,
            "discountPrice": discountPerDayController.text,
            "driverID": selectedDriverId.value
          },
          // {
          //   "startDate": startDateTime.value,
          //   "endDate": endDateTime.value,
          //   "advanceDays": advanceAmount,
          //   "pricePerDay": rentPerDayController.text,
          //   "discountDays": discountNoOfDays.value,
          //   "discountPrice": discountPerDayController.text,
          //   "driverID": selectedDriverId.value
          // },
          carID: carID.value);

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
      logger.log("error  $exception");
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
    if (selectedVehiclePhotos.isEmpty) {
      // Show an error message or handle it accordingly
      showErrorSnackbar(message: 'Please upload an image.');
      return false;
    } else if (selectedVehiclePhotos.length < 6) {
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

        showSuccessSnackbar(message: response.message!);
        goToNextPage();
        // getCarHistory();
      } else {
        logger.log("unable to add document ${response.data}");
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
      logger.log("error  $exception");
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

  Future<void> getCarHistory() async {
    isFetchingCarDetails.value = true;

    try {
      final response = await partnerService.getOnCar(carId: carID.value);

      if (response.status == 'success' || response.status_code == 200) {
        final carData = response.data;

        logger.log("gotten car history $carData");

        if (carData != null && carData.isNotEmpty) {
          carHistory.value = carData;

          isFetchingCarDetails.value = false;

          final firstCar = carData.first;

          userVin.value = firstCar['vin'];
          plateNumber.value = firstCar['plateNumber'];
          state.value = firstCar['state'][0]["stateName"];
          city.value = firstCar['city'].isNotEmpty
              ? firstCar['city'][0]["cityName"]
              : "";
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

          await getBrandModel(brandCode1: brandCode.value);
          await getVehicleYear(
              brandCode: brandCode.value, brandModelCode: modelCode.value);
          selectedYearValue!.value = firstCar['modelYear'][0]["yearName"];

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

          // documentation
          insurance.value = firstCar["insurance"].isNotEmpty
              ? firstCar["insurance"][0]["insuranceName"]
              : '';
          //4
          final inspectionDocUrl = firstCar["document"].isNotEmpty
              ? firstCar['document'][0]["documentURL"]
              : null;
          //2
          final roadWorthinessDocUrl = firstCar["document"].isNotEmpty
              ? firstCar['document'][1]["documentURL"]
              : null;
          // 1
          final licenseDocUrl = firstCar["document"].isNotEmpty
              ? firstCar['document'][2]["documentURL"]
              : null;
          //3
          final insuranceDocUrl = firstCar["document"].isNotEmpty
              ? firstCar['document'][3]["documentURL"]
              : null;

          selectedInspectionPhotos.value =
              extractDocumentName(inspectionDocUrl);
          selectedInspectionPhotoName.value = selectedInspectionPhotos.value;

          selectedRoadWorthinessPhoto.value =
              extractDocumentName(roadWorthinessDocUrl);
          selectedRoadWorthinessPhotoName.value =
              selectedRoadWorthinessPhoto.value;
          selectedPhotos.value = extractDocumentName(licenseDocUrl);
          selectedPhotoName.value = selectedPhotos.value;

          selectedInsurancePhotos.value = extractDocumentName(insuranceDocUrl);
          selectedInsurancePhotoName.value = selectedInsurancePhotos.value;

          logger.log("Document: ${selectedInspectionPhotos.value} ");

          // selectedInspectionPhotos.value =
          //     firstCar['document'][0]["documentURL"];
          // // availability
          startDateTime.value = firstCar['startDate'] ?? '';
          endDateTime.value = firstCar['endDate'] ?? '';
          advanceAmount.value = firstCar['advanceDays'] ?? '';
          pricePerDay.value = firstCar['pricePerDay'] ?? '';
          discountDays.value = firstCar['discountDays'] ?? '';
          discountPrice.value = firstCar['discountPrice'] ?? '';
          selectedView.value = firstCar["driver"].isNotEmpty
              ? firstCar["driver"][0]["fullName"]
              : '';

          await getCity(cityCode1: stateCode.value);

          vehicleType.value = firstCar["type"].isNotEmpty
              ? firstCar["type"][0]["typeName"]
              : '';
          numberOfSeats.value = firstCar["seat"].isNotEmpty
              ? firstCar["seat"][0]["seatName"]
              : '';
          vehicleTypeCode.value =
              firstCar["type"] ? firstCar["type"][0]["typeCode"] : '';
          vehicleSeatCode.value = firstCar["seat"].isNotEmpty
              ? firstCar["seat"][0]["seatCode"]
              : '';

          logger.log("car history $carHistory");
        } else {
          showSuccessSnackbar(message: 'no data');
        }
      } else {
        logger.log("unable to get car history ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
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
