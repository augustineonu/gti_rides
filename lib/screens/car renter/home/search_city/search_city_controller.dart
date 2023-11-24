import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';

class SearchCityController extends GetxController {
  Logger logger = Logger("Controller");
  RxBool isLoading = false.obs;
  PageController pageController = PageController();
  RxInt currentIndex = 0.obs;
  RxString phoneCode = '1'.obs;
  RxString flagEmoji = '🇺🇸'.obs;

  TextEditingController searchCategoryController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  RxList<String> cities = <String>[].obs;

  RxList<String> filteredCity = <String>[].obs;

  SearchCityController() {
    init();
    cities.value = [
      "Lagos",
      "Abuja",
      "Port Harcourt, Rivers",
      "jewellery_accessories",
      "Delta State"
          "Kano",
    ];
  }

  void init() {
    logger.log("SearchCityController Initialized");
  }

  @override
  void onInit() async {
    pageController.addListener(() {
      currentIndex.value = pageController.page?.round() ?? 0;
      update();
    });
    searchCategoryController.addListener(queryListener);

    super.onInit();
  }

  void queryListener() {
    updateFilteredPages(searchCategoryController.text);
  }

  // Update the filteredPages based on search input
  void updateFilteredPages(String searchText) {
    filteredCity.clear(); // Clear the current filtered pages

    // Filter the pages based on the search text
    if (searchText.isEmpty) {
      // If the search text is empty, show all pages
      filteredCity.addAll(cities);
    } else {
      // If the search text is not empty, filter pages that match the search
      filteredCity.value = cities.where((city) {
        return city.toString().toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    }

    // Notify the listeners that the filtered pages have changed
    update();
  }

  void openBottomSheet() {}

  void goBack() => routeService.goBack();
  void routeToSelecteDate() => routeService.gotoRoute(AppLinks.chooseTripDate);
  void routeToSearchResult() => routeService.gotoRoute(AppLinks.searchResult);
}
