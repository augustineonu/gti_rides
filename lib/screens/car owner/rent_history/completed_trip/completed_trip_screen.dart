import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20owner/rent_history/completed_trip/completed_trip_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class CompletedTripBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<CompletedTripController>(CompletedTripController());
  }
}

class CompletedTripScreen extends GetView<CompletedTripController> {
  const CompletedTripScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final controller =
        Get.put<CompletedTripController>(CompletedTripController());

    return Scaffold(
      appBar: customAppBar(width, controller),
      body: body(width, controller),
    );
  }

  Widget body(double width, controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          nameAndPriceBreakdown(),
          divider(color: borderColor),
          tripIDandDates(),
          divider(color: borderColor),
          Column(
            children: [
              tripInfo(
                title: AppStrings.paymentRef,
                trailling: InkWell(
                  onTap: () {
                    controller.copy(value: "GTI123456");
                  },
                  child: Row(
                    children: [
                      textWidget(
                        text: 'GTI123456',
                        style: getRegularStyle(
                          fontSize: 10.sp,
                        ),
                      ),
                      SizedBox(
                        width: 3.sp,
                      ),
                      SvgPicture.asset(ImageAssets.docCopy),
                    ],
                  ),
                ),
              ),
              tripInfo(
                title: AppStrings.tripStartDate,
                trailling: textWidget(
                  text: 'Wed, 1 Nov, 9:00am',
                  style: getRegularStyle(fontSize: 10.sp),
                ),
              ),
              tripInfo(
                title: AppStrings.tripEndDate,
                trailling: textWidget(
                  text: 'Wed, 5 Nov, 9:00am',
                  style: getRegularStyle(fontSize: 10.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tripIDandDates() {
    return Column(
      children: [
        tripInfo(
          title: AppStrings.tripId,
          trailling: InkWell(
            onTap: () {
              controller.copy(value: "GTI123456");
            },
            child: Row(
              children: [
                textWidget(
                  text: 'GTI123456',
                  style: getRegularStyle(
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(
                  width: 3.sp,
                ),
                SvgPicture.asset(ImageAssets.docCopy),
              ],
            ),
          ),
        ),
        tripInfo(
          title: AppStrings.tripStartDate,
          trailling: textWidget(
            text: 'Wed, 1 Nov, 9:00am',
            style: getRegularStyle(fontSize: 10.sp),
          ),
        ),
        tripInfo(
          title: AppStrings.tripEndDate,
          trailling: textWidget(
            text: 'Wed, 5 Nov, 9:00am',
            style: getRegularStyle(fontSize: 10.sp),
          ),
        ),
      ],
    );
  }

  Widget tripInfo({
    required String title,
    required Widget trailling,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textWidget(
            text: title,
            textOverflow: TextOverflow.visible,
            style: getRegularStyle(color: grey3, fontSize: 12.sp),
          ),
          trailling
        ],
      ),
    );
  }

  Widget nameAndPriceBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset('assets/images/small_car.png'),
                SizedBox(
                  width: 6.w,
                ),
                textWidget(
                  text: 'Tesla Model Y',
                  textOverflow: TextOverflow.visible,
                  style: getBoldStyle(fontWeight: FontWeight.w700, color: black)
                      .copyWith(
                    fontFamily: "Neue",
                  ),
                ),
              ],
            ),
            textWidget(
              text: AppStrings.completed,
              textOverflow: TextOverflow.visible,
              style: getRegularStyle(color: grey3, fontSize: 10.sp),
            ),
          ],
        ),
        priceBreakdown(title: AppStrings.totalAmount, amount: '500,000'),
        priceBreakdown(title: AppStrings.pricePerDay, amount: '100,000'),
        priceBreakdown(title: AppStrings.vat, amount: '100,000'),
        priceBreakdown(title: "x 4days", amount: '500,000'),
      ],
    );
  }

  Widget priceBreakdown({required String title, required String amount}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textWidget(
            text: title,
            textOverflow: TextOverflow.visible,
            style: getRegularStyle(color: grey3, fontSize: 12.sp),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SvgPicture.asset(ImageAssets.naira),
              SizedBox(
                width: 2.sp,
              ),
              textWidget(
                text: amount,
                style: getMediumStyle(fontSize: 12.sp).copyWith(
                  fontFamily: 'Neue',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSize customAppBar(double width, CompletedTripController controller) {
    return PreferredSize(
      preferredSize: Size(width, 180),
      child: Stack(
        children: [
          Container(
            width: width,
            padding:
                EdgeInsets.only(top: 0.sp, bottom: 20.sp, left: 20, right: 20),
            height: 179.h,
            decoration: const BoxDecoration(
                color: darkBrown,
                image: DecorationImage(
                    image: AssetImage(
                      ImageAssets.appBarBg1,
                    ),
                    fit: BoxFit.fitHeight)),
            child: SafeArea(
              child: SizedBox(
                width: 180.sp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: controller.goBack,
                        child: SvgPicture.asset(
                          color: white,
                          ImageAssets.arrowLeft,
                        )),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textWidget(
                            text: AppStrings.carTripCompleted,
                            textOverflow: TextOverflow.visible,
                            style:
                                getMediumStyle(color: white, fontSize: 17.sp)),
                        SizedBox(
                          width: 5.sp,
                        ),
                        SvgPicture.asset(ImageAssets.completedCheck),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
