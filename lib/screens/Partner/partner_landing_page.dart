import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/Partner/home/partner_home_screen.dart';
import 'package:gti_rides/screens/Partner/partner_landing_controller.dart';
import 'package:gti_rides/screens/Partner/payment/payment_screen.dart';
import 'package:gti_rides/screens/Partner/rent_history/rent_history_screen.dart';
import 'package:gti_rides/screens/renter/inbox/inbox_screen.dart';
import 'package:gti_rides/screens/shared_screens/more/more_screen.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class PartnerLandingPage extends StatelessWidget {
  const PartnerLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PartnerLandingController controller =
        Get.put(PartnerLandingController(),);
    return Scaffold(
      bottomNavigationBar:
          Obx(() => bottomNavBar(context, controller)),
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children:  [
              PartnerHomeScreen(),
              RentHistoryScreen(),
              PaymentScreen(),
              MoreScreen(),
            ],
          )),
    );
  }

  Widget bottomNavBar(
      BuildContext context, PartnerLandingController landingPageController) {
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
                  ImageAssets.home,
                  height: 18.sp,
                  color: landingPageController.tabIndex.value == 0
                      ? primaryColor
                      : black,
                ),
              ),
              label: AppStrings.home,
              backgroundColor: backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: SvgPicture.asset(
                  ImageAssets.historyIcon,
                  height: 18.sp,
                  color: landingPageController.tabIndex.value == 1
                      ? primaryColor
                      : black,
                ),
              ),
              label: AppStrings.rentHistory,
              backgroundColor: backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: SvgPicture.asset(
                  ImageAssets.payment,
                  height: 18.sp,
                  color: landingPageController.tabIndex.value == 2
                      ? primaryColor
                      : black,
                ),
              ),
              label: AppStrings.payment,
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
