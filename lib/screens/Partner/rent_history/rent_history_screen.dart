import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/pending_trips_model.dart';
import 'package:gti_rides/screens/Partner/home/manage_vehicle/manage_vehicle_controller.dart';
import 'package:gti_rides/screens/Partner/rent_history/rent_history_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/shimmer_loading/box_shimmer.dart';
import 'package:gti_rides/shared_widgets/tab_indicator.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:iconsax/iconsax.dart';

class RentHistoryBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<RentHistoryController>(RentHistoryController());
  }

  // final controller = RentHistoryController();
}

class RentHistoryScreen extends GetView<RentHistoryController> {
  RentHistoryScreen([Key? key]) : super(key: key);
  final controller = Get.put<RentHistoryController>(RentHistoryController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(() => Scaffold(
          // body: body(size, context)),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, top: 13.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                          title: AppStrings.active,
                          selected: controller.selectedIndex.value == 0,
                          onTap: () {
                            controller.selectedIndex.value = 0;
                            controller.getAllTrips();
                          },
                        ),
                        tabIndicator(
                          width: 150.sp,
                          title: AppStrings.completed,
                          selected: controller.selectedIndex.value == 1,
                          onTap: () {
                            controller.selectedIndex.value = 1;
                            controller.getAllTrips();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.sp,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildBody(controller, context, size),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // }
        ));
  }

  Widget buildBody(
      RentHistoryController controller, BuildContext context, Size size) {
    switch (controller.selectedIndex.value) {
      case 0:
        // Active trips
        return controller.activeTrips.isEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
                child: Center(
                    child: textWidget(
                        textOverflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                        text: AppStrings.noActiveTripsYet,
                        style: getExtraBoldStyle(fontSize: 18.sp))),
              )
            : controller.obx(
                (state) {
                  return ListView.separated(
                    physics: const ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: controller.activeTrips.length,
                    itemBuilder: (context, index) {
                      var activeTrip = controller.activeTrips[index];
                      return cardWidget(
                        context,
                        size,
                        onTap: () =>
                            controller.routeToCompletedTrip(arguments: {
                          "completedTrip": activeTrip,
                          "tripId": activeTrip.tripId
                        }),
                        imgUrl: activeTrip.carProfilePic.toString(),
                        title:
                            ' ${activeTrip.carBrand.toString()} ${activeTrip.carModel.toString()}',
                        amount:
                            '${activeTrip.tripOrders!.first.pricePerDay.toString()} ',
                        noOfDays: activeTrip.tripOrders!.first.tripsDays == 1
                            ? "day"
                            : 'days',
                        startDateTime: formateDate(
                            date: activeTrip.tripOrders!.first.tripStartDate!
                                .toIso8601String()),
                        endDateTime: formateDate(
                            date: activeTrip.tripOrders!.first.tripEndDate!
                                .toIso8601String()),
                        trailling: Positioned(
                          right: 12.sp,
                          top: 12.sp,
                          child: InkWell(
                              onTap: () {
                                quickOptionsSheet(size, activeTrip);
                              },
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      SvgPicture.asset(ImageAssets.popUpMenu))),
                        ),
                      );
                    },
                    separatorBuilder: (context, _) =>
                        const SizedBox(height: 15),
                  );
                },
                onEmpty: Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
                  child: Center(
                      child: textWidget(
                          textOverflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                          text: AppStrings.noActiveTripsYet,
                          style: getExtraBoldStyle(fontSize: 18.sp))),
                ),
                onError: (e) => Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: context.height * 0.1, horizontal: 20),
                  child: Center(
                    child: Text(
                      "$e",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onLoading: boxShimmer(height: 200.sp),
              );

      case 1:
        // Completed trips
        return controller.completedTrips.isEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
                child: Center(
                  child: textWidget(
                    textOverflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    text: AppStrings.noCompletedOrderYet,
                    style: getExtraBoldStyle(fontSize: 18.sp),
                  ),
                ),
              )
            : controller.obx(
                (statet) {
                  return ListView.separated(
                    itemCount: controller.completedTrips.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var completedTrip = controller.completedTrips[index];
                      return cardWidget(
                        context,
                        size,
                        onTap: () =>
                            controller.routeToCompletedTrip(arguments: {
                          "completedTrip": completedTrip,
                          "tripId": completedTrip.tripId
                        }),
                        imgUrl: completedTrip.carProfilePic.toString(),
                        title:
                            ' ${completedTrip.carBrand.toString()} ${completedTrip.carModel.toString()}',
                        amount:
                            '${completedTrip.tripOrders!.first.pricePerDay.toString()} ',
                        noOfDays:
                            '${completedTrip.tripOrders!.first.tripsDays.toString()}days',
                        startDateTime: formateDate(
                            date: completedTrip.tripOrders!.first.tripStartDate!
                                .toIso8601String()),
                        endDateTime: formateDate(
                            date: completedTrip.tripOrders!.first.tripEndDate!
                                .toIso8601String()),
                        trailling: Positioned(
                          right: 7.sp,
                          top: 11.sp,
                          child: InkWell(
                            onTap: () =>
                                controller.routeToCompletedTrip(arguments: {
                              "completedTrip": completedTrip,
                              "tripId": completedTrip.tripId
                            }),
                            child: Row(children: [
                              textWidget(
                                  text: AppStrings.completed,
                                  style: getRegularStyle(
                                      fontSize: 10.sp, color: primaryColor)),
                              const Icon(
                                Iconsax.arrow_right_3,
                                color: primaryColor,
                                size: 12,
                              )
                            ]),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, _) =>
                        const SizedBox(height: 15),
                  );
                },
                onEmpty: Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
                  child: Center(
                    child: textWidget(
                      textOverflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      text: AppStrings.noCompletedTripYet,
                      style: getExtraBoldStyle(fontSize: 18.sp),
                    ),
                  ),
                ),
                onError: (e) => Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: context.height * 0.1, horizontal: 20),
                  child: Center(
                    child: Text(
                      "$e",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onLoading: boxShimmer(height: 200.sp),
              );

      default:
        return const SizedBox();
    }
  }

