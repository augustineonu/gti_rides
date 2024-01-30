import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/city_model.dart';
import 'package:gti_rides/models/renter/state_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class SearchCityController extends GetxController {
  Logger logger = Logger("Controller");
  RxBool isLoading = false.obs;
  RxBool isFetchingStates = false.obs;
  RxBool isFetchingCities = false.obs;
  PageController pageController = PageController();
  RxInt currentIndex = 0.obs;
  RxString phoneCode = '1'.obs;
  RxString flagEmoji = '🇺🇸'.obs;
  RxString selectedCity = ''.obs;
  RxString selectedState = ''.obs;
  RxString selectedcityCode = ''.obs;

  TextEditingController searchCategoryController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  Rx<TextEditingController> locationController =
      TextEditingController(text: '').obs;

  // RxList<String> cities = <String>[].obs;

  RxList<String> filteredCity = <String>[].obs;
  RxList<StateData> filteredStates = <StateData>[].obs;
  RxList<StateData> states = <StateData>[].obs;
  RxList<CityData> cities = <CityData>[].obs;

  SearchCityController() {
    init();
    // cities.value = [
    //   "Lagos",
    //   "Abuja",
    //   "Port Harcourt, Rivers",
    //   "jewellery_accessories",
    //   "Delta State"
    //       "Kano",
    // ];
  }

  void init() {
    logger.log("SearchCityController Initialized");
  }

  @override
  void onInit() async {
    await getStates();
    pageController.addListener(() {
      currentIndex.value = pageController.page?.round() ?? 0;
      update();
    });
    searchCategoryController.addListener(queryListener);

    super.onInit();
  }

  void queryListener() {
    updateFilteredStates(searchCategoryController.text);
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
  void routeToSearchResult() => routeService.gotoRoute(AppLinks.searchResult);

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
          // logger.log("cars $cars");
        } else {
          // If the list is not empty
          List<StateData> statesData = List<StateData>.from(
            response.data!.map((state) => StateData.fromJson(state)),
          );

          states.value = statesData;

          logger.log("states:: ${states}");

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
          await partnerService.getCity(cityCode: selectedcityCode.value);
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten cities  ${response.data}");

        if (response.data == null || response.data!.isEmpty) {
          // If the list is empty
          // change(<FavoriteCarData>[].obs, status: RxStatus.empty());
          cities.value = [];
          // logger.log("cars $cars");
        } else {
          // If the list is not empty
          List<CityData> citiesData = List<CityData>.from(
            response.data!.map((city) => CityData.fromJson(city)),
          );

          cities.value = citiesData;

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
}
