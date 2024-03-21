import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/rating_model.dart';
import 'package:gti_rides/models/renter/pending_trips_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/renter/trips/trips_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/shimmer_loading/box_shimmer.dart';
import 'package:gti_rides/shared_widgets/tab_indicator.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:intl/intl.dart';

class TripsScreen extends GetView<TripsController> {
  const TripsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("TripScreen called from build");
    final controller = Get.put<TripsController>(TripsController());
    var size = MediaQuery.of(context).size;
    bool expanded = false;

    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 0.sp, horizontal: 20.sp),
                child: Column(
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
                              title: AppStrings.pending,
                              selected: controller.selectedIndex.value == 0,
                              onTap: () {
                                controller.getAllTrips();
                                controller.selectedIndex.value = 0;
                              }),
                          tabIndicator(
                              title: AppStrings.active,
                              selected: controller.selectedIndex.value == 1,
                              onTap: () {
                                controller.getAllTrips();
                                controller.selectedIndex.value = 1;
                              }),
                          tabIndicator(
                            title: AppStrings.completed,
                            selected: controller.selectedIndex.value == 2,
                            onTap: () {
                              controller.getAllTrips();
                              controller.selectedIndex.value = 2;
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5.sp,
                            ),
                            buildBody(size, context, controller, expanded),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            controller.isCheckingCarAvailability.isTrue
                ? Stack(
                    children: [
                      const Opacity(
                        opacity: 0.5,
                        child: ModalBarrier(
                            dismissible: false, color: Colors.black),
                      ),
                      Center(
                        child: Center(child: centerLoadingIcon()),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            controller.isLoading.isTrue
                ? Stack(
                    children: [
                      const Opacity(
                        opacity: 0.5,
                        child: ModalBarrier(
                            dismissible: false, color: Colors.black),
                      ),
                      Center(
                        child: Center(child: centerLoadingIcon()),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            controller.isSendingReview.isTrue
                ? Stack(
                    children: [
                      const Opacity(
                        opacity: 0.5,
                        child: ModalBarrier(
                            dismissible: false, color: Colors.black),
                      ),
                      Center(
                        child: Center(child: centerLoadingIcon()),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
      );
    });
  }

  Widget buildBody(Size size, BuildContext context, TripsController controller,
      bool expanded) {
    switch (controller.selectedIndex.value) {
      case 0:
        return pendingStatusBuild(size, controller, context);
      case 1:
        // active trips
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
                  return ListView.builder(
                    itemCount: controller.activeTrips.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      var activeTrip = controller.activeTrips[index];

                      bool isTripActive =
                          controller.isTripActive(activeTrip.tripEndDate!);

                      return activeAndCompletedCard(
                        key: UniqueKey(),
                        size,
                        imgUrl: activeTrip.carProfilePic.toString(),
                        headerTitle: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textWidget(
                                text: 'Countdown:', style: getRegularStyle()),
                            const SizedBox(width: 4),
                            StreamBuilder<String>(
                                stream:
                                    getCountdownStream(activeTrip.tripEndDate!),
                                builder: (context, snapshot) {
                                  return textWidget(
                                      text: snapshot.data ?? '00:00:00',
                                      // text: controller.startCountdown(
                                      //     activeTrip.tripStartDate!,
                                      //     activeTrip.tripEndDate!),
                                      style: getMediumStyle(fontSize: 16.sp));
                                }),
                          ],
                        ),
                        vehicleName:
                            "${activeTrip.carYear.toString()} ${activeTrip.carBrand.toString()} ${activeTrip.carModel.toString()}",
                        tripStatus: AppStrings.active,
                        button1Title: AppStrings.extend,
                        button1OnTap: () {
                          if (isTripActive == true) {
                            print("object is active");
                          } else {
                            print("object isn't active");
                            extendTimeDialog(size, controller, activeTrip);
                          }
                        },
                        button2Title: AppStrings.return1,
                        button2OnTap: () {
                          if (isTripActive == false) {
                            print("object is active");
                            controller.updateTripStatus(
                                type: 'completed',
                                tripID: activeTrip.tripId.toString());
                          }
                        },
                      );
                    },
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

      case 2:
        // completed trips
        return controller.completedTrips.isEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
                child: Center(
                    child: textWidget(
                        textOverflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                        text: AppStrings.noCompletedTripYet,
                        style: getExtraBoldStyle(fontSize: 18.sp))),
              )
            : controller.obx(
                (state) {
                  return ListView.builder(
                      itemCount: controller.completedTrips.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        var completedTrip = controller.completedTrips[index];
                        return activeAndCompletedCard(
                          key: UniqueKey(),
                          size,
                          imgUrl: completedTrip.carProfilePic.toString(),
                          headerTitle: textWidget(
                              text: 'Completed', style: getRegularStyle()),
                          vehicleName:
                              "${completedTrip.carYear.toString()} ${completedTrip.carBrand.toString()} ${completedTrip.carModel.toString()}",
                          tripStatus: AppStrings.completed,
                          button1Title: AppStrings.seeDetails,
                          button1OnTap: () {
                            // see details
                            controller.routeToCompletedTrip(
                              arguments: {
                                "completedTrip": completedTrip,
                                "showSupport": false
                              },
                            );
                          },
                          button2Title: AppStrings.rateTrip,
                          button2OnTap: () {
                            controller.carId.value = completedTrip.carId;
                            controller.tripId.value = completedTrip.tripId;
                            Get.bottomSheet(
                                backgroundColor: white,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.r),
                                      topRight: Radius.circular(8.r)),
                                ),
                                Container(
                                  padding: EdgeInsets.all(19.sp),
                                  height: size.height * 0.6,
                                  width: size.width,
                                  child: Column(
                                    children: [
                                      textWidget(
                                        text: 'How was your trip experience',
                                        style: getBoldStyle(fontSize: 12.sp),
                                      ),
                                      SizedBox(
                                        height: 20.sp,
                                      ),
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                controller.ratings.length,
                                            itemBuilder: (context, index) {
                                              final rating =
                                                  controller.ratings[index];

                                              // final selectedRating = controller
                                              //     .selectedIndices
                                              //     .contains(index);

                                              final RatingItem ratings =
                                                  controller.ratings1[index];

                                              return AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 40),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 6),
                                                decoration: BoxDecoration(
                                                  // color: selectedRating
                                                  //     ? primaryColorLight2
                                                  //     : pr
                                                  color: ratings.selectedType ==
                                                              RatingType
                                                                  .thumbsUp ||
                                                          ratings.selectedType ==
                                                              RatingType
                                                                  .thumbsDown
                                                      ? primaryColor
                                                      : primaryColorLight2,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(24.r),
                                                  ),
                                                ),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      roundedContainer(
                                                          color: ratings
                                                                      .selectedType ==
                                                                  RatingType
                                                                      .thumbsUp
                                                              ? green
                                                              : white,
                                                          thumb:
                                                              SvgPicture.asset(
                                                            ImageAssets
                                                                .thumbsUpGreen,
                                                            color: ratings
                                                                        .selectedType ==
                                                                    RatingType
                                                                        .thumbsUp
                                                                ? white
                                                                : grey5,
                                                          ),
                                                          onTap: () {
                                                            // controller
                                                            // .toggleSelection(index);
                                                            controller
                                                                .toggleSelection1(
                                                                    index,
                                                                    RatingType
                                                                        .thumbsUp);
                                                            setState(() {});
                                                          }),
                                                      textWidget(
                                                          text: rating,
                                                          style: getRegularStyle(
                                                              color: ratings.selectedType ==
                                                                          RatingType
                                                                              .thumbsUp ||
                                                                      ratings.selectedType ==
                                                                          RatingType
                                                                              .thumbsDown
                                                                  ? white
                                                                  : grey5,
                                                              fontSize: 12.sp)),
                                                      roundedContainer(
                                                          color: ratings
                                                                      .selectedType ==
                                                                  RatingType
                                                                      .thumbsDown
                                                              ? danger
                                                              : white,
                                                          thumb:
                                                              SvgPicture.asset(
                                                            ImageAssets
                                                                .thumbsDown,
                                                            color: ratings
                                                                        .selectedType ==
                                                                    RatingType
                                                                        .thumbsDown
                                                                ? white
                                                                : grey5,
                                                          ),
                                                          onTap: () {
                                                            // controller
                                                            // .toggleSelection(index);
                                                            controller
                                                                .toggleSelection1(
                                                                    index,
                                                                    RatingType
                                                                        .thumbsDown);
                                                            setState(() {});
                                                          })
                                                    ]),
                                              );
                                            });
                                      }),
                                      SizedBox(
                                        height: 30.sp,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // controller.carId.value = completedTrip.carId;
                                          controller.calculateCriterionValues();
                                          Get.bottomSheet(
                                              backgroundColor: white,
                                              isScrollControlled: true,
                                              isDismissible: false,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(8.r),
                                                    topRight:
                                                        Radius.circular(8.r)),
                                              ), StatefulBuilder(
                                                  builder: (context, setState) {
                                            return Container(
                                              padding: EdgeInsets.all(19.sp),
                                              height: size.height * 0.7,
                                              width: size.width,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Spacer(),
                                                          textWidget(
                                                              text: AppStrings
                                                                  .review,
                                                              style: getMediumStyle(
                                                                  color:
                                                                      primaryColor)),
                                                          const Spacer(),
                                                          GestureDetector(
                                                            onTap: controller
                                                                    .isSendingReview
                                                                    .isTrue
                                                                ? () {}
                                                                : controller
                                                                    .goBack,
                                                            child: SvgPicture
                                                                .asset(ImageAssets
                                                                    .closeSmall),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: 110.sp,
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 15,
                                                            horizontal: 15),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 6,
                                                                horizontal: 15),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: primaryColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                4.r),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              controller.totalRatingValue
                                                                          .value ==
                                                                      0
                                                                  ? ImageAssets
                                                                      .thumbsDown
                                                                  : ImageAssets
                                                                      .thumbsUpGreen,
                                                              color: white,
                                                            ),
                                                            const SizedBox(
                                                                width: 13),
                                                            Expanded(
                                                              child: textWidget(
                                                                  text:
                                                                      '${controller.totalRatingValue.toString()}%',
                                                                  textOverflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                  style: getMediumStyle(
                                                                      color:
                                                                          white,
                                                                      fontSize:
                                                                          16.sp)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 20.sp),
                                                      reviews(
                                                        title: AppStrings
                                                            .cleanliness,
                                                        selected: controller
                                                                    .cleanlinessValue
                                                                    .value ==
                                                                '100'
                                                            ? true
                                                            : false,
                                                      ),
                                                      reviews(
                                                        title: AppStrings
                                                            .roadTardiness,
                                                        selected: controller
                                                                    .roadTardinessValue
                                                                    .value ==
                                                                '100'
                                                            ? true
                                                            : false,
                                                      ),
                                                      reviews(
                                                        title: AppStrings
                                                            .convenience,
                                                        selected: controller
                                                                    .convenienceValue
                                                                    .value ==
                                                                '100'
                                                            ? true
                                                            : false,
                                                      ),
                                                      reviews(
                                                        title: AppStrings
                                                            .maintenance,
                                                        selected: controller
                                                                    .maintenanceValue
                                                                    .value ==
                                                                '100'
                                                            ? true
                                                            : false,
                                                      ),
                                                      reviews(
                                                        title: AppStrings
                                                            .fifthPoint,
                                                        selected: controller
                                                                    .fifthPointValue
                                                                    .value ==
                                                                '100'
                                                            ? true
                                                            : false,
                                                      ),
                                                      Form(
                                                        key: controller
                                                            .reviewFormKey,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        child:
                                                            NormalInputTextWidget(
                                                          expectedVariable:
                                                              'field',
                                                          title: '',
                                                          hintText: AppStrings
                                                              .reviewHintText,
                                                          hintTextColor: grey2,
                                                          maxLines: 5,
                                                          controller: controller
                                                              .reviewMessageController,
                                                          filled: true,
                                                          fillColor:
                                                              const Color(
                                                                  0xffF2F2F2),
                                                          border:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                      SizedBox(height: 37.sp),
                                                      controller.isSendingReview
                                                              .isTrue
                                                          ? centerLoadingIcon()
                                                          : GtiButton(
                                                              width: 350,
                                                              text: AppStrings
                                                                  .submit,
                                                              onTap: () async {
                                                                // Future.delayed(Duration(seconds: 5));
                                                                setState(() {});
                                                                var value = await controller
                                                                    .addReview()
                                                                    .then((value) =>
                                                                        setState(
                                                                            () {}));
                                                                print("object");

                                                                // });
                                                              }),
                                                    ]),
                                              ),
                                            );
                                          }));
                                        },
                                        child: textWidget(
                                            text: AppStrings
                                                .continueToLeaveReview,
                                            style: getMediumStyle(
                                                color: primaryColor)),
                                      )
                                    ],
                                  ),
                                ));
                          },
                        );
                      });
                },
                onEmpty: Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
                  child: Center(
                      child: textWidget(
                          textOverflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                          text: AppStrings.noCompletedTripYet,
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

      default:
        return Container();
    }
  }

  Stream<String> getCountdownStream(DateTime endDate) {
    return Stream.periodic(Duration(seconds: 1), (count) {
      DateTime now = DateTime.now().add(Duration(hours: 1));
      endDate = endDate.toLocal();
      // now = now.toLocal();
      Duration difference = endDate.toLocal().difference(now);

      if (difference.isNegative) {
        return '00:00:00';
      } else {
        int hours = difference.inHours;
        int minutes = difference.inMinutes.remainder(60);
        int seconds = difference.inSeconds.remainder(60);
        return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      }
    });
  }

  Widget reviews({
    required String title,
    required bool selected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textWidget(text: title, style: getRegularStyle(fontSize: 12.sp)),
          Row(
            children: [
              SvgPicture.asset(selected
                  ? ImageAssets.filledReviewBar
                  : ImageAssets.emptyReviewBar),
              const SizedBox(
                width: 9,
              ),
              textWidget(
                  text: selected ? "100%" : '  0%',
                  style: getRegularStyle(fontSize: 12.sp)),
            ],
          ),
        ],
      ),
    );
  }

  Widget roundedContainer(
      {required Color color,
      required void Function()? onTap,
      required Widget thumb}) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(6.sp),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: thumb,
      ),
    );
  }

  Widget activeAndCompletedCard(
    Size size, {
    required Key? key,
    required Widget headerTitle,
    required String vehicleName,
    required String tripStatus,
    required String button1Title,
    required String button2Title,
    required void Function()? button1OnTap,
    required void Function()? button2OnTap,
    required String imgUrl,
  }) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.all(
          Radius.circular(6.r),
        ),
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(children: [
        Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Container(
              width: size.width,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(6.r))),
              child: Center(
                // countdown or completed
                child: headerTitle,
              ),
            ),
            Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: SvgPicture.asset(ImageAssets.cardBgSmallLeft,
                    fit: BoxFit.fitWidth)),
            Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: SvgPicture.asset(ImageAssets.cardBgSmallRight,
                    fit: BoxFit.fitWidth)),
          ],
        ),
        SizedBox(
          height: 8.sp,
        ),
        Row(
          children: [
            carImage(
                imgUrl: imgUrl,
                borderRadius: BorderRadius.all(Radius.circular(6.r)),
                width: 78.sp,
                height: 60.sp),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                textWidget(
                  text: vehicleName,
                  style: getBoldStyle().copyWith(
                    fontSize: 16.sp,
                    color: grey4,
                  ),
                ),
                SizedBox(
                  height: 4.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textWidget(
                      text: AppStrings.tripStatus,
                      style: getMediumStyle(
                        fontSize: 12.sp,
                      ).copyWith(),
                    ),
                    SvgPicture.asset(
                      ImageAssets.accessCheck,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 2.sp,
                    ),
                    textWidget(
                      text: tripStatus,
                      style: getMediumStyle(
                        fontSize: 12.sp,
                        color: primaryColor,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 8.sp,
        ),
        Visibility(
          visible: true,
          child: Row(
            children: [
              Expanded(
                child: GtiButton(
                    text: button1Title,
                    textColor: primaryColor,
                    color: backgroundColor,
                    width: 160.sp,
                    hasBorder: true,
                    borderColor: primaryColor,
                    onTap: button1OnTap),
              ),
              SizedBox(
                width: 8.sp,
              ),
              Expanded(
                child: GtiButton(
                    text: button2Title,
                    textColor: primaryColor,
                    color: backgroundColor,
                    width: 160.sp,
                    hasBorder: true,
                    borderColor: primaryColor,
                    onTap: button2OnTap),
              ),
            ],
          ),
        )
      ]),
    );
  }

  Future<dynamic> extendTimeDialog(
      Size size, TripsController controller, AllTripsData activeTrip) {
    return dialogWidgetWithClose(
      size,
      title: '',
      space: 1.sp,
      alignment: Alignment.topCenter,
      onTap: controller.goBack,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          textWidget(
            text: "Extend time",
            style: getMediumStyle(fontSize: 16.sp, color: black),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: AppStrings.note,
                  style: getMediumStyle(fontSize: 12.sp, color: primaryColor),
                  children: <TextSpan>[
                    TextSpan(
                      text: AppStrings.systemWillCheckAvailability,
                      style: getLightStyle(fontSize: 12.sp, color: grey3),
                    )
                  ]),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: NormalInputTextWidget(
                  title: AppStrings.lastDate,
                  expectedVariable: "",
                  hintText: AppStrings.dateTimeHintText,
                  readOnly: true,
                  textInputType: TextInputType.datetime,
                  textColor: primaryColor,
                  fontSize: 12.sp,
                  controller: controller.lastDateTimeController.value
                    ..text = formatDateTime01(date: activeTrip.tripEndDate!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NormalInputTextWidget(
                  title: AppStrings.to,
                  expectedVariable: "",
                  hintText: AppStrings.dateTimeHintText,
                  readOnly: true,
                  fontSize: 12.sp,
                  hintTextColor:
                      controller.dateTimeController.isNull ? null : grey3,
                  textColor: primaryColor,
                  textInputType: TextInputType.datetime,
                  controller: controller.dateTimeController,
                  onTap: () async {
                    var data =
                        await Get.toNamed(AppLinks.chooseTripDate, arguments: {
                      "appBarTitle": AppStrings.tripDate,
                      "to": AppStrings.extendedDate,
                      "from": AppStrings.currentEndDate,
                      "enablePastDates": false,
                      "isSingleDateSelection": true,
                      "isExpiryDateSelection": true,
                      "isExtendTrip": true,
                      "curentEndDate": activeTrip.tripEndDate,
                    });
                    if (data != null) {
                      // Handle the selected date here
                      print('Selected Date page: $data');

                      controller.dateTimeController.text =
                          formatDateTime01(date: data['rawEndTime']);
                      controller.selectedEndDateTime = data["rawEndTime"];
                      controller.tripDays.value = data["tripDays"];
                      controller.currentStartTime = activeTrip.tripEndDate!;
                      // controller.startDateTime.value = data['start'];
                      // controller.endDateTime.value = data['end'];

                      // controller.rawStartTime = data['rawStartTime'];
                      // controller.rawEndTime = data['rawEndTime'];
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GtiButton(
            text: AppStrings.checkAvailability,
            onTap: () async {
              if (controller.selectedEndDateTime == null) {
                showErrorSnackbar(message: "Kindly select an end date");
                return;
              }
              controller.carId.value = activeTrip.carId;
              controller.tripType.value = activeTrip.tripType.toString();
              await controller.getCarHistory(carId: activeTrip.carId);
              var value = await controller.checkCarAvailability(
                  carId: activeTrip.carId.toString(),
                  rawStartTime: activeTrip.tripStartDate!,
                  rawEndTime: controller.selectedEndDateTime!);

              if (value == true) {
                controller.routeToPaymentSummary();
              } else if (value == false) {
                // if car is not available
                Get.dialog(
                  Dialog(
                    backgroundColor: white,
                    // insetPadding: EdgeInsets.all(0),
                    alignment: Alignment.topCenter,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0.r),
                    ), //this right here
                    child: Container(
                      height: 330.sp,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.sp, horizontal: 15.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // cancel or done button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: controller.goBack,
                                  child:
                                      SvgPicture.asset(ImageAssets.closeSmall),
                                ),
                              ],
                            ),
                            SvgPicture.asset(ImageAssets.notAvailable),
                            textWidget(
                              text: AppStrings.carNotAvailable,
                              style:
                                  getMediumStyle(fontSize: 16.sp, color: black),
                            ),
                            // SizedBox(height: 10),
                            textWidget(
                              text: AppStrings.carNotAvailableForExtension,
                              textOverflow: TextOverflow.visible,
                              textAlign: TextAlign.center,
                              style:
                                  getLightStyle(fontSize: 12.sp, color: grey4),
                            ),
                            GtiButton(
                              text: AppStrings.talkToAdmin,
                              onTap: () {},
                            ),
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget pendingStatusBuild(
      size, TripsController controller, BuildContext context) {
    return controller.obx(
      (state) {
        return ListView.builder(
          itemCount: controller.pendingTrips.length,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            var pendingTrips = controller.pendingTrips[index];
            return ExpandableNotifier(
                child: Card(
              // clipBehavior: Clip.antiAlias,
              //  color: white,
              margin: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 0),
              surfaceTintColor: Colors.transparent,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              color: greyLight1,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.sp, horizontal: 8),
                      child: headerCard(size, pendingTrips),
                    ),
                    SizedBox(
                      height: 14.sp,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.sp, horizontal: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(6.r)),
                        child: carImage(
                            height: 65.sp, imgUrl: pendingTrips.carProfilePic),
                      ),
                    ),
                    ScrollOnExpand(
                      scrollOnExpand: true,
                      scrollOnCollapse: false,
                      child: ExpandablePanel(
                        theme: const ExpandableThemeData(
                          iconColor: primaryColor,
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
                          tapBodyToCollapse: true,
                        ),
                        header: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.sp, horizontal: 13),
                          child: textWidget(
                              text: AppStrings.seeBookingDetails,
                              style: getRegularStyle(color: grey4)),
                        ),
                        collapsed: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Visibility(
                              visible: !controller.isExpanded.value,
                              child: Row(
                                children: [
                                  textWidget(
                                    text: AppStrings.estFee,
                                    style: getLightStyle(
                                        fontSize: 10.sp, color: grey2),
                                  ),
                                  SvgPicture.asset(ImageAssets.naira),
                                  textWidget(
                                    text: pendingTrips.totalFee ?? '0',
                                    style:
                                        getRegularStyle(color: secondaryColor)
                                            .copyWith(fontFamily: 'Neue'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8.sp,
                            ),
                            continueButton(controller, pendingTrips),
                          ],
                        ),
                        expanded: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                dateTimeColWIdget(
                                    alignment: CrossAxisAlignment.start,
                                    title: formatDayDate(
                                        pendingTrips.tripStartDate!),
                                    subTitle: formatTime(
                                        pendingTrips.tripStartDate!)),
                                SvgPicture.asset(
                                  ImageAssets.arrowForwardRounded,
                                  height: 24.sp,
                                  width: 24.sp,
                                  color: primaryColor,
                                ),
                                dateTimeColWIdget(
                                    alignment: CrossAxisAlignment.end,
                                    title: formatDayDate(
                                        pendingTrips.tripEndDate!),
                                    subTitle:
                                        formatTime(pendingTrips.tripEndDate!)),
                              ],
                            ),
                            divider(color: borderColor),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  // crossAxisAlignment: alignment,
                                  children: [
                                    SvgPicture.asset(ImageAssets.naira),
                                    textWidget(
                                        text: pendingTrips
                                                .tripOrders!.first.pricePerDay
                                                .toString() ??
                                            '',
                                        style: getRegularStyle(color: grey5)),
                                    // textWidget(
                                    //     text: ' x ', style: getRegularStyle()),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    SvgPicture.asset(
                                      ImageAssets.closeSmall,
                                      width: 7.sp,
                                      height: 7.sp,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    textWidget(
                                        text:
                                            '${pendingTrips.tripOrders!.first.tripsDays} ${int.parse(pendingTrips.tripOrders!.first.tripsDays) > 1 ? 'days' : 'day'}',
                                        style: getRegularStyle(color: grey5)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(ImageAssets.naira),
                                    textWidget(
                                        text: pendingTrips
                                            .tripOrders!.first.pricePerDayTotal
                                            .toString(),
                                        style: getRegularStyle(color: grey5)),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.sp,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  // crossAxisAlignment: alignment,
                                  children: [
                                    textWidget(
                                        text: 'Discount',
                                        style: getRegularStyle(color: grey5)),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    textWidget(
                                        text: '- ',
                                        style: getRegularStyle(color: grey5)),
                                    SvgPicture.asset(ImageAssets.naira),
                                    textWidget(
                                        text: pendingTrips.tripOrders!.first
                                            .discountPerDayTotal
                                            .toString(),
                                        style: getRegularStyle(color: grey5)),
                                  ],
                                ),
                              ],
                            ),
                            rowNairaText(
                                title: 'VAT',
                                subTitle: pendingTrips.tripOrders!.first.vatFee
                                        .toString() ??
                                    ''),
                            Visibility(
                                visible: pendingTrips
                                            .tripOrders!.first.pickUpFee
                                            .toString() ==
                                        '0'
                                    ? false
                                    : true,
                                child: rowNairaText(
                                    title: 'Pick up',
                                    subTitle: pendingTrips
                                        .tripOrders!.first.pickUpFee
                                        .toString())),
                            Visibility(
                                visible: pendingTrips
                                            .tripOrders!.first.dropOffFee
                                            .toString() ==
                                        '0'
                                    ? false
                                    : true,
                                child: rowNairaText(
                                    title: 'Drop off',
                                    subTitle: pendingTrips
                                        .tripOrders!.first.dropOffFee
                                        .toString())),
                            Visibility(
                                visible: pendingTrips
                                            .tripOrders!.first.escortFee
                                            .toString() ==
                                        '0'
                                    ? false
                                    : true,
                                child: rowNairaText(
                                    title: 'Escort',
                                    subTitle: pendingTrips
                                        .tripOrders!.first.escortFee
                                        .toString())),
                            Visibility(
                                visible: pendingTrips.tripType.toString() ==
                                        'self drive'
                                    ? true
                                    : false,
                                child: rowNairaText(
                                    title: 'Caution fee',
                                    subTitle: pendingTrips
                                        .tripOrders!.first.cautionFee
                                        .toString())),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 9),
                              decoration: BoxDecoration(
                                  color: primaryColorLight.withOpacity(0.1)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    // crossAxisAlignment: alignment,
                                    children: [
                                      textWidget(
                                          text: 'Total:',
                                          style: getRegularStyle(
                                                  color: primaryColor)
                                              .copyWith(
                                                  fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        ImageAssets.naira,
                                        color: primaryColor,
                                      ),
                                      textWidget(
                                          text: pendingTrips.totalFee ?? '0',
                                          style: getRegularStyle(
                                                  color: primaryColor)
                                              .copyWith(
                                                  fontFamily: "Neue",
                                                  fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 14.sp,
                            ),
                            continueButton(controller, pendingTrips),
                          ],
                        ),
                        builder: (_, collapsed, expanded) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Expandable(
                              collapsed: collapsed,
                              expanded: expanded,
                              theme:
                                  const ExpandableThemeData(crossFadePoint: 0),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ));
          },
        );
      },
      onEmpty: Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
        child: Center(
            child: textWidget(
                textOverflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                text: AppStrings.noPendingCarsYet,
                style: getExtraBoldStyle(fontSize: 18))),
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
  }

  Widget rowNairaText({
    required String title,
    required String subTitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            // crossAxisAlignment: alignment,
            children: [
              textWidget(text: title, style: getRegularStyle(color: grey5)),
            ],
          ),
          Row(
            children: [
              SvgPicture.asset(ImageAssets.naira),
              textWidget(text: subTitle, style: getRegularStyle(color: grey5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget dateTimeColWIdget({
    required String title,
    required String subTitle,
    required CrossAxisAlignment alignment,
  }) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        textWidget(
            text: title,
            style: getBoldStyle(
              fontSize: 14.sp,
            )),
        textWidget(text: subTitle, style: getRegularStyle()),
      ],
    );
  }

  Widget headerCard(Size size, AllTripsData pendingTrips) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.sp),
      child: Stack(
        children: [
          Container(
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 60.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(4.r),
                ),
                color: primaryColor),
            child: SizedBox(
              width: 60.sp,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textWidget(
                    text:
                        "${pendingTrips.carYear.toString()} ${pendingTrips.carBrand.toString()} ${pendingTrips.carModel.toString()}",
                    style: getBoldStyle().copyWith(
                      fontSize: 16.sp,
                      color: white,
                      fontFamily: 'Neue',
                    ),
                  ),
                  SizedBox(
                    height: 8.sp,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget(
                        text: AppStrings.orderStatus,
                        style: getMediumStyle(fontSize: 12.sp).copyWith(),
                      ),
                      SvgPicture.asset(
                        pendingTrips.status == "pending"
                            ? ImageAssets.pending
                            : ImageAssets.accessCheck,
                        color: grey4,
                      ),
                      SizedBox(
                        width: 2.sp,
                      ),
                      textWidget(
                        text: pendingTrips.adminStatus ?? pendingTrips.status,
                        //  pendingTrips.status.toString(),
                        style: getMediumStyle(fontSize: 12.sp)
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: SvgPicture.asset(
              ImageAssets.carResultBg,
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SvgPicture.asset(
              ImageAssets.carResultBg1,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }

  Widget continueButton(TripsController controller, AllTripsData pendingTrips) {
    // this is dependent if the trips start date is above DateTime.now()
    bool statTrip = controller.isTripActive(
        pendingTrips.tripOrders?.first.tripStartDate ?? DateTime.now());
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 40.sp,
            width: 300.sp,
            text: getPendingTripsStatusMessage(pendingTrips),
            color: primaryColor,
            isDisabled: shouldButtonBeDisabled(pendingTrips),
            disabledColor: (pendingTrips.tripType == "self drive" &&
                    pendingTrips.adminStatus == "pending")
                ? white
                : primaryColorLight,
            disabledTextColor: (pendingTrips.tripType == "self drive" &&
                    pendingTrips.adminStatus == "pending")
                ? primaryColorLight
                : grey5,
            onTap: () {
             
              switch (pendingTrips.status) {
                case "pending":
                  if (pendingTrips.tripType == 'chauffeur') {
                    if (pendingTrips.tripOrders!.first.paymentStatus ==
                        'pending') {
                      // payNowMethod();
                      controller.routeToPayment(
                          url: pendingTrips.tripOrders!.first.paymentLink);
                    } else if (pendingTrips.tripOrders!.first.paymentStatus ==
                        'successful') {
                      !statTrip
                          ? () {}
                          : controller.updateTripStatus(
                              type: 'active',
                              tripID: pendingTrips.tripId.toString());
                      print("object");
                    } else {
                      // chat with admin
                    }
                  } else {
                    if (pendingTrips.adminStatus == "approved") {
                      // payNowMethod();
                      controller.routeToPayment(
                          url: pendingTrips.tripOrders!.first.paymentLink);
                    } else if (pendingTrips.tripOrders!.first.paymentStatus
                        .toString()
                        .contains("successful")) {
                      controller.updateTripStatus(
                          type: 'active',
                          tripID: pendingTrips.tripId.toString());
                      print("confirm");
                      // confirm trip button
                    } else {
                      //chat with admin action
                    }
                  }
                  break;
                case "declined":
                  // chatWithAdminMethod();
                  break;
                // Add more cases if needed
                default:
                  break;
              }
            },

            // onTap: controller.routeToPhoneVerification,
            isLoading: controller.isLoading.value,
          );
  }

  String getPendingTripsStatusMessage(AllTripsData pendingTrips) {
    if (pendingTrips.status == "pending") {
      if (pendingTrips.tripType == 'chauffeur') {
        // if status == 'pending' && paymentStatus == 'pending' ? 'pay'

        if (pendingTrips.tripOrders!.first.paymentStatus == 'pending') {
          return AppStrings.payNow;
        } else if (pendingTrips.tripOrders!.first.paymentStatus ==
            'successful') {
          return "Confirm Trip";
        } else {
          return 'Chat with admin';
        }
      } else {
        if (pendingTrips.adminStatus == "pending") {
          return "Pending admin approval";
        } else if (pendingTrips.adminStatus == "approved" &&
            pendingTrips.tripOrders!.first.paymentStatus == 'pending') {
          //
          return AppStrings.payNow;
          // what about if self drive and status is approved ?
        } else if (pendingTrips.tripOrders!.first.paymentStatus ==
            'successful') {
          return "Confirm Trip";
        } else {
          // if the status is none of the above show 'chat with admin'
          return 'Chat with admin';
        }
      }
    } else if (pendingTrips.status == "declined") {
      return 'Chat with admin';
    }
    return "null";
  }

  bool shouldButtonBeDisabled(AllTripsData pendingTrips) {
    return (pendingTrips.tripType == "self drive" &&
        pendingTrips.adminStatus == "pending");
    //      ||
    // pendingTrips.status == 'declined';
  }
}

enum PaymentStatus {
  pending,
  successful,
  // add other possible values if needed
}

//       switch (pendingTrips.tripOrders!.first.paymentStatus) {
//   case PaymentStatus.pending:
//     return AppStrings.payNow;
//   case PaymentStatus.successful:
//     return "Confirm Trip";
//   default:
//     return 'Chat with admin';
// }
