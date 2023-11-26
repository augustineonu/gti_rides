import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20owner/home/car_owner_home_screen.dart';
import 'package:gti_rides/screens/car%20owner/owner_landing_controller.dart';
import 'package:gti_rides/screens/car%20renter/home/car_renter_home_screen.dart';
import 'package:gti_rides/screens/car%20renter/inbox/inbox_screen.dart';
import 'package:gti_rides/screens/car%20renter/landing_controller.dart';
import 'package:gti_rides/screens/car%20renter/more/more_screen.dart';
import 'package:gti_rides/screens/car%20renter/trips/trips_screen.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class OwnerLandingPage extends StatelessWidget {
  const OwnerLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OwnerLandingPageController controller =
        Get.put(OwnerLandingPageController(), permanent: false);
    return Scaffold(
      bottomNavigationBar:
          Obx(() => bottomNavBar(context, controller)),
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: const [
              CarOwnerHomeScreen(),
              TripsScreen(),
              InboxScreen(),
              MoreScreen(),
            ],
          )),
    );
  }

  Widget bottomNavBar(
      BuildContext context, OwnerLandingPageController landingPageController) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          showSelectedLabels: true,
          onTap: landingPageController.changeTabIndex,
          currentIndex: landingPageController.tabIndex.value,
          backgroundColor: white,
          unselectedItemColor: black,
          selectedItemColor: primaryColor,
          unselectedLabelStyle: getRegularStyle(fontSize: 12, color: black)
              .copyWith(fontWeight: FontWeight.w400),
          selectedLabelStyle: getRegularStyle(fontSize: 13, color: primaryColor)
              .copyWith(fontWeight: FontWeight.w400),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: SvgPicture.asset(
                  ImageAssets.search,
                  height: 18.sp,
                  color: landingPageController.tabIndex.value == 0
                      ? primaryColor
                      : black,
                ),
              ),
              label: AppStrings.search,
              backgroundColor: backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: SvgPicture.asset(
                  ImageAssets.trip,
                  height: 18.sp,
                  color: landingPageController.tabIndex.value == 1
                      ? primaryColor
                      : black,
                ),
              ),
              label: AppStrings.trips,
              backgroundColor: backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: SvgPicture.asset(
                  ImageAssets.inbox,
                  height: 18.sp,
                  color: landingPageController.tabIndex.value == 2
                      ? primaryColor
                      : black,
                ),
              ),
              label: AppStrings.inboox,
              backgroundColor: backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 7),
                child: SvgPicture.asset(
                  ImageAssets.more,
                  height: 18.sp,
                  color: landingPageController.tabIndex.value == 3
                      ? primaryColor
                      : black,
                ),
              ),
              label: AppStrings.more,
              backgroundColor: backgroundColor,
            ),
          ],
        ));
  }
}
