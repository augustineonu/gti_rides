import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/brand_model.dart';
import 'package:gti_rides/models/car_features.dart';
import 'package:gti_rides/models/search/filter_options_model.dart';
import 'package:gti_rides/models/vehicle_brand.dart';
import 'package:gti_rides/models/vehicle_seat.dart';
import 'package:gti_rides/models/vehicle_type.dart';
import 'package:gti_rides/models/vehicle_year.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

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
    await getCarFeatures();
    await getVehicleType();
    await getBrands();
    await getVehicleSeats();
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

  RxList selectedCarFeature = [].obs;
  RxList selectedCarTypes1 = [].obs;
  // RxList selectedVehicleBrands = [].obs;
  RxList selectedVehicleSeats = [].obs;

  // integers
  RxInt selectedCheckboxes = 0.obs;
  RxInt selectedCarTypes = 0.obs;
  RxInt selectedVehicleBrands = 0.obs;
  RxInt selectedVehicleModels = 0.obs;
  RxInt selectedVehiclYears = 0.obs;
  RxInt selectedCarSeats = 0.obs;
  RxInt selectedCategories = 0.obs;
  RxInt selectedTransmissions = 0.obs;

  RxDouble startValue = 20.0.obs;
  RxDouble endValue = 90.0.obs;

  final List<String> sortByList = [
    // AppStrings.relevance,
    // AppStrings.distanceAway,
    AppStrings.highestToLowest,
    AppStrings.lowestToHighest,

    // Add more options here
  ];
  List<FilterOptions> filterOptionsList = [
    // FilterOptions(
    // title: AppStrings.carFeaturesCaps, subTitle: AppStrings.allFeatures),
    // FilterOptions(
        // title: AppStrings.vehicleTypeCaps, subTitle: AppStrings.allTypes),
    FilterOptions(
        title: AppStrings.vehicleBrandCaps, subTitle: AppStrings.allBrand),
    FilterOptions(
        title: "VEHICLE ${AppStrings.model}", subTitle: AppStrings.allBrand),
    FilterOptions(title: "VEHICLE YEAR", subTitle: AppStrings.allBrand),
    // FilterOptions(title: AppStrings.carSeat, subTitle: AppStrings.allSeat),
    // FilterOptions(
    //     title: AppStrings.transmissionCaps,
    //     subTitle: AppStrings.allTransmission),
    // FilterOptions(title: AppStrings.categoryCaps, subTitle: AppStrings.allCars),
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

  List<String> vehicleSeats1 = [
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
  RxList<CarFeatureData> carFeatures = <CarFeatureData>[].obs;
  RxList<VehicleTypeData> vehicleTypes = <VehicleTypeData>[].obs;
  RxList<VehicleBrandData> vehicleBrands = <VehicleBrandData>[].obs;
  RxList<VehicleSeatData> vehicleSeats = <VehicleSeatData>[].obs;
  RxList<BrandModelData> brandModels = <BrandModelData>[].obs;
  RxList<VehicleYearData> vehicleYearList = <VehicleYearData>[].obs;

  RxBool gettingCarBrand = false.obs;
  RxBool gettingBrandModel = false.obs;
  RxBool gettingBrandYear = false.obs;

  Future<List<CarFeatureData>> getCarFeatures() async {
    try {
      //isGettingBrands.value = true;
      final response = await partnerService.getFeatures();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten car features ${response.data}");
        if (response.data != null && response.data != []) {
          carFeatures?.value = response.data!
              .map((feature) => CarFeatureData.fromJson(feature))
              .toList();
          logger.log("features ${carFeatures?.value}");
          return carFeatures;
        }
        return carFeatures;
      } else {
        logger.log("unable to car features ${response.data}");
        // isGettingBrands.value = false;
        return carFeatures;
      }
    } catch (exception) {
      logger.log("get car features error  $exception");
      return carFeatures;
    }
  }

  Future<void> getVehicleType() async {
    try {
      final response = await partnerService.getVehicleType();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten vehicle Types ${response.data}");
        if (response.data != null && response.data != []) {
          vehicleTypes?.value = response.data!
              .map((type) => VehicleTypeData.fromJson(type))
              .toList();
          logger.log("vehicle type ${vehicleTypes?.value}");
        }
      } else {
        logger.log("unable to vehicle Types ${response.data}");
      }
    } catch (exception) {
      logger.log("get vehicle type error  $exception");
    }
  }

  Future<void> getBrands() async {
    gettingCarBrand.value = true;
    try {
      final response = await partnerService.getBrand();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten brands ${response.data}");
        if (response.data != null && response.data != []) {
          vehicleBrands.value = response.data!
              .map((brand) => VehicleBrandData.fromJson(brand))
              .toList();
          // logger.log("brands ${brands.value.data}");
        }
      } else {
        logger.log("unable to get brands ${response.data}");
      }
    } catch (exception) {
      logger.log("get brands error  $exception");
    } finally {
      gettingCarBrand.value = false;
    }
  }

  String selectedBrandName= '';
  String selectedBrandCode = '';
  String selectedBrandModelName = '';
  String selectedBrandModelCode = '';
  RxString selectedYearName = ''.obs;
  String selectedYearCode = '';
  String selectedPriceSorting = 'highest';

  void clearSearchFilter() {
    selectedPriceSorting = '';
    selectedBrandName = '';
    selectedBrandCode = '';
    selectedBrandModelName = '';
    selectedBrandModelCode = '';
    selectedYearCode = '';
    selectedYearCode = '';
    selectedYearName = "".obs;
    selectedPriceSorting = '';
    toAmount.clear();
    fromAmount.clear();

    logger.log("value:: $selectedBrandCode");
  }

  Future<void> getBrandModel({required String brandCode}) async {
    gettingBrandModel.value = true;
    try {
      final response = await partnerService.getBrandModel(brandCode: brandCode);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten brand model ${response.data}");
        if (response.data != null && response.data != []) {
          brandModels?.value = response.data!
              .map((brandModel) => BrandModelData.fromJson(brandModel))
              .toList();
          logger.log("brand model ${response.data}");
        }
      } else {
        logger.log("unable to get brand model ${response.data}");
        showErrorSnackbar(message: response.message!);
        // isGettingBrands.value = false;
      }
    } catch (exception) {
      logger.log("get brand model error  $exception");
    } finally {
      gettingBrandModel.value = false;
    }
  }

  Future<void> getVehicleYear(
      {required String brandCode, required String brandModelCode}) async {
    gettingBrandYear.value = true;
    try {
      //isGettingBrands.value = true;
      // isGettingyear.value = true;
      // vehicleYear!.clear();
      // selectedYearValue!.value = 'Select';
      final response = await partnerService.getVehicleYear(
          brandCode: brandCode, brandModelCode: brandModelCode);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten vehicle year ${response.data}");
        if (response.data != null && response.data != []) {
          // vehicleYear?.value = response.data!;
          vehicleYearList!.assignAll(response.data!
              .map((year) => VehicleYearData.fromJson(year))
              .toList());
          // isGettingyear.value = false;

          logger.log("vehicle year ${vehicleYearList.value}");
        } else {
          logger.log("no vehicle year ${response.data}");
        }
      } else {
        logger.log("unable to get vehicle year ${response.data}");
        showErrorSnackbar(message: response.message!);
        // isGettingyear.value = false;
      }
    } catch (exception) {
      logger.log("get vehicle year error  $exception");
    } finally {
      gettingBrandYear.value = false;
    }
  }

  Future<void> getVehicleSeats() async {
    try {
      final response = await partnerService.getVehicleSeats();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten vehicle seats ${response.data}");
        if (response.data != null && response.data != []) {
          vehicleSeats?.value = response.data!
              .map((seats) => VehicleSeatData.fromJson(seats))
              .toList();
          logger.log("seats ${vehicleSeats?.value}");
        }
      } else {
        logger.log("unable to vehicle seats ${response.data}");
      }
    } catch (exception) {
      logger.log("get vehicle seats error  $exception");
    }
  }

  List<String> vehicleBrands1 = [
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
  void goBack() => routeService.goBack(result: {
        "brandCode": selectedBrandCode,
        "modelCode": selectedBrandModelCode,
        "yearCode": selectedYearCode,
        "startPricing": fromAmount.text,
        "endPricing": toAmount.text,
        "priceSort": selectedPriceSorting
      });

  void onChauffeurSelected(bool value) => selectedChauffeur.value = value;
  void onSelectSelfDrive(bool value) => selectedSelfDrive.value = value;
  void onSelectInterState(bool value) => selectedInterState.value = value;
  void onSelectIntraState(bool value) => selectedIntraState.value = value;

  void onSelectSortBy(int index) => selectedCheckboxes.value = index;
  void onCarTypeChecked(int index) => selectedCarTypes.value = index;
  void onVehicleBrandChecked(int index) => selectedVehicleBrands.value = index;
  void onVehicleModelChecked(int index) => selectedVehicleModels.value = index;
  void onVehicleYearChecked(int index) => selectedVehiclYears.value = index;
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
