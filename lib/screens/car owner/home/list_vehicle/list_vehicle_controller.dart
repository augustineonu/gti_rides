import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/screens/car%20owner/home/list_vehicle/list_vehicle_screen.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/constants.dart';

class ListVehicleController extends GetxController {
  Logger logger = Logger("Controller");
  RxBool isLoading = false.obs;
  PageController pageController = PageController();
  RxInt currentIndex = 0.obs;
  RxString phoneCode = '1'.obs;
  RxString flagEmoji = '🇺🇸'.obs;

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

  ListVehicleController() {
    init();
  }

  void init() {
    logger.log("ListVehicleController Initialized");
  }

  @override
  void onInit() async {
    pageController.addListener(() {
      currentIndex.value = pageController.page?.round() ?? 0;
      update();
    });
    super.onInit();
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

  List<String> transmissions = [
    AppStrings.allTransmission,
    AppStrings.manual,
    AppStrings.automatic,
  ];

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

  List<String> vehicleTypes = [
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
ValueNotifier<Fruit> selectedItem =  ValueNotifier<Fruit>(Fruit.apple);
Rx<Driver> selectedItem1 =  Rx<Driver>( Driver(
    name: 'John Doe',
    details: '08180065778 | johndoe@gmail.com',
  ),);

// routing methods
  void goBack() => routeService.goBack();
}
