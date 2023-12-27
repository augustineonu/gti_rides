import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/search/filter_options_model.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/constants.dart';

class SearchFilterController extends GetxController {
  Logger logger = Logger("Controller");

  SearchFilterController() {
    init();
  }

  void init() {
    logger.log("SearchFilterController Initialized");
  }

  @override
  void onInit() async {
    update();

    super.onInit();
  }

  // input fields
  TextEditingController fromAmount = TextEditingController();
  TextEditingController toAmount = TextEditingController();

  //           variables

  // strings
  Rx<String> testString = "Hello".obs;
  // booleans
  RxBool isLoading = false.obs;
  RxBool selectedChauffeur = false.obs;
  RxBool selectedSelfDrive = false.obs;
  RxBool selectedInterState = false.obs;
  RxBool selectedIntraState = false.obs;
  RxBool selectedSortby = false.obs;
  RxBool selectedCarType = false.obs;
  RxBool selectedVehicleBrand = false.obs;
  RxBool selectedVehicleModel = false.obs;
  RxBool selectedCarSeat = false.obs;
  RxBool selectedCategory = false.obs;
  RxBool selectedTransmission = false.obs;

  // integers
  RxInt selectedCheckboxes = 0.obs;
  RxInt selectedCarTypes = 0.obs;
  RxInt selectedVehicleBrands = 0.obs;
  RxInt selectedVehicleModels = 0.obs;
  RxInt selectedCarSeats = 0.obs;
  RxInt selectedCategories = 0.obs;
  RxInt selectedTransmissions = 0.obs;

  final List<String> sortByList = [
    AppStrings.relevance,
    AppStrings.distanceAway,
    AppStrings.pricePerDayH,
    AppStrings.pricePerDayL,

    // Add more options here
  ];
  List<FilterOptions> filterOptionsList = [
    FilterOptions(
        title: AppStrings.featuresCaps, subTitle: AppStrings.allFeatures),
    FilterOptions(
        title: AppStrings.vehicleTypeCaps, subTitle: AppStrings.allTypes),
    FilterOptions(
        title: AppStrings.vehicleBrandCaps, subTitle: AppStrings.allBrand),
    FilterOptions(title: AppStrings.model, subTitle: AppStrings.allBrand),
    FilterOptions(title: AppStrings.carSeat, subTitle: AppStrings.allSeat),
    FilterOptions(title: AppStrings.categoryCaps, subTitle: AppStrings.allCars),
    FilterOptions(
        title: AppStrings.transmissionCaps,
        subTitle: AppStrings.allTransmission),
  ];

  List<String> carTypes = [
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

  List<String> categories = [
    AppStrings.allCars,
    AppStrings.everydayDrivers,
    AppStrings.upscale,
    AppStrings.fastAndFun,
    AppStrings.backreadsReady,
    AppStrings.familyFriendly,
    AppStrings.convertibles,
    AppStrings.latestModels,
    AppStrings.elite,
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
  
  
  // methods
  void goBack() => routeService.goBack();

  void onChauffeurSelected(bool value) => selectedChauffeur.value = value;
  void onSelectSelfDrive(bool value) => selectedSelfDrive.value = value;
  void onSelectInterState(bool value) => selectedInterState.value = value;
  void onSelectIntraState(bool value) => selectedIntraState.value = value;

  void onSelectSortBy(int index) => selectedCheckboxes.value = index;
  void onCarTypeChecked(int index) => selectedCarTypes.value = index;
  void onVehicleBrandChecked(int index) => selectedVehicleBrands.value = index;
  void onVehicleModelChecked(int index) => selectedVehicleModels.value = index;
  void onCarSeatChecked(int index) => selectedCarSeats.value = index;
  void onCategoryChecked(int index) => selectedCategories.value = index;
  void onTransmissionChecked(int index) => selectedTransmissions.value = index;

  String onSelectFilterOptions() {
    switch (filterOptionsList.length) {
      case 0:
        return AppStrings.relevance;
      case 1:
        return AppStrings.distanceAway;
      case 2:
        return AppStrings.pricePerDayH;
      case 3:
        return AppStrings.pricePerDayL;

      default:
        return '';
    }
  }
}
