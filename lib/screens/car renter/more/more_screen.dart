import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20renter/home/paint.dart';
import 'package:gti_rides/screens/car%20renter/more/more_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

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
                      rentVehicleCard(onTap: () {}, height: height),
                      SizedBox(
                        height: 10.sp,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.profileOptions.length,
                        itemBuilder: (context, index) {
                          // show "My Drivers" only if user type is Car Owner
                          final option = controller.profileOptions[index];
                          return profileOptionsWIdget(
                            imageUrl: option['image'],
                            title: option['title'],
                            onTap: () {
                              switch (index) {
                                case 0:
                                  controller.routeToAccountDetails();
                                case 1:
                                  controller.routeToFavorite();
                                case 2:
                                  controller.routeToIdentityVerification();
                                // show "My Drivers" only if user type is Car Owner
                                case 3:
                                  return;
                                case 5:
                                  controller.routeToReferralCode();
                                  break;
                                default:
                              }
                            },
                          );
                        },
                      ),
                      divider(color: borderColor),
                      SizedBox(
                        height: 10.sp,
                      ),
                      InkWell(
                        onTap: () {},
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
                      Text(
                        controller.exampleText.value,
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
                    text: 'Tade Williams',
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
            imgUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ88joJfjwoaz_jWaMQhbZn2X11VHGBzWKiQg&usqp=CAU',
          ),
        ],
      ),
    );
  }

  Widget rentVehicleCard({void Function()? onTap, height}) {
    return Container(
      // height: 125.sp,
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: primaryColorLight,
        borderRadius: BorderRadius.all(
          Radius.circular(4.r),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
              left: 50,
              // right: 0,
              child: Image.asset('assets/images/rent_vehicle_bg.png')),
          Stack(
            children: [
              SizedBox(
                width: 150.sp,
                // height: height,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.sp,
                      ),
                      textWidget(
                          text: AppStrings.rentOutYourVehichle,
                          textOverflow: TextOverflow.visible,
                          style: getSemiBoldStyle(fontSize: 15.sp).copyWith(
                              fontWeight: FontWeight.w600, height: 1.1)),
                      SizedBox(
                        height: 5.sp,
                      ),
                      textWidget(
                          text: AppStrings.youCanListYourCar,
                          textOverflow: TextOverflow.visible,
                          style: getLightStyle(fontSize: 10.sp)
                              .copyWith(fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: 7.sp,
                      ),
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Expanded(
                  //   flex: 3,
                  //   child: SizedBox(
                  //     width: 120.sp,
                  //     // height: height,
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 10, right: 5,),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           textWidget(
                  //               text: AppStrings.rentOutYourVehichle,
                  //               textOverflow: TextOverflow.visible,
                  //               style: getSemiBoldStyle(fontSize: 16.sp).copyWith(
                  //                   fontWeight: FontWeight.w600, )),
                  //           SizedBox(
                  //             height: 7.sp,
                  //           ),
                  //           textWidget(
                  //               text: AppStrings.youCanListYourCar,
                  //                 textOverflow: TextOverflow.visible,
                  //               style: getLightStyle(fontSize: 10.sp)
                  //                   .copyWith(fontWeight: FontWeight.w400)),
                  //           SizedBox(
                  //             height: 7.sp,
                  //           ),
                  //           InkWell(
                  //             onTap: onTap,
                  //             child: textWidget(
                  //                 text: AppStrings.getStartedButtonText,
                  //                 style: getLightStyle(fontSize: 10.sp).copyWith(
                  //                   fontWeight: FontWeight.w700,
                  //                   decoration: TextDecoration.underline,
                  //                 )),
                  //           ),
                  //           // SizedBox(height:5)
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  ClipRRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(
                        4.r,
                      ),
                      bottomRight: Radius.circular(
                        4.r,
                      ),
                    ),
                    child: Image.asset(
                      ImageAssets.ladyHandout,
                      width: 160.sp,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ],
              ),
            ],
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
            text: AppStrings.carRenter,
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
