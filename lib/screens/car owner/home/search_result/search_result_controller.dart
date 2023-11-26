import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';

class SearchResultController extends GetxController {
  Logger logger = Logger("Controller");
  RxBool isLoading = false.obs;

  Rx<String> testString = "Hello".obs;

  SearchResultController() {
    init();
  }

  void init() {
    logger.log("SearchResultController Initialized");
  }

  @override
  void onInit() async {
    update();

    super.onInit();
  }

  void goBack() => routeService.goBack();
  void routeToSearchFilter() => routeService.gotoRoute(AppLinks.searchFilter);
  void routeToCarSelection() =>
      routeService.gotoRoute(AppLinks.carSelectionResult);
}
