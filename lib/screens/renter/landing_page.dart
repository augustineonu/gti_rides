import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/screens/renter/home/renter_home_screen.dart';
import 'package:gti_rides/screens/renter/inbox/inbox_screen.dart';
import 'package:gti_rides/screens/renter/landing_controller.dart';
import 'package:gti_rides/screens/shared_screens/more/more_screen.dart';
import 'package:gti_rides/screens/renter/trips/trips_screen.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

import '../shared_screens/guest_view/presentation/guest_user.dart';

class RenterLandingPage extends StatelessWidget {
  const RenterLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = userService.user.value ?? UserModel();
    final RenterLandingController controller = Get.put(
      RenterLandingController(),
    );
    return WillPopScope(
      onWillPop: () async {
        // Navigator.of(context).pop(returningValue);
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Obx(() => bottomNavBar(context, controller)),
        body: Obx(() => IndexedStack(
              index: controller.tabIndex.value,
              children: [
                CarRenterHomeScreen(),
                TripsScreen(),
                user.fullName == null ? GuesUserView() : InboxScreen(),
                user.fullName == null ? GuesUserView() : MoreScreen(),
              ],
            )),
      ),
    );
  }

  Widget bottomNavBar(
      BuildContext context, RenterLandingController controller) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          showSelectedLabels: true,
          onTap: controller.changeTabIndex,
          currentIndex: controller.tabIndex.value,
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
                  color: controller.tabIndex.value == 0 ? primaryColor : black,
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
                  color: controller.tabIndex.value == 1 ? primaryColor : black,
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
                  color: controller.tabIndex.value == 2 ? primaryColor : black,
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
                  color: controller.tabIndex.value == 3 ? primaryColor : black,
                ),
              ),
              label: AppStrings.more,
              backgroundColor: backgroundColor,
            ),
          ],
        ));
  }
}
