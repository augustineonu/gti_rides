import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20owner/home/manage_vehicle/manage_vehicle_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/tab_indicator.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class ManageVehicleBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ManageVehicleController>(ManageVehicleController());
  }
}

class ManageVehicleScreen extends GetView<ManageVehicleController> {
  const ManageVehicleScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // final controller = Get.put<ManageVehicleController>(ManageVehicleController());
    return Obx(() => Scaffold(
          appBar: appBar(),
          // body: body(size, context)),
          body: Padding(
            padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, top: 13.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                textWidget(
                    text: controller.testString.value,
                    style: getRegularStyle()),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(6.sp),
                  decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.all(Radius.circular(4.r))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      tabIndicator(
                          width: 150.sp,
                          title: AppStrings.allCarsSm,
                          selected: controller.selectedIndex.value == 0,
                          onTap: () => controller.selectedIndex.value = 0),
                      tabIndicator(
                          width: 150.sp,
                          title: AppStrings.booked,
                          selected: controller.selectedIndex.value == 1,
                          onTap: () => controller.selectedIndex.value = 1),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.sp,
                ),
                buildBody(context, size),
              ],
            ),
          ),
          // }
        ));
  }

  Widget buildBody(context, Size size) {
    switch (controller.selectedIndex.value) {
      case 0:
        return Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: greyLight),
                  borderRadius: BorderRadius.all(Radius.circular(4.r))),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.r),
                            bottomLeft: Radius.circular(4.r)),
                        child: Image.asset(
                          'assets/images/fav_car.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Positioned(
                        left: 10,
                        right: 10,
                        top: 25,
                        bottom: 25,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 4),
                          decoration: BoxDecoration(
                            color: black.withOpacity(0.4),
                            borderRadius: BorderRadius.all(
                              Radius.circular(2.r),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(2.r),
                                ),
                                border: Border.all(
                                  color: primaryColor,
                                )),
                            child: Center(
                              child: textWidget(
                                text: 'Car status: \n booked',
                                textAlign: TextAlign.center,
                                style: getLightStyle(
                                        fontSize: 10.sp, color: primaryColor)
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          // width: 135.sp,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget(
                                  text: 'Tesla Model Y', style: getBoldStyle()),
                              const SizedBox(
                                height: 3,
                              ),
                              Row(
                                // crossAxisAlignment: alignment,
                                children: [
                                  SvgPicture.asset(ImageAssets.naira),
                                  textWidget(
                                      text: '100,000 ',
                                      style: getMediumStyle(fontSize: 10.sp)
                                          .copyWith(fontFamily: 'Neue')),
                                  // textWidget(
                                  //     text: ' x ', style: getMediumStyle(fontSize: 10.sp).copyWith(fontFamily: 'Neue')),
                                  SvgPicture.asset(
                                    ImageAssets.closeSmall,
                                    width: 7.sp,
                                    height: 7.sp,
                                  ),
                                  textWidget(
                                      text: ' 5days',
                                      style: getMediumStyle(fontSize: 10.sp)
                                          .copyWith(fontFamily: 'Neue')),
                                ],
                              ),

                              /// Show the thumbs up and number trips
                              //  Row(
                              //       children: [
                              //         SvgPicture.asset(
                              //             ImageAssets.thumbsUpPrimaryColor),
                              //         SizedBox(
                              //           width: 5.sp,
                              //         ),
                              //         RichText(
                              //           text: TextSpan(
                              //               text: '97%',
                              //               style: getMediumStyle(
                              //                 fontSize: 12.sp,
                              //               ),
                              //               children: <TextSpan>[
                              //                 TextSpan(
                              //                   text: ' (66 trips)',
                              //                   style: getLightStyle(
                              //                       fontSize: 12.sp, color: grey2),
                              //                 )
                              //               ]),
                              //         ),
                              //       ],
                              //     ),

                              ////////
                              const SizedBox(
                                height: 10,
                              ),

                              textWidget(
                                text: AppStrings.tripDate,
                                // show AppStrings.aAvailabilityDate
                                style: getRegularStyle(
                                  color: grey3,
                                  fontSize: 10.sp,
                                ),
                              ),

                              const SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidget(
                                      text: "wed, 1 Nov, 9:00am",
                                      style: getMediumStyle(fontSize: 10.sp)
                                          .copyWith(fontFamily: 'Neue')),
                                  SvgPicture.asset(
                                    ImageAssets.arrowForwardRounded,
                                    height: 8.sp,
                                    width: 8.sp,
                                  ),
                                  textWidget(
                                      text: "wed, 1 Nov, 9:00am",
                                      style: getMediumStyle(fontSize: 10.sp)
                                          .copyWith(fontFamily: 'Neue')),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 12.sp,
              top: 12.sp,
              child: InkWell(
                  onTap: () {
                    quickOptionsSheet(size);
                  },
                  child: SizedBox(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset(ImageAssets.popUpMenu))),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Future<dynamic> quickOptionsSheet(Size size) {
    return Get.bottomSheet(
      SizedBox(
        height: 180.sp,
        width: size.width.sp,
        child: Column(children: [
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            itemCount: controller.quickOptions.length,
            itemBuilder: (context, index) {
              final option = controller.quickOptions[index];
              return InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    SvgPicture.asset(option['imageUrl']!),
                    const SizedBox(
                      width: 6,
                    ),
                    textWidget(
                        text: option['title'],
                        style: getRegularStyle(color: primaryColor)),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 18,
            ),
          )
        ]),
      ),
      backgroundColor: backgroundColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.r), topRight: Radius.circular(4.r)),
      ),
    );
  }

  AppBar appBar() {
    return gtiAppBar(
      onTap: controller.goBack,
      leading: const Icon(Icons.arrow_back),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.manageCars,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget continueButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 50.sp,
            width: 3000.sp,
            text: "continue".tr,
            color: primaryColor,
            // onTap: controller.routeToPhoneVerification,
            isLoading: controller.isLoading.value,
          );
  }
}
