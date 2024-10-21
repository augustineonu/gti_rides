import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/cars_model.dart';
import 'package:gti_rides/models/renter/city_model.dart';
import 'package:gti_rides/models/renter/state_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import '../../../../models/renter/location_model.dart';

enum LocationType {
  state,
  city,
}

class SearchCityController extends GetxController {
  Logger logger = Logger("SearchCityController");

  Map<String, dynamic>? arguments = Get.arguments;
  GlobalKey<FormState> searchFormKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  RxBool isFetchingStates = false.obs;
  RxBool isFetchingCities = false.obs;
  RxBool isFetchingCars = false.obs;
  PageController pageController = PageController();
  RxInt currentIndex = 0.obs;
  RxString phoneCode = '1'.obs;
  RxString flagEmoji = '🇺🇸'.obs;
  RxString selectedCity = ''.obs;
  RxString selectedState = ''.obs;
  RxString selectedcityCode = ''.obs;
  RxString selectedStateCode = ''.obs;
  RxString startDateTime = ''.obs;
  RxString endDateTime = ''.obs;

  RxString startDate = ''.obs;
  RxString endDate = ''.obs;
  Rx<int> selectedDifferenceInDays = 0.obs;
  DateTime? rawStartTime;
  DateTime? rawEndTime;

  Rx<TextEditingController> searchCategoryController =
      TextEditingController().obs;
  Rx<TextEditingController> fromController = TextEditingController().obs;
  Rx<TextEditingController> toController = TextEditingController().obs;
  Rx<TextEditingController> locationController =
      TextEditingController(text: '').obs;

  // RxList<String> cities = <String>[].obs;

  RxList<String> filteredCity = <String>[].obs;
  RxList<StateData> filteredStates = <StateData>[].obs;
  RxList<StateData> states = <StateData>[].obs;
  RxList<CityData> cities = <CityData>[].obs;
  Rx<LocationType> selectedType = LocationType.state.obs;
  RxList<CarData> cars = <CarData>[].obs;

  SearchCityController() {
    init();
  }

  void init() {
    logger.log("SearchCityController Initialized");
    if (arguments != null) {
      logger.log('Received data $arguments');

      startDateTime.value = arguments?['start'] ?? '';
      endDateTime.value = arguments?['end'] ?? '';

      fromController.value.text = startDateTime.value;
      toController.value.text = endDateTime.value;
    }
  }

  @override
  void onInit() async {
    await getStates();
    pageController.addListener(() {
      currentIndex.value = pageController.page?.round() ?? 0;
      update();
    });
    searchCategoryController.value.addListener(queryListener);

    super.onInit();
  }

  void queryListener() {
    updateFilteredLocations(searchCategoryController.value.text);
    update();
  }

  // Update the filteredPages based on search input
  void updateFilteredStates(String searchText) {
    filteredStates.clear(); // Clear the current filtered states

    // Filter the states based on the search text
    if (searchText.isEmpty) {
      // If the search text is empty, show all states
      filteredStates.addAll(states);
    } else {
      // If the search text is not empty, filter states that match the search
      filteredStates.addAll(states.where((state) {
        return state.stateName!
            .toLowerCase()
            .contains(searchText.toLowerCase());
      }));
    }

    // Notify the listeners that the filtered states have changed
    update();
  }

  void openBottomSheet() {}

  void goBack() => routeService.goBack();
  void routeToSelecteDate() =>
      routeService.gotoRoute(AppLinks.chooseTripDate, arguments: {
        "isRenterHome": true,
        "appBarTitle": AppStrings.tripDates,
        "from": AppStrings.startDate,
        "to": AppStrings.endDate,
      });

  void routeToSearchResult() {
    if (!searchFormKey.currentState!.validate()) {
      return;
    }
    routeService.gotoRoute(AppLinks.searchResult);
  }

  Future<void> resetStateSelection() async {
    selectedType.value = LocationType.state;
    await getStates();
  }

  void clearSearchField() {
    searchCategoryController.value.clear();
  }

  Rx<Location> selectedLocation = Location('', '', '').obs;

  void onLocationSelected(Location location) {
    // selectedLocation.value = location;
    locationController.value.text = location.name;

    logger.log(">>>>${locationController.value.text}");
  }

