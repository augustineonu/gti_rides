import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/models/list_response_model.dart';
import 'package:gti_rides/screens/Partner/home/list_vehicle/list_vehicle_screen.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/constants.dart';

class ListVehicleController extends GetxController {
  Logger logger = Logger("Controller");

  Rx<ListResponseModel> brands = ListResponseModel().obs;
  RxList<dynamic>? vehicleYear = <dynamic>[].obs;
  RxList<dynamic>? states = <dynamic>[].obs;
  RxList<dynamic>? cities = <dynamic>[].obs;
  RxList<dynamic>? transmissions = <dynamic>[].obs;
  RxList<String>? selectedFeatures = <String>[].obs;
  RxList<dynamic>? carFeatures = <dynamic>[].obs;
  RxList<dynamic>? vehicleTypes = <dynamic>[].obs;

  RxBool isLoading = false.obs;
  RxBool isGettingBrands = false.obs;
  RxBool isAddingCar = false.obs;
  PageController pageController = PageController();
  RxInt currentIndex = 0.obs;
  RxString phoneCode = '1'.obs;
  RxString flagEmoji = '🇺🇸'.obs;
  RxString brandCode = ''.obs;
  RxString yearCode = ''.obs;
  RxString stateCode = ''.obs;
  RxString cityCode = ''.obs;
  RxString transmissionCode = ''.obs;

  GlobalKey<FormState> vehicleTypeFormKey = GlobalKey<FormState>();

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

  ListVehicleController() {
    init();
  }

  void init() async {
    logger.log("ListVehicleController Initialized");
    await getBrands();
    await getStates();
    await getTransmission();
    await getCarFeatures();
  }

  @override
  void onInit() async {
    pageController.addListener(() {
      currentIndex.value = pageController.page?.round() ?? 0;
      update();
    });
    super.onInit();
    // await getBrands();
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
  List<String> vehicleSeats = [
    AppStrings.allSeat,
    AppStrings.fourOrMore,
    AppStrings.fiveOrMore,
    AppStrings.sixOrMore,
    AppStrings.sevenOrMore,
    AppStrings.eightOrMore,
    AppStrings.nineOrMore,
  ];

  List<Map<String, dynamic>> drivers = [
    {
      'name': 'John Doe',
      'details': '08180065778 | johndoe@gmail.com',
    },
    {
      'name': 'Pascal Odi',
      'details': '08180065778 | johndoe@gmail.com',
    },
    {
      'name': 'Mbang Ade',
      'details': '08180065778 | johndoe@gmail.com',
    },
    {
      'name': 'Mbang Ade',
      'details': '08180065778 | johndoe@gmail.com',
    },
    {
      'name': 'Mbang Ade',
      'details': '08180065778 | johndoe@gmail.com',
    },
    {
      'name': 'Mbang Ade',
      'details': '08180065778 | johndoe@gmail.com',
    },
  ];

  RxString selectedView = 'select'.obs;
  ValueNotifier<Fruit> selectedItem = ValueNotifier<Fruit>(Fruit.apple);
  Rx<Driver> selectedItem1 = Rx<Driver>(
    Driver(
      name: 'John Doe',
      details: '08180065778 | johndoe@gmail.com',
    ),
  );

// routing methods
  void goBack() => routeService.goBack();

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

  Future<void> getVehicleYear({required String brandCode}) async {
    try {
      isGettingBrands.value = true;
      final response =
          await partnerService.getVehicleYear(brandCode: brandCode);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten vehicle year ${response.data}");
        if (response.data != null && response.data != []) {
          vehicleYear?.value = response.data!;
          logger.log("msg ${brands.value.data}");
        }
      } else {
        logger.log("unable to get vehicle year ${response.data}");
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

  Future<void> getCity({required String cityCode}) async {
    try {
      isGettingBrands.value = true;
      final response = await partnerService.getCity(cityCode: cityCode);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten cities ${response.data}");
        if (response.data != null && response.data != []) {
          cities?.value = response.data!;
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

  Future<void> addCar() async {
    try {
      isAddingCar.value = true;
      final response = await partnerService.addCar(data: {
        "brandCode": brandCode.value,
        "yearCode": yearCode.value,
        "vin": vinController.text,
        "plateNumber": plateNumberController.text,
        "stateCode": stateCode.value,
        "cityCode": cityCode.value,
      });
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten cities ${response.data}");
        if (response.data != null && response.data != []) {
          cities?.value = response.data!;
          logger.log("cities ${brands.value.data}");
        }
      } else {
        logger.log("unable to get city ${response.data}");
        isAddingCar.value = false;
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
          logger.log("msg ${brands.value.data}");
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
          logger.log("msg ${brands.value.data}");
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
          logger.log("msg ${brands.value.data}");
        }
      } else {
        logger.log("unable to vehicle Types ${response.data}");
        isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("error  $exception");
    }
  }
}
