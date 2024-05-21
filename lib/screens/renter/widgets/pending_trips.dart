import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/pending_trips_model.dart';
import 'package:gti_rides/screens/renter/trips/trips_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/shimmer_loading/box_shimmer.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class PendingTrips extends StatelessWidget {
  PendingTrips({super.key, required this.controller});
  final TripsController controller;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return controller.obx(
      (state) {
        return ListView.builder(
          itemCount: controller.pendingTrips.length,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            var pendingTrips = controller.pendingTrips[index];
            // pendingTrips.tripOrders.first
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
                    Builder(builder: (context) {
                      return ScrollOnExpand(
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
                                      text: pendingTrips.totalFee.toString() ??
                                          '0',
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  continueButton(
                                      controller, pendingTrips, context),
                                ],
                              ),
                            ],
                          ),
                          expanded: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      subTitle: formatTime(
                                          pendingTrips.tripEndDate!)),
                                ],
                              ),
                              divider(color: borderColor),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          text: pendingTrips.tripOrders!.first
                                              .pricePerDayTotal
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  subTitle: pendingTrips
                                          .tripOrders!.first.vatFee
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
                                  visible: pendingTrips.tripType ==
                                              "selfDrive" ||
                                          pendingTrips.tripType.toString() ==
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
                                                    fontWeight:
                                                        FontWeight.w700)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          ImageAssets.naira,
                                          color: primaryColor,
                                        ),
                                        textWidget(
                                            text: pendingTrips.totalFee
                                                    .toString() ??
                                                '0',
                                            style: getRegularStyle(
                                                    color: primaryColor)
                                                .copyWith(
                                                    fontFamily: "Neue",
                                                    fontWeight:
                                                        FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 14.sp,
                              ),
                              continueButton(controller, pendingTrips, context),
                            ],
                          ),
                          builder: (_, collapsed, expanded) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Expandable(
                                collapsed: collapsed,
                                expanded: expanded,
                                theme: const ExpandableThemeData(
                                    crossFadePoint: 0),
                              ),
                            );
                          },
                        ),
                      );
                    }),
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

  Widget continueButton(TripsController controller, AllTripsData pendingTrips,
      BuildContext context) {
    // this is dependent if the trips start date is above DateTime.now()
    bool startTrip = controller.isTripActive(
        pendingTrips.tripOrders?.first.tripStartDate ?? DateTime.now());
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 40.sp,
            width: MediaQuery.of(context).size.width.sp - 60.sp,
            text: getPendingTripsStatusMessage(pendingTrips),
            color: primaryColor,
            isDisabled: shouldButtonBeDisabled(pendingTrips),
            disabledColor: (pendingTrips.tripType == "selfDrive" ||
                    pendingTrips.tripType == "self drive" &&
                        pendingTrips.adminStatus == "pending")
                ? white
                : primaryColorLight,
            disabledTextColor: (pendingTrips.tripType == "selfDrive" ||
                    pendingTrips.tripType == "self drive" &&
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
                    } else if (pendingTrips.tripOrders!.first.paymentStatus
                            .toString() ==
                        'success') {
                      if (startTrip == true) {
                        // () {};
                        print("do nothing ");
                      } else {
                        print("start trip is true ");
                        controller.updateTripStatus(
                            type: 'active',
                            tripID: pendingTrips.tripId.toString());
                      }
                    } else {
                      // chat with admin
                      controller.launchMessenger();
                    }
                  } else {
                    if (pendingTrips.adminStatus == "approved" && pendingTrips.tripOrders!.first.paymentStatus == "pending") {
                      // payNowMethod();
                      controller.routeToPayment(
                          url: pendingTrips.tripOrders!.first.paymentLink);
                    } else if (pendingTrips.tripOrders!.first.paymentStatus
                        .toString()
                        .contains("success")) {
                      controller.updateTripStatus(
                          type: 'active',
                          tripID: pendingTrips.tripId.toString());
                      print("confirm");
                      // confirm trip button
                    } else {
                      print("object");
                      //chat with admin action
                      controller.launchMessenger();
                    }
                  }
                  break;
                case "declined":
                  print("object>>");
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
        } else if (pendingTrips.tripOrders!.first.paymentStatus == 'success') {
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
        } else if (pendingTrips.tripOrders!.first.paymentStatus == 'success') {
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
    return (pendingTrips.tripType == "selfDrive" &&
        pendingTrips.tripType == "self drive" &&
            pendingTrips.adminStatus == "pending");
    //      ||
    // pendingTrips.status == 'declined';
  }
}