  Future<void> getStates() async {
    // change(<FavoriteCarData>[].obs, status: RxStatus.loading());
    isFetchingStates.value = true;
    try {
      final response = await partnerService.getStates();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten states  ${response.data}");

        if (response.data == null || response.data!.isEmpty) {
          // If the list is empty
          // change(<FavoriteCarData>[].obs, status: RxStatus.empty());
          states.value = [];
          isFetchingStates.value = false;
          locations.value = [];
           update();
          // logger.log("cars $cars");
        } else {
          // If the list is not empty
          List<StateData> statesData = List<StateData>.from(
            response.data!.map((state) => StateData.fromJson(state)),
          );

          states.value = statesData;

          List<Location> stateLocations = statesData
              .map((stateData) =>
                  Location(stateData.stateCode!, stateData.stateName!, 'state'))
              .toList();
          // Sort the stateLocations list alphabetically by state name
          stateLocations.sort((a, b) => a.name.compareTo(b.name));

          locations.assignAll([...stateLocations]);

          logger.log("states:: ${locations.value}");

          // change(favoriteCar, status: RxStatus.success());
          update();
        }
      } else {
        logger.log("unable to get states ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
      // change(<FavoriteCarData>[].obs,
      // status: RxStatus.error(exception.toString()));
    } finally {
      isFetchingStates.value = false;
    }
  }

  Future<void> getCities() async {
    // change(<FavoriteCarData>[].obs, status: RxStatus.loading());
    isFetchingCities.value = true;
    try {
      final response =
          await partnerService.getCity(cityCode: selectedStateCode.value);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten cities  ${response.data}");

        if (response.data == null || response.data!.isEmpty) {
          // If the list is empty
          // change(<FavoriteCarData>[].obs, status: RxStatus.empty());
          isFetchingCities.value = false;
          cities.value = [];
          selectedType.value = LocationType.state;
          showSuccessSnackbar(
            title: 'Coverage for Location',
            message: 'coming soon!',
          );
          // logger.log("cars $cars");
        } else {
          // If the list is not empty
          List<CityData> citiesData = List<CityData>.from(
            response.data!.map((city) => CityData.fromJson(city)),
          );

          cities.value = citiesData;

          // Convert city data to Location
          selectedType.value = LocationType.city;
          List<Location> cityLocations = citiesData
              .map((cityData) =>
                  Location(cityData.cityCode!, cityData.cityName!, 'city'))
              .toList();
          locations.assignAll([...cityLocations]);

          logger.log("cities:: ${cities}");

          // change(favoriteCar, status: RxStatus.success());
          update();
        }
      } else {
        logger.log("unable to get city ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
      // change(<FavoriteCarData>[].obs,
      // status: RxStatus.error(exception.toString()));
    } finally {
      isFetchingCities.value = false;
    }
  }

  RxList<Location> locations = <Location>[].obs;
  RxList<Location> filteredLocation = <Location>[].obs;

  void updateFilteredLocations(String searchText) {
    filteredLocation.clear(); // Clear the current filtered states

    // Filter the states based on the search text
    if (searchText.isEmpty) {
      // If the search text is empty, show all states

      filteredLocation.addAll([...locations]);
      update();
    } else {
      // If the search text is not empty, filter states that match the search
      filteredLocation.addAll(locations.where((location) =>
          location.name.toLowerCase().contains(searchText.toLowerCase())));
      update();
    }
  }

  Future<void> searchCars() async {
    if (!searchFormKey.currentState!.validate()) {
      return;
    }
    // isFetchingCars.value = true;
    try {
      final response = await renterService.searchCars(
          stateCode: selectedStateCode.value,
          startDate: rawStartTime!.toIso8601String(),
          endDate: rawEndTime!.toIso8601String());
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten cars  ${response.data}");

        if (response.data == null || response.data!.isEmpty) {
          // If the list is empty
          cars.value = [];
          // selectedType.value = LocationType.state;
          Get.back();
          showSuccessSnackbar(
            title: 'Cars for Location',
            message: 'coming soon!',
          );
          // logger.log("cars $cars");
        } else {
          // If the list is not empty
          List<CarData> carDataList = List<CarData>.from(
            response.data!.map((car) => CarData.fromJson(car)),
          );

          cars.value = carDataList;

          logger.log("cars:: ${cars}");
          update();

          // showSuccessSnackbar(
          //   title: 'Cars for Location',
          //   message: 'Available!',
          // );
          // isFetchingCars.value = false;
          update();
          routeService.gotoRoute(
            AppLinks.searchResult,
            arguments: {
              "cars": cars,
              "selectedState": selectedState.value,
              "selectedCity": selectedCity.value,
              "startDate": startDate.value,
              "endDate": endDate.value,
              "startDateTime": startDateTime.value,
              "endDateTime": endDateTime.value,
              "differenceInDays": selectedDifferenceInDays.value,
              "rawStartTime": rawStartTime,
              "rawEndTime": rawEndTime,
              "selectedStateCode": selectedStateCode.value
            },
          );
        }
      } else {
        logger.log("unable to get city ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
    } finally {
      isFetchingCars.value = false;
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    isFetchingCars.value = false;
  }
}
