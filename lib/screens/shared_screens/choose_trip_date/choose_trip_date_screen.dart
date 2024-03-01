import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/choose_trip_date/am_pm.dart';
import 'package:gti_rides/screens/shared_screens/choose_trip_date/choose_trip_date_controller.dart';
import 'package:gti_rides/screens/shared_screens/choose_trip_date/hours.dart';
import 'package:gti_rides/screens/shared_screens/choose_trip_date/minutes.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ChooseTripDateBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ChooseTripDateController>(ChooseTripDateController());
  }
}

class ChooseTripDateScreen extends GetView<ChooseTripDateController> {
  ChooseTripDateScreen({
    this.appBarTitle,
  });

  final String? appBarTitle;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final controller = Get.put(ChooseTripDateController());
    return Obx(() => Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar(context, controller),
          // body: body(size, context, controller)),
          body: SingleChildScrollView(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 24.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerCard(controller),

                  SizedBox(
                    height: 30.h,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SfDateRangePicker(
                      backgroundColor: backgroundColor,
                      todayHighlightColor: primaryColor,
                      showNavigationArrow: true,
                      toggleDaySelection: controller.toggleDaySelection.value,
                      view: DateRangePickerView.month,
                      controller: controller.datePickerController,
                      allowViewNavigation: true,
                      selectionMode: controller.isSingleDateSelection.value
                          ? DateRangePickerSelectionMode.single
                          : DateRangePickerSelectionMode.range,
                      enablePastDates: controller.enablePastDates.value,
                      onCancel: controller.onCancelCalled.value
                          ? () {
                              bottomSnackbar(context,
                                  message: 'Selection Cancelled');
                            }
                          : () {
                              bottomSnackbar(context,
                                  message: 'Selection Cancelled');
                            },
                      onSubmit: controller.isSingleDateSelection.value
                          ? (value) {
                              controller.goBack1();
                            }
                          : (value) async {
                              Get.dialog(
                                
                                StatefulBuilder(builder: (context, setState) {
                                  return Dialog(
                                    
                                    backgroundColor: white,
                                    insetPadding: const EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            2.0.r)), //this right here
                                    child: Container(
                                      height: 230.sp,
                                      width: double.infinity,
                                      color: white,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 22),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // start time
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        textWidget(
                                                            text: AppStrings
                                                                .startTime,
                                                            style:
                                                                getMediumStyle(
                                                                    fontSize:
                                                                        12.sp)),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 14,
                                                    ),
                                                    Row(
                                                      children: [
                                                        // Hours wheel
                                                        timeWheelPicker(
                                                          setState,
                                                          onSelectedItemChanged:
                                                              (value) {
                                                            print(
                                                                "selected $value");
                                                            controller
                                                                .onSelectedStartHourChanged(
                                                                    value);
                                                            setState(() {});
                                                          },
                                                          childCount: 13,
                                                          builder:
                                                              (context, index) {
                                                            bool isSelected =
                                                                index ==
                                                                    controller
                                                                        .selectedStartHour
                                                                        .value;
                                                            return timeWidget(
                                                                isSelected:
                                                                    isSelected,
                                                                item: Hours(
                                                                  hours: index,
                                                                  color: isSelected
                                                                      ? primaryColor
                                                                      : grey5,
                                                                  fontWeight: isSelected
                                                                      ? FontWeight
                                                                          .w800
                                                                      : null,
                                                                ));
                                                          },
                                                        ),
                                                        // Minutes wheel
                                                        timeWheelPicker(
                                                          setState,
                                                          onSelectedItemChanged:
                                                              (value) {
                                                            print(
                                                                "selected $value");
                                                            controller
                                                                .onSelectedStartMinsChanged(
                                                                    value);
                                                            setState(() {});
                                                          },
                                                          childCount: 60,
                                                          builder:
                                                              (context, index) {
                                                            bool isSelected =
                                                                index ==
                                                                    controller
                                                                        .selectedStartMinute
                                                                        .value;
                                                            return timeWidget(
                                                                isSelected:
                                                                    isSelected,
                                                                item: Minutes(
                                                                  mins: index,
                                                                  color: isSelected
                                                                      ? primaryColor
                                                                      : grey5,
                                                                  fontWeight: isSelected
                                                                      ? FontWeight
                                                                          .w800
                                                                      : null,
                                                                ));
                                                          },
                                                        ),

                                                        // AM or PM
                                                        timeWheelPicker(
                                                          setState,
                                                          onSelectedItemChanged:
                                                              (value) {
                                                            print(
                                                                "selected $value");
                                                            controller
                                                                .onSelectedStartAmPmChanged(
                                                                    value);
                                                            setState(() {});
                                                          },
                                                          childCount: 2,
                                                          builder:
                                                              (context, index) {
                                                            bool isSelected =
                                                                index ==
                                                                    controller
                                                                        .selectedStartAmPm
                                                                        .value;
                                                            bool isItAm =
                                                                index == 0;
                                                            return timeWidget(
                                                                isSelected:
                                                                    isSelected,
                                                                item: AmPm(
                                                                  isItAm:
                                                                      isItAm,
                                                                  color: isSelected
                                                                      ? primaryColor
                                                                      : grey5,
                                                                  fontWeight: isSelected
                                                                      ? FontWeight
                                                                          .w800
                                                                      : null,
                                                                ));
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                                // end time
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        textWidget(
                                                            text: AppStrings
                                                                .endTime,
                                                            style:
                                                                getMediumStyle(
                                                                    fontSize:
                                                                        12.sp)),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 14,
                                                    ),
                                                    Row(
                                                      children: [
                                                        // Hours wheel
                                                        timeWheelPicker(
                                                          setState,
                                                          onSelectedItemChanged:
                                                              (value) {
                                                            controller
                                                                .onSelectedEndHourChanged(
                                                                    value);
                                                            setState(() {});
                                                          },
                                                          childCount: 13,
                                                          builder:
                                                              (context, index) {
                                                            bool isSelected =
                                                                index ==
                                                                    controller
                                                                        .selectedEndHour
                                                                        .value;
                                                            return timeWidget(
                                                                isSelected:
                                                                    isSelected,
                                                                item: Hours(
                                                                  hours: index,
                                                                  color: isSelected
                                                                      ? primaryColor
                                                                      : grey5,
                                                                  fontWeight: isSelected
                                                                      ? FontWeight
                                                                          .w800
                                                                      : null,
                                                                ));
                                                          },
                                                        ),
                                                        // Minutes wheel
                                                        timeWheelPicker(
                                                          setState,
                                                          onSelectedItemChanged:
                                                              (value) {
                                                            print(
                                                                "selected $value");
                                                            controller
                                                                .onSelectedEndMinsChanged(
                                                                    value);
                                                            setState(() {});
                                                          },
                                                          childCount: 60,
                                                          builder:
                                                              (context, index) {
                                                            bool isSelected =
                                                                index ==
                                                                    controller
                                                                        .selectedEndMins
                                                                        .value;
                                                            return timeWidget(
                                                                isSelected:
                                                                    isSelected,
                                                                item: Minutes(
                                                                  mins: index,
                                                                  color: isSelected
                                                                      ? primaryColor
                                                                      : grey5,
                                                                  fontWeight: isSelected
                                                                      ? FontWeight
                                                                          .w800
                                                                      : null,
                                                                ));
                                                          },
                                                        ),

                                                        // AM or PM
                                                        timeWheelPicker(
                                                          setState,
                                                          onSelectedItemChanged:
                                                              (value) {
                                                            print(
                                                                "selected $value");
                                                            controller
                                                                .onSelectedEndAmPmChanged(
                                                                    value);
                                                            setState(() {});
                                                          },
                                                          childCount: 2,
                                                          builder:
                                                              (context, index) {
                                                            bool isSelected =
                                                                index ==
                                                                    controller
                                                                        .selectedEndAmPm
                                                                        .value;
                                                            bool isItAm =
                                                                index == 0;
                                                            return timeWidget(
                                                                isSelected:
                                                                    isSelected,
                                                                item: AmPm(
                                                                  isItAm:
                                                                      isItAm,
                                                                  color: isSelected
                                                                      ? primaryColor
                                                                      : grey5,
                                                                  fontWeight: isSelected
                                                                      ? FontWeight
                                                                          .w800
                                                                      : null,
                                                                ));
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.sp),
                                            child: GtiButton(
                                              text: AppStrings.cont,
                                              onTap: () {
                                                
                                                controller.addRawTime();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                barrierDismissible: false,
                              );
                              await Future.delayed(const Duration(seconds: 1));
                            },
                      onSelectionChanged: controller.isSingleDateSelection.value
                          ? controller.onSingleDateSelection
                          : controller.selectionChanged,
                      navigationDirection:
                          DateRangePickerNavigationDirection.vertical,
                      cancelText: 'Dismiss',
                      confirmText: 'Confirm',
                      showActionButtons: true,
                      enableMultiView: true,
                      selectionColor: primaryColor,
                      startRangeSelectionColor: primaryColor,
                      endRangeSelectionColor: primaryColor,
                      rangeSelectionColor: primaryColorVeryLight,
                      selectionTextStyle:
                          getRegularStyle(color: black, fontSize: 16.sp),
                      rangeTextStyle:
                          getRegularStyle(color: black, fontSize: 16.sp),
                      viewSpacing: 5,
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  // continueButton(),
                ],
              )),
          // }
        ));
  }

  Widget headerCard(ChooseTripDateController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 8.sp),
      decoration: BoxDecoration(
        color: primaryColorLight1,
        borderRadius: BorderRadius.all(
          Radius.circular(4.r),
        ),
      ),
      child: controller.isSingleDateSelection.value
          ? Row(
              children: [
                textWidget(
                    text: "DATE:",
                    style: getRegularStyle(color: black, fontSize: 16)
                        .copyWith(fontWeight: FontWeight.w700)),
                SizedBox(
                  width: 0,
                ),
                textWidget(
                    text: "   ${controller.selectedExpiryDate.value}",
                    style: getRegularStyle(color: black, fontSize: 15).copyWith(
                        fontWeight: FontWeight.w500, fontSize: 12.sp)),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 130.sp,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                          text: controller.from.value,
                          style: getRegularStyle(color: black)
                              .copyWith(fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: 3.sp,
                      ),
                      textWidget(
                          text:
                              "${controller.startDate} ${controller.selectedStartHour}:${controller.selectedStartMinute < 10 ? '0${controller.selectedStartMinute}' : controller.selectedStartMinute}${controller.selectedStartAmPm.value == 0 ? "am" : "PM"}",
                          style: getRegularStyle(color: black).copyWith(
                              fontWeight: FontWeight.w500, fontSize: 12.sp)),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                SvgPicture.asset(
                  ImageAssets.arrowRight,
                  width: 18.sp,
                  height: 18.sp,
                ),
                const SizedBox(
                  width: 3,
                ),
                SizedBox(
                  width: 130.sp,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                          text: controller.to.value,
                          style: getRegularStyle(color: black)
                              .copyWith(fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: 3.sp,
                      ),
                      textWidget(
                          text:
                              "${controller.endDate} ${controller.selectedEndHour}:${controller.selectedEndMins < 10 ? '0${controller.selectedEndMins}' : controller.selectedEndMins}${controller.selectedEndAmPm.value == 0 ? "am" : "PM"}",
                          style: getRegularStyle(color: black).copyWith(
                              fontWeight: FontWeight.w500, fontSize: 12.sp)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  AppBar appBar(BuildContext context, ChooseTripDateController controller) {
    return gtiAppBar(
        onTap: () {

        controller.goBack1(closeOverlays: false);
        }, 
        leading: Transform.scale(
            scale: 0.5,
            child: SvgPicture.asset(
              ImageAssets.arrowLeft,
            )),
        centerTitle: false,
        title: textWidget(
            text: controller.appBarTitle.value,
            // text: AppStrings.tripDates,
            style: getRegularStyle(color: black)
                .copyWith(fontWeight: FontWeight.w500)),
        titleColor: iconColor(),
        actions: [
          // InkWell(
          //   onTap: () => controller.resetDateSelection(context),
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 16, top: 10),
          //     child: textWidget(
          //         text: AppStrings.reset,
          //         style: getRegularStyle(color: primaryColor)
          //             .copyWith(fontWeight: FontWeight.w400)),
          //   ),
          // )
        ]);
  }

  Widget timeWidget({
    required bool isSelected,
    required Widget item,
  }) {
    return Column(
      children: [
        // if (isSelected)
        SizedBox(
          width: 31,
          height: 1,
          child: ColoredBox(
            color: isSelected ? primaryColor : Colors.transparent,
          ),
          // Set your desired color
        ),
        item,
        // if (isSelected) // Add colored Divider for selected item
        SizedBox(
          width: 31,
          height: 1,
          child: ColoredBox(
            color: isSelected ? primaryColor : Colors.transparent,
          ),
          // Set your desired color
        ),
      ],
    );
  }

  Widget timeWheelPicker(StateSetter setState,
      {required void Function(int)? onSelectedItemChanged,
      required int? childCount,
      required Widget? Function(BuildContext, int) builder}) {
    return SizedBox(
      width: 50,
      height: 90,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 35,
        perspective: 0.005,
        diameterRatio: 1.2,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelectedItemChanged,
        // controller: FixedExtentScrollController(initialItem: ),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: childCount,
          builder: builder,
        ),
      ),
    );
  }

  Widget continueButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 50.sp,
            width: 300.sp,
            text: "continue".tr,
            color: secondaryColor,
            // onTap: controller.routeToPhoneVerification,
            isLoading: controller.isLoading.value,
          );
  }
}
