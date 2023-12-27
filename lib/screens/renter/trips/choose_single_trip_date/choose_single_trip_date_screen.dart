import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/renter/trips/choose_single_trip_date/choose_single_trip_date_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ChooseSingleDateTripBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ChooseSingleTripDateController>(ChooseSingleTripDateController());
  }
}

class ChooseSingleDateTripScreen
    extends GetView<ChooseSingleTripDateController> {
  const ChooseSingleDateTripScreen([Key? key]) : super(key: key);
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
            textWidget(
                text: controller.testString.value,
                style: getRegularStyle(color: primaryColor)
                    .copyWith(fontWeight: FontWeight.w400)),
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
                            text: "Wed, 1 Nov, 9:00am",
                            style: getRegularStyle(color: black)
                                .copyWith(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SvgPicture.asset(
                    ImageAssets.arrowRight,
                    width: 20.sp,
                    height: 20.sp,
                  ),
                  const SizedBox(
                    width: 8,
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
                            text: "Wed, 1 Nov, 9:00am",
                            style: getRegularStyle(color: black)
                                .copyWith(fontWeight: FontWeight.w500)),
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
                    child: Text(
                        'StartRangeDate:' '${controller.selectedTimeText}')),
                SizedBox(
                    height: 50,
                    child: Text('EndRangeDate:' '${controller.endDate}')),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: SfDateRangePicker(
                    backgroundColor: backgroundColor,
                    todayHighlightColor: primaryColor,
                    controller: controller.datePickerController,
                    selectionMode: DateRangePickerSelectionMode.single,
                    onSelectionChanged: controller.selectionChanged,
                    allowViewNavigation: false,
                    navigationDirection:
                        DateRangePickerNavigationDirection.vertical,
                    showActionButtons: true,
                    enableMultiView: true,
                    startRangeSelectionColor: primaryColor,
                    endRangeSelectionColor: primaryColor,
                    rangeSelectionColor: primaryColorLight1,
                    selectionTextStyle:
                        getRegularStyle(color: black, fontSize: 16.sp),
                    rangeTextStyle:
                        getRegularStyle(color: black, fontSize: 16.sp),
                    viewSpacing: 5,
                  ),
                )
              ],
            ),

            SizedBox(
              height: size.height * 0.02,
            ),
            // continueButton(),
          ],
        ));
  }

  AppBar appBar(context) {
    return gtiAppBar(
        leading: Transform.scale(
            scale: 0.5,
            child: SvgPicture.asset(ImageAssets.arrowLeft, color: black)),
        onTap: controller.goBack,
        centerTitle: false,
        title: textWidget(
            text: AppStrings.availableDates,
            style: getRegularStyle(color: black)
                .copyWith(fontWeight: FontWeight.w500)),
        titleColor: iconColor(),
        actions: [
          InkWell(
            onTap: () {},
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

  Widget timePickerWidget(
    BuildContext context, {
    required void Function(int)? onSelectedItemChanged,
    required List<Widget> children,
  }) {
    return Expanded(
      child: CupertinoPicker(
        // backgroundColor: Colors.red,

        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
            background: Colors.transparent),
        itemExtent: 40,
        onSelectedItemChanged: onSelectedItemChanged,
        children: children,
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