  Widget cardWidget(context, Size size,
      {required String title,
      required String amount,
      required String noOfDays,
      required String startDateTime,
      required String endDateTime,
      required Widget trailling,
      required String imgUrl,
      void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Stack(
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
                    // ClipRRect(
                    //   borderRadius: BorderRadius.only(
                    //       topLeft: Radius.circular(4.r),
                    //       bottomLeft: Radius.circular(4.r)),
                    //   child: Image.asset(
                    //     'assets/images/fav_car.png',
                    //     fit: BoxFit.fitHeight,
                    //   ),
                    // ),
                    carImage(imgUrl: imgUrl, height: 90.sp, width: 80.sp),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
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
                            textWidget(text: title, style: getBoldStyle()),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              // crossAxisAlignment: alignment,
                              children: [
                                SvgPicture.asset(ImageAssets.naira),
                                textWidget(
                                    text: amount,
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
                                    text: ' $noOfDays',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textWidget(
                                    text: startDateTime,
                                    textOverflow: TextOverflow.visible,
                                    style: getMediumStyle(fontSize: 8.sp)
                                        .copyWith(fontFamily: 'Neue')),
                                SizedBox(width: 2),
                                SvgPicture.asset(
                                  ImageAssets.arrowForwardRounded,
                                  height: 8.sp,
                                  width: 8.sp,
                                ),
                                SizedBox(width: 2),
                                textWidget(
                                    text: endDateTime,
                                    textOverflow: TextOverflow.visible,
                                    style: getMediumStyle(fontSize: 8.sp)
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
          trailling
        ],
      ),
    );
  }

  Future<dynamic> quickOptionsSheet(Size size, AllTripsData activeTrip) {
    return Get.bottomSheet(
      SizedBox(
        height: size.height * 0.2.sp,
        width: size.width.sp,
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          itemCount: controller.quickOptions.length,
          itemBuilder: (context, index) {
            final option = controller.quickOptions[index];
            return InkWell(
              onTap: () {
                switch (index) {
                  case 0:
                  // report trip to admin;

                  case 1:
                    controller.routeToCompletedTrip(arguments: {
                      "completedTrip": activeTrip,
                      "tripId": activeTrip.tripId
                    });
                    break;
                  default:
                }
              },
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
          separatorBuilder: (context, index) => const SizedBox(
            height: 18,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.r), topRight: Radius.circular(4.r)),
      ),
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
