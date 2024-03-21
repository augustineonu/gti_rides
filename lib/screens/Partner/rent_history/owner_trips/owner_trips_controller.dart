import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/pending_trips_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class OwnerTripsController extends GetxController
    with StateMixin<List<AllTripsData>> {
  Logger logger = Logger('OwnerTripsController');

  OwnerTripsController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
    if (arguments != null) {
      logger.log("Received data:: $arguments");
      carId.value = arguments!['carId'];
      vehicleName.value = arguments!['vehicleName'];
      photoUrl.value = arguments!['photoUrl'] ?? '';
    }
    load();
  }

  void load() {
    logger.log('Loading');
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    await getAllTrips();
  }

  Map<String, dynamic>? arguments = Get.arguments;

  RxInt selectedIndex = 0.obs;
  Rx<String> carId = "".obs;
  Rx<String> photoUrl = "".obs;
  Rx<String> vehicleName = "".obs;

  @override
  void dispose() {
    super.dispose();
  }

  void goBack() => routeService.goBack();

  void routeToresetPassword() => routeService.gotoRoute(
        AppLinks.resetPassword,
      );

  void copy({required String value}) async {
    await Clipboard.setData(ClipboardData(text: value));

    await showSuccessSnackbar(message: AppStrings.copied);
  }

  RxString testString = 'test string'.obs;

  RxList<AllTripsData> allTrips = <AllTripsData>[].obs;
  RxList<AllTripsData> pendingTrips = <AllTripsData>[].obs;
  RxList<AllTripsData> activeTrips = <AllTripsData>[].obs;
  RxList<AllTripsData> completedTrips = <AllTripsData>[].obs;

    void routeToCompletedTrip({Object? arguments}) => routeService.gotoRoute(AppLinks.completedTrip,arguments: arguments);


  Future<void> getAllTrips() async {
    // RxStatus.loading();
    change([], status: RxStatus.loading());
    try {
      final response = await renterService.getAllTrips(param: 'partner');

      if (response.status == 'success' || response.status_code == 200) {
        logger.log("All Trips:: ${response.data}");
        List<AllTripsData> trips = List<AllTripsData>.from(
            response.data!.map((trip) => AllTripsData.fromJson(trip)));

        if (trips.isEmpty) {
          change([], status: RxStatus.empty());
        } else {
          // Clear existing lists
          allTrips.clear();
          pendingTrips.clear();
          activeTrips.clear();
          completedTrips.clear();

          allTrips.value = trips;

          // Iterate through trips and assign to appropriate lists based on status
          for (AllTripsData trip in trips) {
            switch (trip.status) {
              case 'pending':
                pendingTrips.add(trip);
                break;
              case 'active':
                activeTrips.add(trip);
                break;
              case 'completed':
                completedTrips.add(trip);
                break;
              default:
                // Handle other status types if needed
                break;
            }
          }
          change(trips, status: RxStatus.success());
        }
      } else {
        logger.log("Unable to get trips");
      }
    } catch (e) {
      change([], status: RxStatus.error('Unable to get trips'));
      logger.log("Error occurred while getting trips: $e");
    }
  }
}
