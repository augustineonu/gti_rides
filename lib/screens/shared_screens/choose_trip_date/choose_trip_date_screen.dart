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
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ChooseTripDateBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ChooseTripDateController>(ChooseTripDateController());
  }
}

class ChooseTripDateScreen extends GetView<ChooseTripDateController> {
  const ChooseTripDateScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar(context),
          body: body(size, context)),
      // }
    );
  }

  Widget body(size, context) {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 24.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 8.sp),
              decoration: BoxDecoration(
                color: primaryColorLight1,
                borderRadius: BorderRadius.all(
                  Radius.circular(4.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   SizedBox(
                    width: 130.sp,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidget(
                            text: AppStrings.startDate,
                            style: getRegularStyle(color: black)
                                .copyWith(fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 3.sp,
                        ),
                        textWidget(
                            text: "${controller.startDate} ${controller.selectedStartHour}:${controller.selectedStartMinute}${controller.selectedStartAmPm.value == 0 ? "am" : "PM"}",
                            style: getRegularStyle(color: black)
                                .copyWith(fontWeight: FontWeight.w500, fontSize: 12.sp)),
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
                            text: AppStrings.endDate,
                            style: getRegularStyle(color: black)
                                .copyWith(fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 3.sp,
                        ),
                        textWidget(
                            text: "${controller.endDate} ${controller.selectedEndHour}:${controller.selectedEndMins}${controller.selectedEndAmPm.value == 0 ? "am" : "PM"}",
                            style: getRegularStyle(color: black)
                                .copyWith(fontWeight: FontWeight.w500,  fontSize: 12.sp)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    height: 50,
                    child: Text("StartRangeDate: ${controller.startDate} ${controller.selectedStartHour}:${controller.selectedStartMinute}${controller.selectedStartAmPm.value == 0 ? "am" : "PM"}")),
                SizedBox(
                    height: 50,
                    child: Text('EndRangeDate:' '${controller.endDate}')),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: SfDateRangePicker(
                    backgroundColor: backgroundColor,
                    todayHighlightColor: primaryColor,
                    controller: controller.datePickerController,
                    selectionMode: DateRangePickerSelectionMode.range,
                    onCancel: controller.goBack,
                    onSubmit: (value) async {
                      await Future.delayed(const Duration(seconds: 2));
                      showDialog(
                          context: context,
                          barrierColor: Colors.transparent,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 22),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                        style: getMediumStyle(
                                                            fontSize: 12.sp)),
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
                                                        bool isSelected = index ==
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
                                                              fontWeight:
                                                                  isSelected
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
                                                      childCount: 61,
                                                      builder:
                                                          (context, index) {
                                                        bool isSelected = index ==
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
                                                              fontWeight:
                                                                  isSelected
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
                                                        bool isSelected = index ==
                                                            controller
                                                                .selectedStartAmPm
                                                                .value;
                                                        bool isItAm =
                                                            index == 0;
                                                        return timeWidget(
                                                            isSelected:
                                                                isSelected,
                                                            item: AmPm(
                                                              isItAm: isItAm,
                                                              color: isSelected
                                                                  ? primaryColor
                                                                  : grey5,
                                                              fontWeight:
                                                                  isSelected
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
                                                        text:
                                                            AppStrings.endTime,
                                                        style: getMediumStyle(
                                                            fontSize: 12.sp)),
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
                                                        bool isSelected = index ==
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
                                                              fontWeight:
                                                                  isSelected
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
                                                      childCount: 61,
                                                      builder:
                                                          (context, index) {
                                                        bool isSelected = index ==
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
                                                              fontWeight:
                                                                  isSelected
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
                                                        bool isSelected = index ==
                                                            controller
                                                                .selectedEndAmPm
                                                                .value;
                                                        bool isItAm =
                                                            index == 0;
                                                        return timeWidget(
                                                            isSelected:
                                                                isSelected,
                                                            item: AmPm(
                                                              isItAm: isItAm,
                                                              color: isSelected
                                                                  ? primaryColor
                                                                  : grey5,
                                                              fontWeight:
                                                                  isSelected
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
                                          onTap: controller.goBack,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          });
                    },
                    onSelectionChanged: controller.selectionChanged,
                    // onSelectionChanged:
                    //     (DateRangePickerSelectionChangedArgs args) async {
                    //   controller.startDate.value =
                    //       formatDate(args.value.startDate).toString();
                    //   controller.endDate.value =
                    //       formatDate(args.value.endDate ?? args.value.startDate)
                    //           .toString();

                    //   // then open dialog
                    // },
                    allowViewNavigation: false,
                    navigationDirection:
                        DateRangePickerNavigationDirection.vertical,
                    cancelText: 'Dismiss',
                    confirmText: 'Confirm',
                    showActionButtons: true,
                    enableMultiView: true,
                    startRangeSelectionColor: primaryColor,
                    endRangeSelectionColor: primaryColor,
                    rangeSelectionColor: primaryColorVeryLight,
                    selectionTextStyle:
                        getRegularStyle(color: black, fontSize: 16.sp),
                    rangeTextStyle:
                        getRegularStyle(color: black, fontSize: 16.sp),
                    viewSpacing: 5,
                  ),
                )
              ],
            ),
            textWidget(
                text: controller.testString.value,
                style: getRegularStyle(color: primaryColor)
                    .copyWith(fontWeight: FontWeight.w400)),
            SizedBox(
              height: size.height * 0.02,
            ),
            // continueButton(),
          ],
        ));
  }

  AppBar appBar(context) {
    return gtiAppBar(
        onTap: controller.goBack,
        leading: Transform.scale(
            scale: 0.5,
            child: SvgPicture.asset(
              ImageAssets.arrowLeft,
            )),
        centerTitle: false,
        title: textWidget(
            text: AppStrings.tripDates,
            style: getRegularStyle(color: black)
                .copyWith(fontWeight: FontWeight.w500)),
        titleColor: iconColor(),
        actions: [
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return Dialog(
                        backgroundColor: white,
                        insetPadding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(2.0.r)), //this right here
                        child: Container(
                          height: 230.sp,
                          width: double.infinity,
                          color: white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 22),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                text: AppStrings.startTime,
                                                style: getMediumStyle(
                                                    fontSize: 12.sp)),
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
                                              onSelectedItemChanged: (value) {
                                                print("selected $value");
                                                controller
                                                    .onSelectedStartHourChanged(
                                                        value);
                                                setState(() {});
                                              },
                                              childCount: 13,
                                              builder: (context, index) {
                                                bool isSelected = index ==
                                                    controller.selectedStartHour
                                                        .value;
                                                return timeWidget(
                                                    isSelected: isSelected,
                                                    item: Hours(
                                                      hours: index,
                                                      color: isSelected
                                                          ? primaryColor
                                                          : grey5,
                                                      fontWeight: isSelected
                                                          ? FontWeight.w800
                                                          : null,
                                                    ));
                                              },
                                            ),
                                            // Minutes wheel
                                            timeWheelPicker(
                                              setState,
                                              onSelectedItemChanged: (value) {
                                                print("selected $value");
                                                controller
                                                    .onSelectedStartMinsChanged(
                                                        value);
                                                setState(() {});
                                              },
                                              childCount: 61,
                                              builder: (context, index) {
                                                bool isSelected = index ==
                                                    controller
                                                        .selectedStartMinute
                                                        .value;
                                                return timeWidget(
                                                    isSelected: isSelected,
                                                    item: Minutes(
                                                      mins: index,
                                                      color: isSelected
                                                          ? primaryColor
                                                          : grey5,
                                                      fontWeight: isSelected
                                                          ? FontWeight.w800
                                                          : null,
                                                    ));
                                              },
                                            ),

                                            // AM or PM
                                            timeWheelPicker(
                                              setState,
                                              onSelectedItemChanged: (value) {
                                                print("selected $value");
                                                controller
                                                    .onSelectedStartAmPmChanged(
                                                        value);
                                                setState(() {});
                                              },
                                              childCount: 2,
                                              builder: (context, index) {
                                                bool isSelected = index ==
                                                    controller.selectedStartAmPm
                                                        .value;
                                                bool isItAm = index == 0;
                                                return timeWidget(
                                                    isSelected: isSelected,
                                                    item: AmPm(
                                                      isItAm: isItAm,
                                                      color: isSelected
                                                          ? primaryColor
                                                          : grey5,
                                                      fontWeight: isSelected
                                                          ? FontWeight.w800
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
                                                text: AppStrings.endTime,
                                                style: getMediumStyle(
                                                    fontSize: 12.sp)),
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
                                              onSelectedItemChanged: (value) {
                                                controller
                                                    .onSelectedEndHourChanged(
                                                        value);
                                                setState(() {});
                                              },
                                              childCount: 13,
                                              builder: (context, index) {
                                                bool isSelected = index ==
                                                    controller
                                                        .selectedEndHour.value;
                                                return timeWidget(
                                                    isSelected: isSelected,
                                                    item: Hours(
                                                      hours: index,
                                                      color: isSelected
                                                          ? primaryColor
                                                          : grey5,
                                                      fontWeight: isSelected
                                                          ? FontWeight.w800
                                                          : null,
                                                    ));
                                              },
                                            ),
                                            // Minutes wheel
                                            timeWheelPicker(
                                              setState,
                                              onSelectedItemChanged: (value) {
                                                print("selected $value");
                                                controller
                                                    .onSelectedEndMinsChanged(
                                                        value);
                                                setState(() {});
                                              },
                                              childCount: 61,
                                              builder: (context, index) {
                                                bool isSelected = index ==
                                                    controller
                                                        .selectedEndMins.value;
                                                return timeWidget(
                                                    isSelected: isSelected,
                                                    item: Minutes(
                                                      mins: index,
                                                      color: isSelected
                                                          ? primaryColor
                                                          : grey5,
                                                      fontWeight: isSelected
                                                          ? FontWeight.w800
                                                          : null,
                                                    ));
                                              },
                                            ),

                                            // AM or PM
                                            timeWheelPicker(
                                              setState,
                                              onSelectedItemChanged: (value) {
                                                print("selected $value");
                                                controller
                                                    .onSelectedEndAmPmChanged(
                                                        value);
                                                setState(() {});
                                              },
                                              childCount: 2,
                                              builder: (context, index) {
                                                bool isSelected = index ==
                                                    controller
                                                        .selectedEndAmPm.value;
                                                bool isItAm = index == 0;
                                                return timeWidget(
                                                    isSelected: isSelected,
                                                    item: AmPm(
                                                      isItAm: isItAm,
                                                      color: isSelected
                                                          ? primaryColor
                                                          : grey5,
                                                      fontWeight: isSelected
                                                          ? FontWeight.w800
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
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20.sp),
                                child: GtiButton(
                                  text: AppStrings.cont,
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 10),
              child: textWidget(
                  text: AppStrings.reset,
                  style: getRegularStyle(color: primaryColor)
                      .copyWith(fontWeight: FontWeight.w400)),
            ),
          )
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