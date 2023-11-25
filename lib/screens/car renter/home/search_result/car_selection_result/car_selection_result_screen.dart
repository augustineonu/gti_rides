import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20renter/home/search_result/car_selection_result/car_selection_result_controller.dart';
import 'package:gti_rides/screens/car%20renter/widgets/car_availability_tag.dart';
import 'package:gti_rides/shared_widgets/sqaure_check_box_widget.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/switch_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:remixicon/remixicon.dart';

class CarSelectionResultBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<CarSelectionResultController>(CarSelectionResultController());
  }
}

class CarSelectionResultScreen extends GetView<CarSelectionResultController> {
  const CarSelectionResultScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar(),
          body: body(size, context)),
      // }
    );
  }

  AppBar appBar() {
    return gtiAppBar(
      onTap: () => controller.goBack(),
      leading: Transform.scale(
        scale: 0.3,
        child: SvgPicture.asset(
          ImageAssets.close,
          height: 18.sp,
          color: black,
        ),
      ),
      centerTitle: false,
      title: null,
    );
  }

  Widget body(Size size, context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        headerCard(size),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: InkWell(
            onTap: controller.routeToViewCar,
            child: SizedBox(
              height: 200.sp,
              child: Stack(
                children: [
                  PageView(
                    physics: const ScrollPhysics(),
                    // controller: cardPageController,
                    controller: PageController(),
                    onPageChanged: (int index) {
                      // currentIndex.value = index;
                    },
                    scrollDirection: Axis.horizontal,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(4.r)),
                        child: Image.asset(
                          "assets/images/car.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(4.r)),
                        child: Image.asset(
                          "assets/images/car.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(4.r)),
                        child: Image.asset(
                          "assets/images/car.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ],
                  ),
                  carAvailabilityTag(
                    status: AppStrings.available,
                    positionLeft: 7,
                    positionTop: 7,
                  ),
                  Positioned(
                    bottom: 10,
                    left: 7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 4),
                      decoration: BoxDecoration(
                        color: black,
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
                              color: white,
                            )),
                        child: Center(
                          child: textWidget(
                            text: '1 of 10',
                            style: getLightStyle(fontSize: 10.sp, color: white)
                                .copyWith(fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 7,
                      right: 7,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.sp),
                            decoration: BoxDecoration(
                                color: primaryColorDark.withOpacity(0.8),
                                shape: BoxShape.circle),
                            // child: SvgPicture.asset(ImageAssets.share),
                            child: Icon(
                              Remix.share_line,
                              color: primaryColor,
                              size: 18.sp,
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Container(
                            padding: EdgeInsets.all(10.sp),
                            decoration: BoxDecoration(
                                color: primaryColorDark.withOpacity(0.8),
                                shape: BoxShape.circle),
                            // child: SvgPicture.asset(ImageAssets.share),
                            child: Icon(
                              Remix.heart_3_line,
                              color: primaryColor,
                              size: 18.sp,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),

        tripDate(),
        divider(color: borderColor),
        carBasics(),
        divider(color: borderColor),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                  text: AppStrings.carFeatureCaps,
                  style: getMediumStyle(fontSize: 12.sp, color: grey2)
                      .copyWith(fontWeight: FontWeight.w500)),
              SizedBox(
                height: 10.sp,
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                // direction: Axis.horizontal,
                runSpacing: 10,
                spacing: 14,
                children: [
                  carFeatureBullet(text: '5 Seats'),
                  carFeatureBullet(text: '4 Doors'),
                  carFeatureBullet(text: AppStrings.appleCarPlay),
                  carFeatureBullet(text: AppStrings.auxInput),
                  carFeatureBullet(text: AppStrings.usbInput),
                  carFeatureBullet(text: AppStrings.androidAuto),
                ],
              ),
            ],
          ),
        ),
        divider(color: borderColor),
        transmission(),
        estimatedTotalAndContinue(),
        aboutCar(),
        divider(color: borderColor),
        ratingsAndReviews(size),

        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.sp, right: 10.sp, top: 10.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 230.sp,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidget(
                            text: AppStrings.interState,
                            style: getMediumStyle(color: grey5)),
                        textWidget(
                            text: AppStrings.goBeyondStateExtra,
                            textOverflow: TextOverflow.visible,
                            style:
                                getLightStyle(fontSize: 10.sp, color: grey2)),
                      ],
                    ),
                  ),
                  switchWidget(context,
                      value: controller.selectedInterState.value,
                      activeTrackColor: borderColor,
                      onChanged: (value) =>
                          controller.onSelectInterState(value)),
                ],
              ),
            ),
            interStateWidget(),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(
                      text: AppStrings.driveOptionCaps,
                      style: getBoldStyle(fontSize: 12.sp, color: grey2)
                          .copyWith(fontWeight: FontWeight.w700)),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: borderColor),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GtiButton(
                              text: AppStrings.chauffeur,
                              style: getRegularStyle(
                                  color: controller.currentIndex.value == 0
                                      ? primaryColor
                                      : grey1),
                              width: 150.sp,
                              height: 33.sp,
                              color: backgroundColor,
                              onTap: () {
                                controller.onPageChanged(0);
                              },
                            ),
                            Container(
                              height: 2,
                              width: 150.sp,
                              color: controller.currentIndex.value == 0
                                  ? primaryColor
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GtiButton(
                              text: AppStrings.selfDrive,
                              style: getRegularStyle(
                                  color: controller.currentIndex.value == 1
                                      ? primaryColor
                                      : grey1),
                              width: 150.sp,
                              height: 33.sp,
                              color: backgroundColor,
                              onTap: () {
                                controller.onPageChanged(1);
                              },
                            ),
                            Container(
                              height: 2,
                              width: 150.sp,
                              color: controller.currentIndex.value == 1
                                  ? primaryColor
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // pages
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5.sp,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.pageController,
                onPageChanged: (int page) {
                  controller.onPageChanged(page);
                },
                children: [
                  /// chauffeur option
                  chauffeurOptionPage(context),
                  ///// cself drive option
                  selfDriveOption(context),
                ],
              ),
            ),
          ],
        ),

        SizedBox(
          height: size.height * 0.02,
        ),
        // continueButton(),
      ],
    ));
  }

  Widget selfDriveOption(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16.sp,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: textWidget(
                  text: AppStrings.youWillDrive,
                  style: getLightStyle(fontSize: 10.sp, color: grey2)),
            ),
            Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 20.sp, right: 10.sp, top: 10.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 255.sp,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget(
                                text: AppStrings.selfPickUp,
                                style: getMediumStyle(color: grey5)),
                            textWidget(
                                text: AppStrings.weWillSupplyYouAddress,
                                textOverflow: TextOverflow.visible,
                                style: getLightStyle(
                                    fontSize: 10.sp, color: grey2)),
                          ],
                        ),
                      ),
                      switchWidget(context,
                          value: controller.selectedSelfPickUp.value,
                          activeTrackColor: borderColor,
                          onChanged: (value) =>
                              controller.onSelectSelfPickUp(value)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Visibility(
                    visible: controller.selectedSelfPickUp.value,
                    child: NormalInputTextWidget(
                      title: '',
                      expectedVariable: "field",
                      hintText: AppStrings.inPutAddressDropCar,
                      textInputType: TextInputType.text,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      controller: controller.selfPickUpInputController,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.sp,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.sp, right: 10.sp, top: 0.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textWidget(
                  text: AppStrings.securityEscort,
                  style: getMediumStyle(color: grey5)),
              switchWidget(context,
                  value: controller.selectedSecurityEscort.value,
                  activeTrackColor: borderColor,
                  onChanged: (value) =>
                      controller.onSelectSecurityEscort(value)),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: Visibility(
            visible: controller.selectedSecurityEscort.value,
            child: NormalInputTextWidget(
              title: '',
              expectedVariable: "field",
              hintText: AppStrings.selectNoOfSecurity,
              textInputType: TextInputType.number,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              controller: controller.escortSecurityNoInputController,
            ),
          ),
        ),
      ],
    );
  }

  Widget chauffeurOptionPage(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16.sp,
              ),
              textWidget(
                  text: AppStrings.ourDriverWillSupport,
                  style: getLightStyle(fontSize: 10.sp, color: grey2)),
              SizedBox(
                height: 2.sp,
              ),
              NormalInputTextWidget(
                title: '',
                expectedVariable: "field",
                hintText: AppStrings.inputAddressPickUp,
                textInputType: TextInputType.text,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                controller: controller.interStateInputController,
              ),
              SizedBox(
                height: 16.sp,
              ),
              textWidget(
                text: AppStrings.yourRoute,
                style: getMediumStyle(color: grey5),
              ),
              textWidget(
                text: AppStrings.weWantToKnowTheRoute,
                textOverflow: TextOverflow.visible,
                style: getMediumStyle(fontSize: 10.sp, color: grey2),
              ),
              Row(
                children: [
                  Expanded(
                    child: NormalInputTextWidget(
                      title: AppStrings.from,
                      expectedVariable: "",
                      hintText: AppStrings.yourStart,
                      textInputType: TextInputType.text,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      // controller: controller.emailOrPhoneController,
                    ),
                  ),
                  SizedBox(
                    width: 15.sp,
                  ),
                  Expanded(
                    child: NormalInputTextWidget(
                      title: AppStrings.to,
                      expectedVariable: "",
                      hintText: AppStrings.endRoute,
                      textInputType: TextInputType.text,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      // controller: controller.emailOrPhoneController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.sp, right: 10.sp, top: 0.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textWidget(
                  text: AppStrings.securityEscort,
                  style: getMediumStyle(color: grey5)),
              switchWidget(context,
                  value: controller.selectedSecurityEscort.value,
                  activeTrackColor: borderColor,
                  onChanged: (value) =>
                      controller.onSelectSecurityEscort(value)),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: Visibility(
            visible: controller.selectedSecurityEscort.value,
            child: NormalInputTextWidget(
              title: '',
              expectedVariable: "field",
              hintText: AppStrings.selectNoOfSecurity,
              textInputType: TextInputType.number,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              controller: controller.escortSecurityNoInputController,
            ),
          ),
        ),
      ],
    );
  }

  Widget interStateWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Visibility(
        visible: controller.selectedInterState.value,
        child: NormalInputTextWidget(
          title: '',
          expectedVariable: "field",
          hintText: AppStrings.inputDestinationState,
          textInputType: TextInputType.text,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          controller: controller.interStateInputController,
        ),
      ),
    );
  }

  Column ratingsAndReviews(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                  text: AppStrings.ratingsCaps,
                  style: getMediumStyle(fontSize: 12.sp, color: grey2)
                      .copyWith(fontWeight: FontWeight.w500)),
              SizedBox(
                height: 8.sp,
              ),
              Row(
                children: [
                  SvgPicture.asset(ImageAssets.thumbsUpPrimaryColor),
                  SizedBox(
                    width: 5.sp,
                  ),
                  RichText(
                    text: TextSpan(
                        text: '97%',
                        style: getMediumStyle(
                          fontSize: 12.sp,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' (66 trips)',
                              style: getLightStyle(
                                fontSize: 12.sp,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // navigate to desired screen
                                })
                        ]),
                  ),
                ],
              ),
              SizedBox(
                height: 5.sp,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 135.sp,
          width: size.width.sp,
          child: ListView.builder(
            itemCount: 4,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            controller: ScrollController(initialScrollOffset: 5),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                height: 135,
                width: 300.sp,
                margin: EdgeInsets.only(left: 11.sp),
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.r),
                  ),
                ),
                child: Column(
                  children: [
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
                                        fontSize: 12.sp,
                                        color: secondaryColor)),
                                textWidget(
                                    text: " | ",
                                    style: getLightStyle(
                                        fontSize: 12.sp, color: grey3)),
                                SvgPicture.asset(ImageAssets.thumbsUpGreen),
                                const SizedBox(width: 3),
                                textWidget(
                                    text: AppStrings.positive,
                                    style: getMediumStyle(
                                        fontSize: 12.sp, color: grey5)),
                              ],
                            ),
                            textWidget(
                                text: 'Wed, 1 Nov, 9:00am',
                                style: getLightStyle(
                                    fontSize: 12.sp, color: grey3)),
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
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 10),
              child: InkWell(
                onTap: () => controller.routeToReviews(),
                child: textWidget(
                    text: AppStrings.seeAllReviews,
                    style:
                        getMediumStyle(fontSize: 12.sp, color: primaryColor)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget aboutCar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
              text: AppStrings.aboutCarCaps,
              style: getMediumStyle(fontSize: 12.sp, color: grey2)
                  .copyWith(fontWeight: FontWeight.w500)),
          SizedBox(
            height: 10.sp,
          ),
          textWidget(
              text:
                  "012 Kia Sportage are powered by a 2.4-liter inline-4-cylinder engine that produces 176 hp and 168 pound-feet of torque. A six-speed manual is the only transmission offered on base models, while all other versions come with a six-speed automatic with manual shift feature.",
              textOverflow: TextOverflow.visible,
              style: getMediumStyle(fontSize: 10.sp, color: grey2)
                  .copyWith(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  Widget estimatedTotalAndContinue() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 20.sp),
      color: white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 165.sp,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(ImageAssets.tag),
                    SvgPicture.asset(ImageAssets.naira),
                    SizedBox(
                      width: 2.sp,
                    ),
                    textWidget(
                      text: '100,000/day',
                      style: getMediumStyle(fontSize: 12.sp).copyWith(
                        fontFamily: 'Neue',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.sp,
                ),
                Row(
                  children: [
                    textWidget(
                      text: AppStrings.estimatedFee,
                      style: getMediumStyle(fontSize: 10.sp, color: grey2)
                          .copyWith(
                        fontFamily: 'Neue',
                      ),
                    ),
                    SvgPicture.asset(ImageAssets.naira),
                    SizedBox(
                      width: 2.sp,
                    ),
                    textWidget(
                      text: '100,000/day',
                      textOverflow: TextOverflow.ellipsis,
                      style: getMediumStyle(fontSize: 12.sp).copyWith(
                        fontFamily: 'Neue',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GtiButton(
            text: AppStrings.cont,
            width: 125.sp,
            onTap: controller.routeToKycCheck,
          ),
        ],
      ),
    );
  }

  Widget transmission() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
              text: AppStrings.transmission,
              style: getMediumStyle(fontSize: 12.sp, color: grey2)
                  .copyWith(fontWeight: FontWeight.w500)),
          SizedBox(
            height: 10.sp,
          ),
          carFeatureBullet(text: AppStrings.automatic),
        ],
      ),
    );
  }

  Widget carBasics() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
              text: AppStrings.carBasicsCaps,
              style: getMediumStyle(fontSize: 12.sp, color: grey2)
                  .copyWith(fontWeight: FontWeight.w500)),
          SizedBox(
            height: 10.sp,
          ),
          Row(
            children: [
              carFeatureBullet(text: '5 Seats'),
              const SizedBox(
                width: 10,
              ),
              carFeatureBullet(text: '4 Doors'),
              const SizedBox(
                width: 10,
              ),
              carFeatureBullet(text: '31 MPG'),
            ],
          ),
        ],
      ),
    );
  }

  Widget carFeatureBullet({required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        sqaureCheckBox(
            padingWidth: 2.sp,
            marginRight: 4.sp,
            border: Border.all(color: primaryColor, width: 1.6),
            color: primaryColor),
        textWidget(
            text: text, style: getRegularStyle(fontSize: 10.sp, color: grey2)),
      ],
    );
  }

  Padding tripDate() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
              text: AppStrings.tripDateCaps,
              style: getMediumStyle(fontSize: 12.sp, color: grey2)
                  .copyWith(fontWeight: FontWeight.w500)),
          SizedBox(
            height: 10.sp,
          ),
          Row(
            children: [
              SvgPicture.asset(ImageAssets.calendar),
              SizedBox(
                width: 10.sp,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(
                      text: 'Wed 1 Nov, 9:00am',
                      style: getMediumStyle(fontSize: 12.sp, color: grey3)),
                  textWidget(
                      text: 'Wed 1 Nov, 9:00am',
                      style: getMediumStyle(fontSize: 12.sp, color: grey3)),
                ],
              ),
              const Spacer(),
              textWidget(
                  text: AppStrings.change,
                  style: getMediumStyle(fontSize: 12.sp, color: primaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget headerCard(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Stack(
        children: [
          Container(
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 50.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(4.r),
                ),
                color: primaryColor),
            child: SizedBox(
              width: 80.sp,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textWidget(
                    text: '2012 KIA Sportage',
                    style: getBoldStyle().copyWith(
                      fontSize: 20.sp,
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
                      SvgPicture.asset(ImageAssets.thumbsUpPrimaryColor),
                      SizedBox(
                        width: 5.sp,
                      ),
                      RichText(
                        text: TextSpan(
                            text: '97%',
                            style: getMediumStyle(
                              fontSize: 12.sp,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' (66 trips)',
                                  style: getLightStyle(
                                    fontSize: 12.sp,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // navigate to desired screen
                                    })
                            ]),
                      ),
                      SizedBox(
                        width: 5.sp,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(ImageAssets.tag),
                          SvgPicture.asset(ImageAssets.naira),
                          SizedBox(
                            width: 2.sp,
                          ),
                          textWidget(
                            text: '100,000/day',
                            style: getMediumStyle(fontSize: 12.sp).copyWith(
                              fontFamily: 'Neue',
                            ),
                          ),
                        ],
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
