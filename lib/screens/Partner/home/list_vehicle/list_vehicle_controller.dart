import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/models/image_response.dart';
import 'package:gti_rides/models/list_response_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/Partner/home/list_vehicle/list_vehicle_screen.dart';
import 'package:gti_rides/screens/shared_screens/more/drivers/drivers_controller.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class ListVehicleController extends GetxController {
  Logger logger = Logger("Controller");

  // var data = Get.find<DriversController>();

  Rx<ListResponseModel> brands = ListResponseModel().obs;
  RxList<dynamic>? vehicleYear = <dynamic>[].obs;
  RxList<dynamic>? states = <dynamic>[].obs;
  RxList<dynamic>? cities = <dynamic>[].obs;
  RxList<dynamic>? transmissions = <dynamic>[].obs;
  RxList<String>? selectedFeatures = <String>[].obs;
  RxList<dynamic>? carFeatures = <dynamic>[].obs;
  RxList<dynamic>? vehicleTypes = <dynamic>[].obs;
  RxList<dynamic>? vehicleSeats = <dynamic>[].obs;
  RxList<dynamic>? insurances = <dynamic>[].obs;
  RxList<dynamic>? drivers = <dynamic>[].obs;
  RxList<dynamic>? cars = <dynamic>[].obs;

  RxBool isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  RxBool isGettingBrands = false.obs;
  RxBool isAddingCar = false.obs;
  PageController pageController = PageController();
  RxInt currentIndex = 0.obs;
  RxString phoneCode = '1'.obs;
  RxString flagEmoji = '🇺🇸'.obs;
  RxString brandCode = ''.obs;
  RxString modelCode = ''.obs;
  RxString yearCode = ''.obs;
  RxString vehicleTypeCode = ''.obs;
  RxString vehicleSeatCode = ''.obs;
  RxString stateCode = ''.obs;
  RxString cityCode = ''.obs;
  RxString transmissionCode = ''.obs;
  RxList<String> featuresCode = <String>[].obs;
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

  GlobalKey<FormState> vehicleTypeFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> vehicleInfoFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> documentationFormKey = GlobalKey<FormState>();

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
  TextEditingController advanceAmountController = TextEditingController();
  TextEditingController rentPerDayController = TextEditingController();
  TextEditingController discountPerDayController = TextEditingController();
  TextEditingController aboutVehicleController = TextEditingController();

  ListVehicleController() {
    init();
  }

  void init() async {
    logger.log("ListVehicleController Initialized");
    await getBrands();
    await getStates();
    await getTransmission();
    await getCarFeatures();
    await getVehicleType();
    await getVehicleSeats();
    await getDrivers();
    await getInsuranceType();
    logger.log("oooooooooo");
    // Access the arguments using Get.arguments
    Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null) {
      startDateTime.value = arguments['start'] ?? 'hmm';
      endDateTime.value = arguments['end'] ?? 'woo';

      // Now you have access to the passed data (emailOrPhone)
      logger.log('Received data: $arguments');
    }
  }

  @override
  void onInit() async {
    logger.log("ListVehicleController oninti called");
    pageController.addListener(() {
      currentIndex.value = pageController.page?.round() ?? 0;
      update();
    });
    super.onInit();
    // await getBrands();
    // Access the arguments using Get.arguments
    // Map<String, dynamic>? arguments = Get.arguments;

    // if (arguments != null ) {
    //   startDateTime.value = arguments['start'];
    //   endDateTime.value = arguments['end'];

    //   // Now you have access to the passed data (emailOrPhone)
    //   logger.log('Received data: $arguments');
    // }
    // logger.log('Received data1: $arguments');
  }

  // variables

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

  // List<String> transmissions = [
  //   AppStrings.allTransmission,
  //   AppStrings.manual,
  //   AppStrings.automatic,
  // ];

  List<String> features = [
    AppStrings.allFeatures,
    AppStrings.wheelchairAccessible,
    AppStrings.allWheelDrive,
    AppStrings.androidAuto,
    AppStrings.androidAuto,
    AppStrings.appleCarPlay,
    AppStrings.auxInput,
    AppStrings.backupCamera,
    AppStrings.bikeRack,
    AppStrings.blindSpotWarning,
    AppStrings.bluetooth,
    AppStrings.childSeat,
    AppStrings.convertible,
    AppStrings.gps,
    AppStrings.heatedSeats,
    AppStrings.keylessEntry,
    AppStrings.petFriendly,
    AppStrings.skiRack,
    AppStrings.snowTiresChains,
    AppStrings.sunroof,
    AppStrings.usbCharger,
    AppStrings.usbInput,
  ];

  List<String> vehicleTypes1 = [
    AppStrings.allTypes,
    AppStrings.cars,
    AppStrings.suvs,
    AppStrings.minivans,
    AppStrings.trucks,
    AppStrings.vans,
    AppStrings.cargoVans,
  ];
  List<String> vehicleSeats1 = [
    AppStrings.allSeat,
    AppStrings.fourOrMore,
    AppStrings.fiveOrMore,
    AppStrings.sixOrMore,
    AppStrings.sevenOrMore,
    AppStrings.eightOrMore,
    AppStrings.nineOrMore,
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
  ValueNotifier<Fruit> selectedItem = ValueNotifier<Fruit>(Fruit.apple);
  Rx<Driver> selectedItem1 = Rx<Driver>(
    Driver(
      fullName: 'John Doe',
      driverEmail: '08180065778 | johndoe@gmail.com',
    ),
  );

// routing methods
  void goBack() => routeService.goBack();
  void goBack1() => routeService.goBack(closeOverlays: true);
  void routeToCreateDriver() => routeService.gotoRoute(AppLinks.addDriver);
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
    }
  }

  Future<void> openGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      logger.log("Picked image $selectedPhotoName");
      selectedPhotoName.value = response.imagePath.split('/').last;
      selectedPhotos.value = (response.imagePath);
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
    }
  }

  Future<void> openRoadWorthinessGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      selectedRoadWorthinessPhoto.value = response.imagePath;
      selectedRoadWorthinessPhotoName.value =
          response.imagePath.split('/').last;

      routeService.goBack;
    }
  }

  Future<void> openInsuranceCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      selectedInsurancePhotos.value = response.imagePath;
      selectedInsurancePhotoName.value = response.imagePath.split('/').last;
    }
  }

  Future<void> openInsuranceGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      selectedInsurancePhotos.value = (response.imagePath);
      selectedInsurancePhotoName.value = response.imagePath.split('/').last;
      routeService.goBack;
    }
  }

  Future<void> openInspectionCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      selectedInspectionPhotos.value = (response.imagePath);
      selectedInspectionPhotoName.value = (response.imagePath).split('/').last;
    }
  }

  Future<void> openInspectionGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      selectedInspectionPhotos.value = (response.imagePath);
      selectedInspectionPhotoName.value = (response.imagePath).split('/').last;
      routeService.goBack;
    }
  }

  Future<void> openVehiclePhotoCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      selectedVehiclePhotos.add(response.imagePath);
    }
  }

  Future<void> openVehiclePhotoGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      selectedVehiclePhotos.add(response.imagePath);
      routeService.goBack;
    }
  }

  // Function(List<String>) onChanged(){
  //   controller.selectedFeatures!.value
  // }

  Future<void> getBrands() async {
    try {
      isGettingBrands.value = true;
      final response = await partnerService.getBrand();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten brands ${response.data}");
        if (response.data != null && response.data != []) {
          brands.value.data = response.data;
          logger.log("msg ${brands.value.data}");
        }
      } else {
        logger.log("unable to get brands ${response.data}");
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("error  $exception");
    }
  }

  Future<void> getVehicleYear(
      {required String brandCode, required String brandModelCode}) async {
    try {
      isGettingBrands.value = true;
      final response = await partnerService.getVehicleYear(
          brandCode: brandCode, brandModelCode: brandModelCode);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten vehicle year ${response.data}");
        if (response.data != null && response.data != []) {
          vehicleYear?.value = response.data!;
          logger.log("msg ${brands.value.data}");
        }
      } else {
        logger.log("unable to get vehicle year ${response.data}");
        showErrorSnackbar(message: response.message!);
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("error  $exception");
    }
  }

  Future<void> getBrandModel({required String brandCode1}) async {
    try {
      isGettingBrands.value = true;
      final response =
          await partnerService.getBrandModel(brandCode: brandCode1);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten brand model ${response.data}");
        if (response.data != null && response.data != []) {
          // vehicleYear?.value = response.data!;
          logger.log("brand model ${response.data}");
          brandCode.value = response.data!.first!["brandCode"];
          modelCode.value = response.data!.first!["modelCode"];

          await getVehicleYear(
              brandModelCode: modelCode.value, brandCode: brandCode.value);
        }
      } else {
        logger.log("unable to get brand model ${response.data}");
        showErrorSnackbar(message: response.message!);
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("error  $exception");
    }
  }

  Future<void> getStates() async {
    try {
      isGettingBrands.value = true;
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
      isGettingBrands.value = true;
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
      isGettingBrands.value = true;
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
      isGettingBrands.value = true;
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
      isGettingBrands.value = true;
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
      isGettingBrands.value = true;
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
      isGettingBrands.value = true;
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
      isGettingBrands.value = true;
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
      });
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("car added ${response.data}");
        if (response.data != null) {
          // cities?.value = response.data!;
          logger.log("carID ${brands.value.data}");
          carID.value = response.data!["carID"];
          showSuccessSnackbar(message: response.message!);
          pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
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
        pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
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
    try {
      isLoading1.value = true;
      final response = await partnerService.addCarAvailability(payload: {
        "startDate": startDateTime.value,
        "endDate": endDateTime.value,
        "advanceDays": advanceAmountController.text,
        "pricePerDay": rentPerDayController.text,
        "discountDays": discountNoOfDays.value,
        "discountPrice": discountPerDayController.text,
        "driverID": selectedDriverId.value
      }, carID: carID.value);

      if (response.status == 'success' || response.status_code == 200) {
        logger.log("added availability ${response.data}");
          showSuccessSnackbar(message: response.message!);
       successDialog(title: AppStrings.vehicleInfoSubmitted,
        body: AppStrings.thankYouForYourPatience,
         buttonTitle: AppStrings.home, onTap: (){
          routeService.goBack(closeOverlays: true);
         });
       
      } else {
        logger.log("unable to get drivers ${response.data}");
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

  Future<void> addCarDocument() async {
    if (!documentationFormKey.currentState!.validate() ||
        !validateImageUpload()) {
      return;
    }
    try {
      isLoading.value = true;
      var data1 = dio.FormData.fromMap({});
      Future<dio.FormData> constructFormData() async {
        data1.fields.addAll([
          MapEntry(
            'document',
            (await dio.MultipartFile.fromFile(
              selectedPhotos.value,
              filename: selectedPhotos.value,
            ))
                .toString(),
          ),
          MapEntry(
            'vehicleLicense',
            (await dio.MultipartFile.fromFile(
              selectedPhotos.value,
              filename: selectedPhotos.value,
            ))
                .toString(),
          ),
          MapEntry(
            'roadWorthiness',
            (await dio.MultipartFile.fromFile(
              selectedRoadWorthinessPhoto.value,
              filename: selectedRoadWorthinessPhoto.value,
            ))
                .toString(),
          ),
          MapEntry(
            'insuranceCertificate',
            (await dio.MultipartFile.fromFile(
              selectedInsurancePhotos.value,
              filename: selectedInsurancePhotos.value,
            ))
                .toString(),
          ),
          MapEntry(
            'inspectionReport',
            (await dio.MultipartFile.fromFile(
              selectedInspectionPhotos.value,
              filename: selectedInspectionPhotos.value,
            ))
                .toString(),
          ),
          MapEntry('insuranceType', insuranceCode.value)
        ]);

        logger.log("form field ${data1.length}");
        return data1;
      }

      final formData = await constructFormData();
      final response = await partnerService.addCarDocument(
          payload: formData, carID: carID.value);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("car document added ${response.data}");

        showSuccessSnackbar(message: response.message!);
        pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
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
    try {
      isLoading.value = true;
      var data = dio.FormData();
      Future<dio.FormData> constructFormData() async {
        // List<dio.MultipartFile> files = [];
        final formData = dio.FormData();

        for (var filePath in selectedVehiclePhotos) {
          formData.files.add(
            // await dio.MultipartFile.fromFile(filePath, filename: filePath)
            MapEntry(
                'photo',
                (await dio.MultipartFile.fromFile(
                  filePath,
                  filename: filePath,
                ))),
          );
        }

        data = dio.FormData.fromMap({
          'photo': formData,
        });

        logger.log("form field ${data.length}");
        return data;
      }

      final formData = await constructFormData();
      final response = await partnerService.addCarPhoto(
          payload: formData, carID: carID.value);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("car photos added ${response.message}");
        showSuccessSnackbar(message: response.message!);
        pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      } else {
        logger.log("unable to add car photos ${response.data}");
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

  

}
