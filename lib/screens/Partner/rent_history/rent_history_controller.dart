import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/models/renter/pending_trips_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/Partner/home/list_vehicle/list_vehicle_screen.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

class RentHistoryController extends GetxController
    with StateMixin<List<AllTripsData>> {
  Logger logger = Logger("Controller");

  RentHistoryController() {
    init();
  }

  void init() {
    logger.log("RentHistoryController Initialized");
  }

  @override
  void onInit() async {
    pageController.addListener(() {
      update();
    });
    user = userService.user;
    super.onInit();
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    if (user.value.userType == "partner") {
      await getAllTrips();
    }
  }

  // variables
  Rx<UserModel> user = UserModel().obs;
  RxBool isLoading = false.obs;
  PageController pageController = PageController();
  RxInt selectedIndex = 0.obs;
  RxString testString = "".obs;
  RxList<AllTripsData> activeTrips = <AllTripsData>[].obs;
  RxList<AllTripsData> completedTrips = <AllTripsData>[].obs;

  TextEditingController senderNameController = TextEditingController();
  // RxList<PendingTripsData> activeTrips = <PendingTripsData>[].obs;
  // RxList<PendingTripsData> completedTrips = <PendingTripsData>[].obs;

  List<Map<String, String>> quickOptions = [
    {
      "imageUrl": ImageAssets.pencilEdit,
      "title": AppStrings.reportTripToAdin,
    },
    {
      "imageUrl": ImageAssets.history,
      "title": AppStrings.rideHistory,
    },
  ];

// routing methods
  void goBack() => routeService.goBack();
  void routeToQuickEdit() => routeService.gotoRoute(AppLinks.quickEdit);
  void routeToCarHistory() => routeService.gotoRoute(AppLinks.carHistory);
  void routeToCompletedTrip({Object? arguments}) =>
      routeService.gotoRoute(AppLinks.completedTrip, arguments: arguments);

  Future<void> getAllTrips() async {
    // RxStatus.loading();
    change([], status: RxStatus.loading());
    try {
      final response = await renterService.getAllTrips(param: 'partner');

      if (response.status == 'success' || response.status_code == 200) {
        // logger.log("All Trips:: ${response.data}");
        List<AllTripsData> trips = List<AllTripsData>.from(
            response.data!.map((trip) => AllTripsData.fromJson(trip)));

            logger.log("User trips:: ${trips}");

        if (trips.isEmpty) {
          change([], status: RxStatus.empty());
        } else {
          // Clear existing lists
          activeTrips.clear();
          completedTrips.clear();

          // Iterate through trips and assign to appropriate lists based on status
          for (AllTripsData trip in trips) {
            switch (trip.status) {
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

  Future<void> launchMessenger() async {
    await Intercom.instance
        .loginIdentifiedUser(email: userService.user.value.emailAddress);
    await Intercom.instance.displayMessenger();
  }
}
