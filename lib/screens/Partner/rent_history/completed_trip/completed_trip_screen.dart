import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/Partner/rent_history/completed_trip/completed_trip_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:iconsax/iconsax.dart';

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
    final size = MediaQuery.of(context).size;
    final controller =
        Get.put<CompletedTripController>(CompletedTripController());

    return Scaffold(
      appBar: customAppBar(width, controller),
      body: body(width, controller, size),
    );
  }

  Widget body(double width, controller, size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            nameAndPriceBreakdown(),
            divider(color: borderColor),
            tripIDandDates(),
            divider(color: borderColor),
            paymentInfo(controller),
            divider(color: borderColor),
            rentalReview(),
            divider(color: borderColor),
            reviewAndSpeakWithSupport(size),
          ],
        ),
      ),
    );
  }

  Widget reviewAndSpeakWithSupport(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.bottomSheet(
                SizedBox(
                  height: size.height * 0.4.sp,
                  width: size.width.sp,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Spacer(),
                              textWidget(
                                  text: AppStrings.review,
                                  textOverflow: TextOverflow.visible,
                                  style: getMediumStyle(
                                    color: grey3,
                                  )),
                              Spacer(),
                              InkWell(
                                onTap: controller.goBack,
                                child: SvgPicture.asset(ImageAssets.closeSmall)),
                            ],
                          ),
                          NormalInputTextWidget(
                            expectedVariable: '',
                            title: '',
                            hintText:
                                AppStrings.letOthersKnowAboutRentalExperience,
                            maxLines: 3,
                          ),
                          SizedBox(height: 5),
                          GtiButton(
                            text: AppStrings.submit,
                            onTap: () {},
                          ),
                          SizedBox(height: 20),
                        ]),
                  ),
                ),
                backgroundColor: backgroundColor,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.r),
                      topRight: Radius.circular(4.r)),
                ),
              );
            },
            child: tripInfo(
                title: AppStrings.leaveReviewAboutRental,
                fontWeight: FontWeight.w500,
                trailling: const Icon(Iconsax.arrow_right_3, size: 18)),
          ),
          SizedBox(
            height: 10.sp,
          ),
          InkWell(
            onTap: () {},
            child: tripInfo(
                title: AppStrings.speakToSupport,
                fontWeight: FontWeight.w500,
                trailling: const Icon(Iconsax.arrow_right_3, size: 18)),
          ),
        ],
      ),
    );
  }

  Widget rentalReview() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
            text: AppStrings.rentalReview,
            style: getRegularStyle(fontSize: 12.sp, color: grey3),
          ),
          SizedBox(height: 14.sp),
          Row(
            children: [
              Image.asset('assets/images/user_pic.png'),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      textWidget(
                          text: "Gift Joy",
                          style: getMediumStyle(
                              fontSize: 12.sp, color: secondaryColor)),
                      textWidget(
                          text: " | ",
                          style: getLightStyle(fontSize: 12.sp, color: grey3)),
                      SvgPicture.asset(ImageAssets.thumbsUpGreen),
                      const SizedBox(width: 3),
                      textWidget(
                          text: '100%',
                          style: getMediumStyle(fontSize: 12.sp, color: grey5)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.sp),
          textWidget(
              text:
                  "The car I rented through the app was in great condition and the booking process was effortless. I had a smooth and enjoyable experience.",
              textOverflow: TextOverflow.visible,
              style: getMediumStyle(fontSize: 10.sp, color: grey2)
                  .copyWith(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  Widget paymentInfo(controller) {
    return Column(
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
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0.sp),
          child: Row(
            children: [
              SizedBox(
                width: 2.sp,
                height: 16.sp,
                child: ColoredBox(
                  color: primaryColor,
                ),
              ),
              SizedBox(
                width: 7.sp,
              ),
              textWidget(
                text: 'UBA',
                style: getRegularStyle(fontSize: 10.sp),
              ),
            ],
          ),
        ),
        tripInfo(
          title: AppStrings.paymentStatus,
          trailling: Row(children: [
            textWidget(
              text: AppStrings.sent,
              style: getRegularStyle(fontSize: 10.sp),
            ),
            Image.asset(ImageAssets.doubleCheck),
          ]),
        ),
      ],
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

  Widget tripInfo(
      {required String title,
      required Widget trailling,
      FontWeight? fontWeight}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textWidget(
            text: title,
            textOverflow: TextOverflow.visible,
            style: getRegularStyle(color: grey3, fontSize: 12.sp)
                .copyWith(fontWeight: fontWeight),
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
