import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/Partner/rent_history/completed_trip/completed_trip_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/shimmer_loading/box_shimmer.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:iconsax/iconsax.dart';

class CompletedTripBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<CompletedTripController>(CompletedTripController());
  }
}

class CompletedTripScreen extends GetView<CompletedTripController> {
  CompletedTripScreen({
    super.key,
  });
  @override
  final controller =
      Get.put<CompletedTripController>(CompletedTripController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;

    return Obx(() => Scaffold(
          primary: false,

          // appBar: customAppBar(width, controller),
          appBar: CustomAppBar(controller: controller),
          body: body(context, width, controller, size),
        ));
  }

  Widget body(context, double width, CompletedTripController controller, size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: controller.isLoading.value
          ? centerLoadingIcon()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  nameAndPriceBreakdown(),
                  divider(color: borderColor),
                  tripIDandDates(),
                  divider(color: borderColor),
                  paymentInfo(),
                  divider(color: borderColor),
                  rentalReview(context),
                  divider(color: borderColor),
                  Visibility(
                      visible: controller.showSupport.isTrue,
                      child: review(size)),
                  support(size),
                ],
              ),
            ),
    );
  }

  Widget review(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.bottomSheet(
                StatefulBuilder(builder: (context, setState) {
                  return SizedBox(
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
                                const Spacer(),
                                textWidget(
                                    text: AppStrings.review,
                                    textOverflow: TextOverflow.visible,
                                    style: getMediumStyle(
                                      color: grey3,
                                    )),
                                const Spacer(),
                                InkWell(
                                    onTap: controller.goBack,
                                    child: SvgPicture.asset(
                                        ImageAssets.closeSmall)),
                              ],
                            ),
                            Form(
                              key: controller.reviewFormKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: NormalInputTextWidget(
                                expectedVariable: '',
                                title: '',
                                hintText: AppStrings
                                    .letOthersKnowAboutRentalExperience,
                                maxLines: 3,
                                controller: controller.reviewMessageController,
                              ),
                            ),
                            const SizedBox(height: 5),
                            GtiButton(
                              text: AppStrings.submit,
                              onTap: () {
                                setState(() {});
                                controller
                                    .addReview()
                                    .then((value) => setState(() {}));
                              },
                            ),
                            SizedBox(height: 20),
                          ]),
                    ),
                  );
                }),
                backgroundColor: backgroundColor,
                // isScrollControlled: true,
                // enableDrag: true,
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
                color: grey5,
                trailling: const Icon(Iconsax.arrow_right_3, size: 18)),
          ),
        ],
      ),
    );
  }

  Widget support(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          SizedBox(
            height: 10.sp,
          ),
          InkWell(
            onTap: controller.launchMessenger,
            child: tripInfo(
                title: AppStrings.speakToSupport,
                fontWeight: FontWeight.w500,
                color: grey5,
                trailling: const Icon(Iconsax.arrow_right_3, size: 18)),
          ),
        ],
      ),
    );
  }

  Widget rentalReview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: controller.obx(
        (state) {
          // var review = state!.first;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                text: AppStrings.rentalReview,
                style: getRegularStyle(fontSize: 12.sp, color: grey3),
              ),
              SizedBox(height: 14.sp),
              SizedBox(
                height: 90.sp,
                // width: 300.sp,
                child: ListView.separated(
                  itemCount: state!.take(5).length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  // controller: ScrollController(initialScrollOffset: 5),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var review = state[index];
                    int? reviewPercentage =
                        int.tryParse(review.reviewPercentage);
                    return SizedBox(
                      width: 300.sp,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Image.asset('assets/images/user_pic.png'),
                              carImage(
                                  imgUrl:
                                      review.user!.userProfileUrl.toString(),
                                  height: 30.sp,
                                  width: 30.sp,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.r))),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    //Foreatgreen29@#$
                                    children: [
                                      textWidget(
                                          text:
                                              review.user!.userName.toString(),
                                          style: getMediumStyle(
                                              fontSize: 12.sp,
                                              color: secondaryColor)),
                                      textWidget(
                                          text: " | ",
                                          style: getLightStyle(
                                              fontSize: 12.sp, color: grey3)),
                                      SvgPicture.asset(
                                          reviewPercentage! >= 50
                                              ? ImageAssets.thumbsUpGreen
                                              : ImageAssets.thumbsDown,
                                          color: reviewPercentage >= 50
                                              ? null
                                              : red),
                                      const SizedBox(width: 3),
                                      textWidget(
                                          text: review.reviewPercentage != null
                                              ? "${review.reviewPercentage.toString()}%"
                                              : '0%',
                                          style: getMediumStyle(
                                              fontSize: 12.sp, color: grey5)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10.sp),
                          textWidget(
                              text: review.message.toString(),
                              textOverflow: TextOverflow.visible,
                              textAlign: TextAlign.start,
                              style:
                                  getMediumStyle(fontSize: 12.sp, color: grey5)
                                      .copyWith(fontWeight: FontWeight.w300)),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, lol) => const SizedBox(width: 0),
                ),
              ),
            ],
          );
        },
        onEmpty: Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Center(
              child: textWidget(
                  textOverflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                  text: AppStrings.noReviewsYet,
                  style: getExtraBoldStyle(fontSize: 18.sp))),
        ),
        onError: (e) => Padding(
          padding: EdgeInsets.symmetric(vertical: 50.sp, horizontal: 20),
          child: Center(
            child: Text(
              "$e",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onLoading: boxShimmer(height: 150.sp),
      ),
    );
  }

  Widget paymentInfo() {
    return Column(
      children: [
        tripInfo(
          title: AppStrings.paymentRef,
          trailling: InkWell(
            onTap: () {
              controller.copy(
                  value: controller.tripsData.tripOrders!.first.paymentReference
                      .toString());
            },
            child: Row(
              children: [
                textWidget(
                  text: controller.tripsData.tripOrders!.first.paymentReference
                      .toString(),
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
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 5.0.sp),
        //   child: Row(
        //     children: [
        //       SizedBox(
        //         width: 2.sp,
        //         height: 16.sp,
        //         child: const ColoredBox(
        //           color: primaryColor,
        //         ),
        //       ),
        //       SizedBox(
        //         width: 7.sp,
        //       ),
        //       // TODO:
        //       textWidget(
        //         text: 'nill',
        //         style: getRegularStyle(fontSize: 10.sp),
        //       ),
        //     ],
        //   ),
        // ),
        tripInfo(
          title: AppStrings.paymentStatus,
          trailling: Row(children: [
            textWidget(
              text: controller.tripsData.tripOrders!.first.paymentStatus
                  .toString(),
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
              controller.copy(value: controller.tripsData.tripId.toString());
            },
            child: Row(
              children: [
                textWidget(
                  text: controller.tripsData.tripId.toString(),
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
            text: formateDate(
                date: controller.tripsData.tripStartDate.toString()),
            style: getRegularStyle(fontSize: 10.sp),
          ),
        ),
        tripInfo(
          title: AppStrings.tripEndDate,
          trailling: textWidget(
            text:
                formateDate(date: controller.tripsData.tripEndDate.toString()),
            style: getRegularStyle(fontSize: 10.sp),
          ),
        ),
      ],
    );
  }

  Widget tripInfo(
      {required String title,
      required Widget trailling,
      FontWeight? fontWeight,
      Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textWidget(
            text: title,
            textOverflow: TextOverflow.visible,
            style: getRegularStyle(color: color ?? grey3, fontSize: 12.sp)
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
            SizedBox(
              width: 250.sp,
              child: Row(
                children: [
                  // Image.asset('assets/images/small_car.png'),
                  carImage(
                      imgUrl: controller.tripsData.carProfilePic.toString(),
                      width: 32.sp,
                      height: 32.sp),
                  SizedBox(
                    width: 6.w,
                  ),
                  Expanded(
                    child: textWidget(
                      text:
                          "${controller.tripsData.carBrand.toString()} ${controller.tripsData.carModel.toString()}",
                      textOverflow: TextOverflow.visible,
                      style: getBoldStyle(
                              fontWeight: FontWeight.w700, color: black)
                          .copyWith(
                        fontFamily: "Neue",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            textWidget(
              text: controller.tripsData.status.toString(),
              textOverflow: TextOverflow.visible,
              style: getRegularStyle(color: grey3, fontSize: 10.sp),
            ),
          ],
        ),
        priceBreakdown(
            title: AppStrings.totalAmount,
            amount: controller.tripsData.totalFee.toString()),
        priceBreakdown(
            title: AppStrings.pricePerDay,
            amount:
                controller.tripsData.tripOrders!.first.pricePerDay.toString()),
        priceBreakdown(
            title: AppStrings.vat,
            amount: controller.tripsData.tripOrders!.first.vatFee.toString()),
        priceBreakdown(
            title:
                "x ${controller.tripsData.tripOrders?.first.tripsDays.toString()} ${controller.tripsData.tripOrders?.first.tripsDays == 1 ? 'day' : 'days'}",
            amount: controller.tripsData.tripOrders!.first.pricePerDayTotal
                .toString()),
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
                    SizedBox(
                      height: 5.sp,
                    ),
                    InkWell(
                        onTap: controller.goBack,
                        child: SvgPicture.asset(
                          color: white,
                          ImageAssets.arrowLeft,
                          width: 24.sp,
                        )),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textWidget(
                            text: AppStrings.carTripStatus.trArgs(
                                [controller.tripsData.status.toString()]),
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

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({required this.controller, super.key});

  final CompletedTripController controller;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            width: size.width,
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
                    SizedBox(
                      height: 5.sp,
                    ),
                    InkWell(
                        onTap: controller.goBack,
                        child: SvgPicture.asset(
                          color: white,
                          ImageAssets.arrowLeft,
                          width: 24.sp,
                        )),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textWidget(
                            text: AppStrings.carTripStatus.trArgs(
                                [controller.tripsData.status.toString()]),
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

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(0.0, 180.0);
}
