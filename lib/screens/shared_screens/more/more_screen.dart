import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/more_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

class MoreBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<MoreController>(MoreController());
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final controller = Get.put<MoreController>(MoreController());

    return Obx(
      () => Scaffold(
        // appBar: appBar(),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appBar(controller),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      controller.user.value.userType == 'renter'
                          ? rentVehicleCard(
                              imagePath: ImageAssets.ladyHandout,
                              title: AppStrings.rentOutYourVehichle,
                              body: AppStrings.youCanListYourCar,
                              onTap: controller.launchWebsite,
                              height: height)
                          : rentVehicleCard(
                              imagePath: ImageAssets.moreFrame,
                              title: AppStrings.rentAvehicle,
                              body: AppStrings.gotYouCoveredVehicles,
                              onTap: () {},
                              height: height),
                      SizedBox(
                        height: 10.sp,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.profileOptions.length,
                        itemBuilder: (context, index) {
                          // show "My Drivers" only if user type is Owner
                          final option = controller.profileOptions[index];
                          if (controller.tokens.value.userType == "partner") {
                            return index == 1
                                ? SizedBox()
                                : profileOptionsWIdget(
                                    imageUrl: option['image'],
                                    title: option['title'],
                                    onTap: () {
                                      // controller.routeToDrivers();
                                      switch (index) {
                                        case 0:
                                          controller.routeToAccountDetails();
                                        case 1:
                                          controller.routeToFavorite();
                                        case 2:
                                          controller
                                              .routeToIdentityVerification();
                                        // show "My Drivers" only if user type is Owner
                                        case 3:
                                          controller.routeToDrivers();
                                        case 4:
                                          controller.launchWebsite();
                                        case 5:
                                          controller.routeToReferralCode();
                                          break;
                                        case 6:
                                          controller.launchMessenger();
                                        // break;
                                        case 7:
                                          controller.launchMessenger();
                                        // break;
                                        case 8:
                                          controller.routeToNotification();
                                        default:
                                      }
                                    },
                                  );
                          } else {
                            // if user type is renter
                            return switch (index) {
                              0 => profileOptionsWIdget(
                                  imageUrl: option['image'],
                                  title: option['title'],
                                  onTap: () {
                                    controller.routeToAccountDetails();
                                  },
                                ),
                              1 => profileOptionsWIdget(
                                  imageUrl: option['image'],
                                  title: option['title'],
                                  onTap: () {
                                    controller.routeToFavorite();
                                  },
                                ),
                              2 => profileOptionsWIdget(
                                  imageUrl: option['image'],
                                  title: option['title'],
                                  onTap: () {
                                    controller.routeToIdentityVerification();
                                  },
                                ),
                              3 => const SizedBox(),
                              4 => profileOptionsWIdget(
                                  imageUrl: option['image'],
                                  title: option['title'],
                                  onTap: () {
                                    controller.launchWebsite();
                                  },
                                ),
                              5 => profileOptionsWIdget(
                                  imageUrl: option['image'],
                                  title: option['title'],
                                  onTap: () {
                                    controller.routeToReferralCode();
                                  },
                                ),
                              6 => profileOptionsWIdget(
                                  imageUrl: option['image'],
                                  title: option['title'],
                                  onTap: () => controller.launchMessenger(),
                                ),
                              7 => profileOptionsWIdget(
                                  imageUrl: option['image'],
                                  title: option['title'],
                                  onTap: () => controller.launchMessenger(),
                                ),
                              8 => profileOptionsWIdget(
                                  imageUrl: option['image'],
                                  title: option['title'],
                                  onTap: () => controller.routeToNotification(),
                                ),
                              _ => Container()
                            };
                          }
                        },
                      ),
                      profileOptionsWIdget(
                        imageUrl: ImageAssets.treashBin,
                        title: "Deactivate Account",
                        onTap: () => controller.routeToPasswordConfirmation(),
                      ),
                      divider(color: borderColor),
                      SizedBox(
                        height: 10.sp,
                      ),
                      InkWell(
                        onTap: () {
                          controller.isLogout.value = true;
                          controller.logOut();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 13),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                ImageAssets.logOut,
                                height: 18.sp,
                                width: 20.sp,
                              ),
                              SizedBox(
                                width: 8.sp,
                              ),
                              textWidget(
                                  text: AppStrings.logOut,
                                  style: getMediumStyle(color: primaryColor)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar(MoreController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: controller.routeToProfile,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                    text: controller.user.value.fullName,
                    textOverflow: TextOverflow.visible,
                    style: getMediumStyle(fontSize: 18.sp)
                        .copyWith(fontWeight: FontWeight.w500)),
                textWidget(
                    text: AppStrings.editProfile,
                    textOverflow: TextOverflow.visible,
                    style: getMediumStyle(color: primaryColor)
                        .copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          profileAvatar(
            height: 40,
            width: 40,
            imgUrl: controller.user.value.profilePic!,
            // imgUrl:  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ88joJfjwoaz_jWaMQhbZn2X11VHGBzWKiQg&usqp=CAU',
          ),
        ],
      ),
    );
  }

  Widget rentVehicleCard(
      {required String title,
      required String body,
      required String imagePath,
      void Function()? onTap,
      height}) {
    return Container(
      // height: 125.sp,
      padding: EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: grey5, width: 0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(4.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 135.sp,
            // height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8.sp,
                ),
                textWidget(
                    text: title,
                    textOverflow: TextOverflow.visible,
                    style: getSemiBoldStyle(fontSize: 15.sp)
                        .copyWith(fontWeight: FontWeight.w600, height: 1.1)),
                // SizedBox(
                //   height: 5.sp,
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: textWidget(
                      text: body,
                      textOverflow: TextOverflow.visible,
                      style: getLightStyle(fontSize: 10.sp)
                          .copyWith(fontWeight: FontWeight.w400)),
                ),
                // SizedBox(
                //   height: 2.sp,
                // ),
                InkWell(
                  onTap: onTap,
                  child: textWidget(
                      text: AppStrings.getStartedButtonText,
                      style: getLightStyle(fontSize: 10.sp).copyWith(
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      )),
                ),
                // SizedBox(height:5)
              ],
            ),
          ),
          ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderRadius: BorderRadius.all(
              Radius.circular(
                4.r,
              ),
            ),
            child: Image.asset(
              "assets/images/smiles_2.png",
              width: 140.sp,
              height: 125.sp,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget profileOptionsWIdget({
    required String imageUrl,
    required String title,
    void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        child: Row(
          children: [
            SvgPicture.asset(
              imageUrl,
              height: 18.sp,
              width: 20.sp,
              color: primaryColor,
            ),
            SizedBox(
              width: 8.sp,
            ),
            textWidget(text: title, style: getMediumStyle()),
          ],
        ),
      ),
    );
  }
}

AppBar appBar() {
  return gtiAppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: textWidget(
            text: AppStrings.renter,
            textOverflow: TextOverflow.visible,
            style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      ),
      title: null,
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: imageAvatar(
              imgUrl:
                  "https://img.freepik.com/premium-vector/avatar-profile-icon_188544-4755.jpg",
              height: 34.sp,
              width: 34.sp),
        )
      ]);
}
