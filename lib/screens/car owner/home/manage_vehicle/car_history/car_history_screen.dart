import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20owner/home/manage_vehicle/car_history/car_history_controller.dart';
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
import 'package:iconsax/iconsax.dart';
import 'package:remixicon/remixicon.dart';

class CarHistoryBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<CarHistoryController>(CarHistoryController());
  }
}

class CarHistoryScreen extends GetView<CarHistoryController> {
  const CarHistoryScreen([Key? key]) : super(key: key);
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

  Widget body(Size size, context) {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4.r)),
              child: Image.asset(
                "assets/images/car.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 15.sp),
            tripsAndRating(),
            SizedBox(height: 12.sp),
            divider(color: borderColor),

            seeAllFeedbacks(),
            divider(color: borderColor),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      textWidget(
                          text: AppStrings.totalEarnings,
                          style: getRegularStyle(fontSize: 12.sp, color: grey5)
                              .copyWith(fontFamily: 'Neue')),
                      SizedBox(
                        height: 5.sp,
                      ),
                      Row(
                        children: [
                        
                          SvgPicture.asset(ImageAssets.naira),
                          SizedBox(
                            width: 2.sp,
                          ),
                          textWidget(
                            text: '5,000,000',
                            style: getMediumStyle().copyWith(
                              fontFamily: 'Neue',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        textWidget(
                            text: AppStrings.seeAllTrips,
                            style: getRegularStyle(
                                fontSize: 10.sp, color: primaryColor)),
                        SizedBox(
                          width: 5.sp,
                        ),
                        Icon(
                          Iconsax.arrow_right_3,
                          color: primaryColor,
                          size: 12.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            divider(color: borderColor),
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

            aboutCar(),
            divider(color: borderColor),
            ratingsAndReviews(size),
      textWidget(
                  text: controller.testString.value,
                  style: getMediumStyle(fontSize: 12.sp, color: grey2)
                      .copyWith(fontWeight: FontWeight.w500)),
            SizedBox(
              height: size.height * 0.02,
            ),
            // continueButton(),
          ],
        ));
  }

  Widget seeAllFeedbacks() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              textWidget(
                  text: AppStrings.feedbacks,
                  style: getRegularStyle(fontSize: 12.sp, color: grey5)
                      .copyWith(fontFamily: 'Neue')),
              SizedBox(
                height: 5.sp,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    ImageAssets.thumbsUpPrimaryColor,
                    color: secondaryColor,
                  ),
                  SizedBox(
                    width: 5.sp,
                  ),
                  textWidget(
                      text: '(66)',
                      style: getRegularStyle(fontSize: 12.sp, color: grey2)),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                textWidget(
                    text: AppStrings.seeAllFeedbacks,
                    style:
                        getRegularStyle(fontSize: 10.sp, color: primaryColor)),
                SizedBox(
                  width: 5.sp,
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  color: primaryColor,
                  size: 12.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tripsAndRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWidget(
                text: '66',
                style: getRegularStyle(fontSize: 24.sp, color: primaryColor)),
            textWidget(
                text: AppStrings.trips,
                style: getRegularStyle(
                  fontSize: 10.sp,
                )),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWidget(
                text: '98.3%',
                style: getRegularStyle(fontSize: 24.sp, color: primaryColor)),
            textWidget(
                text: AppStrings.carRating,
                style: getRegularStyle(
                  fontSize: 10.sp,
                )),
          ],
        ),
        const Spacer(),
      ],
    );
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

  AppBar appBar() {
    return gtiAppBar(
      onTap: () => controller.goBack(),
      leading: const Icon(Icons.arrow_back),
      centerTitle: true,
      title: textWidget(
          text: 'Tesla Model Y',
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
    );
  }
}
