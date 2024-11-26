import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/partner/car_history_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/guest/login/login_screen.dart';
import 'package:gti_rides/screens/guest/signup/signup_screen.dart';
import 'package:gti_rides/screens/renter/home/search_result/car_selection_result/car_selection_result_controller.dart';
import 'package:gti_rides/screens/renter/widgets/car_availability_tag.dart';
import 'package:gti_rides/screens/shared_screens/guest_view/presentation/guest_user.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/shared_widgets/dropdown_widget.dart';
import 'package:gti_rides/shared_widgets/generic_car_widgets.dart';
import 'package:gti_rides/shared_widgets/sqaure_check_box_widget.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/switch_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:remixicon/remixicon.dart';

class CarSelectionResultBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<CarSelectionResultController>(CarSelectionResultController());
  }
}

class CarSelectionResultScreen extends GetView<CarSelectionResultController> {
  CarSelectionResultScreen([Key? key]) : super(key: key);

  @override
  final controller = CarSelectionResultController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(),
      body: body(size, context),
      // }
    );
  }

  AppBar appBar() {
    return gtiAppBar(
      onTap: () {},
      leading: IconButton(
        onPressed: controller.goBack,
        icon: SvgPicture.asset(
          ImageAssets.close,
          height: 18.sp,
          color: black,
        ),
      ),
      centerTitle: false,
      title: null,
    );
  }

  Widget body(Size size, BuildContext context) {
    return controller.obx(
      (state) {
        var car = state?.first;
        return Obx(() {
          return SingleChildScrollView(
              controller: controller.scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  headerCard(size, car),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: SizedBox(
                      height: 200.sp,
                      child: Stack(
                        children: [
                          PageView(
                            physics: const ScrollPhysics(),
                            // controller: cardPageController,
                            controller: PageController(),
                            // onPageChanged: (int index) {
                            //   // currentIndex.value = index;
                            // },
                            onPageChanged: (index) =>
                                controller.onPageChanged(index),
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (Photo? carPhoto in car?.photo ?? [])
                                if (carPhoto != null)
                                  GestureDetector(
                                    onTap: () =>
                                        controller.routeToViewCar(arguments: {
                                      "photoList": car?.photo,
                                    }),
                                    child: carImage(
                                      imgUrl: carPhoto.photoUrl!,
                                      height: 200.sp,
                                      width: 400.sp,
                                      fit: BoxFit.fitWidth,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.r)),
                                    ),
                                  ),
                            ],
                          ),
                          carAvailabilityTag(
                            status: car!.status == "booked"
                                ? "Booked"
                                : car.availability,
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
                                    text:
                                        '${controller.currentIndex.value + 1} of ${car?.photo?.length}',
                                    style: getLightStyle(
                                            fontSize: 10.sp, color: white)
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
                                  GestureDetector(
                                    onTap: controller.shareRide,
                                    child: Container(
                                      padding: EdgeInsets.all(10.sp),
                                      decoration: BoxDecoration(
                                          color:
                                              primaryColorDark.withOpacity(0.8),
                                          shape: BoxShape.circle),
                                      // child: SvgPicture.asset(ImageAssets.share),
                                      child: Icon(
                                        Remix.share_line,
                                        color: primaryColor,
                                        size: 18.sp,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (userService.user.value.fullName ==
                                          null) {
                                        showSuccessSnackbar(
                                            title: "Oops!",
                                            message:
                                                "Kindly sign-up to add Car to favorites");
                                        return;
                                      }

                                      controller.onAddCarToFav(
                                          carId: car?.carId,
                                          carStatus: car?.favorite);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10.sp),
                                      decoration: BoxDecoration(
                                          color:
                                              primaryColorDark.withOpacity(0.8),
                                          shape: BoxShape.circle),
                                      // child: SvgPicture.asset(ImageAssets.share),
                                      child: Icon(
                                        car?.favorite == true
                                            ? Remix.heart_3_fill
                                            : Remix.heart_3_line,
                                        color: primaryColor,
                                        size: 18.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: tripDate(
                      title: AppStrings.tripDate,
                      startDate: controller.startDateTime.value,
                      endDate: controller.endDateTime.value,
                      trailling: InkWell(
                        onTap: () async {
                          // final data = await controller
                          //     .routeToSelectDate();
                          var data = await Get.toNamed(AppLinks.chooseTripDate,
                              arguments: {
                                "appBarTitle": AppStrings.tripDate,
                                "to": AppStrings.endDate,
                                "from": AppStrings.startDate,
                                "enablePastDates": false,
                              });
                          if (data != null) {
                            // Handle the selected date here
                            print('Selected Date page: $data');
                            controller.startDateTime.value = data['start'];
                            controller.endDateTime.value = data['end'];
                            controller.tripDays.value =
                                data["differenceInDays"];
                            controller.rawStartTime = data['rawStartTime'];
                            controller.rawEndTime = data['rawEndTime'];
                            await controller.getCarHistory();
                          }
                        },
                        child: SizedBox(
                          height: 30.sp,
                          width: 85.sp,
                          child: Center(
                            child: textWidget(
                                text: (controller.startDateTime.value == '' &&
                                        controller.endDateTime.value == '')
                                    ? AppStrings.selectDate
                                    : AppStrings.change,
                                style: getBoldStyle(
                                    fontSize: 14.sp, color: primaryColor)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  divider(color: borderColor),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.sp, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textWidget(
                            text: "Car ID:",
                            style:
                                getRegularStyle(fontSize: 12.sp, color: grey5)
                                    .copyWith(fontFamily: 'Neue')),
                        InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(5.r)),
                          onTap: () => controller.copy(
                              value: car.plateNumber.toString()),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: textWidget(
                                text: car.plateNumber.toString(),
                                style: getMediumStyle(color: primaryColor)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  divider(color: borderColor),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: carBasics(
                      carType: car?.type?[0].typeName ?? '',
                      carSeat: car?.seat?[0].seatName ?? '',
                    ),
                  ),
                  divider(color: borderColor),

                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: carFetures(children: [
                      for (Feature feature in car?.feature ?? [])
                        chipWidget(title: feature.featuresName ?? '')
                    ]),
                  ),
                  divider(color: borderColor),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: transmission(
                        transmission:
                            car?.transmission?[0].transmissionName ?? ''),
                  ),

                  estimatedTotalAndContinue(car),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: aboutCar(aboutCar: car?.about ?? ''),
                  ),
                  divider(color: borderColor),
                  ratingsAndReviews(size, car),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20.sp, right: 10.sp, top: 10.sp),
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
                                      style: getLightStyle(
                                          fontSize: 10.sp, color: grey2)),
                                ],
                              ),
                            ),
                            switchWidget(context,
                                value: controller.selectedInterState.value,
                                activeTrackColor: borderColor,
                                onChanged: (value) =>
                                    controller.isLoading.isTrue
                                        ? () {}
                                        : controller.onSelectInterState(value)),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget(
                                text: AppStrings.driveOptionCaps,
                                style:
                                    getBoldStyle(fontSize: 12.sp, color: grey2)
                                        .copyWith(fontWeight: FontWeight.w700)),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(width: 1, color: borderColor),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      GtiButton(
                                        text: AppStrings.chauffeur,
                                        style: getRegularStyle(
                                            color:
                                                controller.tripType.value == 0
                                                    ? primaryColor
                                                    : grey1),
                                        width: 150.sp,
                                        height: 33.sp,
                                        color: backgroundColor,
                                        onTap: controller.isLoading.isTrue ||
                                                controller.tripType.value == 0
                                            ? () {}
                                            : () {
                                                controller.onChangeTripType(0);
                                              },
                                      ),
                                      Container(
                                        height: 2,
                                        width: 150.sp,
                                        color: controller.tripType.value == 0
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
                                            color:
                                                controller.tripType.value == 1
                                                    ? primaryColor
                                                    : grey1),
                                        width: 150.sp,
                                        height: 33.sp,
                                        color: backgroundColor,
                                        onTap: controller.isLoading.isTrue ||
                                                controller.tripType.value == 1
                                            ? () {}
                                            : () {
                                                controller.onChangeTripType(1);
                                              },
                                      ),
                                      Container(
                                        height: 2,
                                        width: 150.sp,
                                        color: controller.tripType.value == 1
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
                        height: controller.selectedSecurityEscort.value &&
                                controller.selectedSelfDropOff.value &&
                                controller.selectedSelfPickUp.value
                            ? MediaQuery.of(context).size.height * 0.6.sp
                            : MediaQuery.of(context).size.height * 0.5,
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
                  continueButton(context),
                  // textWidget(
                  // text: controller.testString.value, style: getMediumStyle()),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                ],
              ));
        });
      },
      onEmpty: Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
        child: Center(
            child: textWidget(
                text: AppStrings.noListedCarsYet, style: getMediumStyle())),
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
      onLoading: Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
        child: Center(child: centerLoadingIcon()),
      ),
    );
  }

  Widget estimatedTotalAndContinue(CarHistoryData? car) {
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
                      text: '${car?.pricePerDay.toString()}/day',
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
                      text: controller.initialEstimatedTotal.value.toString(),
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
            onTap: controller.scrollToBottom,
          ),
        ],
      ),
    );
  }

  Padding headerCard(Size size, CarHistoryData? car) {
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
                    text:
                        "${car!.modelYear!.isNotEmpty ? car.modelYear![0].yearName : ''} ${car?.brand?[0].brandName} ${car?.brandModel?[0].modelName}",
                    style: getBoldStyle().copyWith(
                      fontSize: 18.sp,
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
                            text: '${car?.percentage.toString()}%',
                            style: getMediumStyle(
                              fontSize: 12.sp,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      ' (${car?.tripsCount.toString()} trips)',
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
                            text: '${car?.pricePerDay.toString()}/day',
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

  Widget selfDriveOption(context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: controller.selfDriveFormKey,
        child: Column(
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
                      padding: EdgeInsets.only(
                          left: 20.sp, right: 10.sp, top: 10.sp),
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
                                    text: AppStrings
                                        .chooseToPickUpCarAtProvidedAddress,
                                    textOverflow: TextOverflow.visible,
                                    style: getLightStyle(
                                        fontSize: 10.sp, color: grey2)),
                              ],
                            ),
                          ),
                          switchWidget(context,
                              value: controller.selectedSelfPickUp.value,
                              activeTrackColor: borderColor,
                              onChanged: (value) => controller.isLoading.isTrue
                                  ? () {}
                                  : controller.onSelectSelfPickUp(value)),
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
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.sp, right: 10.sp, top: 10.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 255.sp,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textWidget(
                                    text: AppStrings.selfDropOff,
                                    style: getMediumStyle(color: grey5)),
                                textWidget(
                                    text:
                                        AppStrings.returnCarToDesignatedAddress,
                                    textOverflow: TextOverflow.visible,
                                    style: getLightStyle(
                                        fontSize: 10.sp, color: grey2)),
                              ],
                            ),
                          ),
                          switchWidget(context,
                              value: controller.selectedSelfDropOff.value,
                              activeTrackColor: borderColor,
                              onChanged: (value) => controller.isLoading.isTrue
                                  ? () {}
                                  : controller.onSelectSelfDropOff(value)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Visibility(
                        visible: controller.selectedSelfDropOff.value,
                        child: NormalInputTextWidget(
                          title: '',
                          expectedVariable: "field",
                          hintText: AppStrings.inPutAddressDropCar,
                          textInputType: TextInputType.text,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          controller: controller.selfDropOffInputController,
                        ),
                      ),
                    ),
                  ],
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
                      onChanged: (value) => controller.isLoading.isTrue
                          ? () {}
                          : controller.onSelectSecurityEscort(value)),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20.sp),
            //   child: Visibility(
            //     visible: controller.selectedSecurityEscort.value,
            //     child: NormalInputTextWidget(
            //       title: '',
            //       expectedVariable: "field",
            //       hintText: AppStrings.selectNoOfSecurity,
            //       textInputType: TextInputType.number,
            //       contentPadding:
            //           const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            //       controller: controller.escortSecurityNoInputController,
            //       onEditingComplete: controller.onChangeEscortNumber,
            //       onChanged: (value) => controller.onChangeEscortNumber(),
            //       // onChanged: (value) => controller.onChangeEscortNumber(value),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Visibility(
                visible: controller.selectedSecurityEscort.value,
                child: dropdownWidget1(
                  context: context,
                  hintText: 'Select',
                  title: AppStrings.selectNoOfSecurity,
                  iconColor: grey3,
                  // selectedValue: controller.isFromManageCars.isTrue &&
                  //         controller.advanceAmount.value.isNotEmpty
                  //     ? controller.advanceAmount.value.contains('hours')
                  //         ? controller.advanceAmount.value
                  //         : "4 hours"
                  //     : null,
                  values: <String>[
                    "1",
                    "2",
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '10',
                    '11',
                    '12',
                    '13',
                    '14',
                    '15',
                    '16',
                    '17',
                    '18',
                    '19',
                    '20',
                    '21',
                    '22',
                    '23',
                    '24',
                    '25',
                    '26',
                    '27',
                    '28',
                    '29',
                    '30'
                  ],
                  onChange: (value) =>
                      controller.onChangeEscortNumber(value: value),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget chauffeurOptionPage(context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: controller.chauffeurFormKey,
      child: SingleChildScrollView(
        child: Column(
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
                    controller: controller.inputPickupAddController,
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
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: NormalInputTextWidget(
                          title: AppStrings.from,
                          expectedVariable: "field",
                          hintText: AppStrings.startRoute,
                          textInputType: TextInputType.text,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          controller: controller.startRouteController,
                        ),
                      ),
                      SizedBox(
                        width: 15.sp,
                      ),
                      Expanded(
                        child: NormalInputTextWidget(
                          title: AppStrings.to,
                          expectedVariable: "field",
                          hintText: AppStrings.endRoute,
                          textInputType: TextInputType.text,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          controller: controller.endRouteController,
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
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20.sp),
            //   child: Visibility(
            //     visible: controller.selectedSecurityEscort.value,
            //     child: NormalInputTextWidget(
            //       title: '',
            //       expectedVariable: "field",
            //       hintText: AppStrings.selectNoOfSecurity,
            //       textInputType: TextInputType.number,
            //       contentPadding:
            //           const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            //       controller: controller.escortSecurityNoInputController,
            //       onEditingComplete: controller.onChangeEscortNumber,
            //       onChanged: (value) => controller.onChangeEscortNumber(),
            //     ),
            //   ),
            // ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Visibility(
                visible: controller.selectedSecurityEscort.value,
                child: dropdownWidget1(
                  context: context,
                  hintText: 'Select',
                  title: AppStrings.selectNoOfSecurity,
                  iconColor: grey3,
                  expectedVariable: 'field',
                  selectedValue:
                      controller.escortSecurityNoInputController.text,
                  values: <String>[
                    "",
                    "1",
                    "2",
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '10',
                    '11',
                    '12',
                    '13',
                    '14',
                    '15',
                    '16',
                    '17',
                    '18',
                    '19',
                    '20',
                    '21',
                    '22',
                    '23',
                    '24',
                    '25',
                    '26',
                    '27',
                    '28',
                    '29',
                    '30'
                  ],
                  onChange: (value) =>
                      controller.onChangeEscortNumber(value: value),
                ),
              ),
            ),
          ],
        ),
      ),
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

  Widget ratingsAndReviews(Size size, CarHistoryData? car) {
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
                        text: '${car?.percentage.toString()}%',
                        style: getMediumStyle(
                          fontSize: 12.sp,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' (${car?.tripsCount.toString()} trips)',
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
          child: controller.reviews!.isEmpty
              ? Center(
                  child: textWidget(
                      text: 'You have no reviews yet', style: getBoldStyle()),
                )
              : ListView.separated(
                  itemCount: controller.reviews!.take(5).length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  controller: ScrollController(initialScrollOffset: 5),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var review = controller.reviews![index];
                    int? ratingPercentage =
                        int.tryParse(review.reviewPercentage);
                    return InkWell(
                      onTap: () {
                        if (!controller.isLoading.value) {
                          controller.routeToReviews();
                        }
                      },
                      child: Container(
                        height: 135.sp,
                        width: 300.sp,
                        // margin: EdgeInsets.only(left: 11.sp),
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.r),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                carImage(
                                    imgUrl:
                                        review.user!.userProfileUrl.toString(),
                                    height: 30.sp,
                                    width: 30.sp,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.r))),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        textWidget(
                                            text: review.user!.userName
                                                .toString(),
                                            style: getMediumStyle(
                                                fontSize: 12.sp,
                                                color: secondaryColor)),
                                        textWidget(
                                            text: " | ",
                                            style: getLightStyle(
                                                fontSize: 12.sp, color: grey3)),
                                        ratingPercentage! >= 50
                                            ? Row(
                                                children: [
                                                  SvgPicture.asset(ImageAssets
                                                      .thumbsUpGreen),
                                                  const SizedBox(width: 3),
                                                  textWidget(
                                                      text:
                                                          '${review.reviewPercentage}%',
                                                      style: getMediumStyle(
                                                          fontSize: 12.sp,
                                                          color: grey5)),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    ImageAssets.thumbsDown,
                                                    color: red,
                                                  ),
                                                  const SizedBox(width: 3),
                                                  textWidget(
                                                      text:
                                                          '${review.reviewPercentage}%',
                                                      style: getMediumStyle(
                                                          fontSize: 12.sp,
                                                          color: grey5)),
                                                ],
                                              ),
                                      ],
                                    ),
                                    textWidget(
                                        text: isSingleDateSelection(
                                            date: review.createdAt!),
                                        style: getRegularStyle(
                                            fontSize: 10.sp, color: grey3)),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10.sp),
                            textWidget(
                                text: review.message.toString(),
                                textOverflow: TextOverflow.visible,
                                textAlign: TextAlign.start,
                                style: getMediumStyle(
                                        fontSize: 12.sp, color: grey5)
                                    .copyWith(fontWeight: FontWeight.w300)),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, lol) => const SizedBox(
                    width: 11,
                  ),
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 10),
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                onTap: () {
                  if (!controller.isLoading.value) {
                    controller.routeToReviews();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: textWidget(
                      text: AppStrings.seeAllReviews,
                      style:
                          getMediumStyle(fontSize: 12.sp, color: primaryColor)),
                ),
              ),
            ),
          ],
        ),
      ],
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

  Widget continueButton(BuildContext context) {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GtiButton(
              width: 400.sp,
              text: "continue".tr,
              color: primaryColor,
              onTap: () async {
                if (userService.user.value.fullName == null) {
                   var value =
                      await guestActionDialog(action: " access more services");
                  if (value == true) {
                    routeService.offAllNamed(AppLinks.login);
                  }
                  // showModalBottomSheet(
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.only(
                  //             topLeft: Radius.circular(10.r),
                  //             topRight: Radius.circular(10.r))),
                  //     context: context,
                  //     builder: (context) {
                  //       return SizedBox(
                  //           height: 300.sp,
                  //           child: Column(
                  //             children: [
                  //               SizedBox(
                  //                 height: 20.sp,
                  //               ),
                  //               textWidget(
                  //                   text: "Oops!",
                  //                   style: getBoldStyle(fontSize: 20.sp)),
                  //               SizedBox(
                  //                 height: 25.sp,
                  //               ),
                  //               textWidget(
                  //                   text:
                  //                       "You need to register or login to book a ride on GTi Rides.",
                  //                   textOverflow: TextOverflow.visible,
                  //                   textAlign: TextAlign.center,
                  //                   style: getRegularStyle(fontSize: 16.sp)),
                  //               SizedBox(
                  //                 height: 24.sp,
                  //               ),
                  //               Center(
                  //                 child: GtiButton(
                  //                   text: "Create Account",
                  //                   onTap: () {
                  //                     Navigator.pushReplacement(
                  //                         context,
                  //                         MaterialPageRoute(
                  //                             builder: (context) =>
                  //                                 SignUpScreen()));
                  //                   },
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 height: 15.sp,
                  //               ),
                  //               GtiButton(
                  //                 text: "Login",
                  //                 // color: pureWhite,
                  //                 textColor: white,
                  //                 // hasBorder: true,
                  //                 // borderColor: ThemeColors.of(context).errorContainer,
                  //                 // borderRadius: 12.r,
                  //                 onTap: () {
                  //                   Navigator.pushReplacement(
                  //                       context,
                  //                       MaterialPageRoute(
                  //                           builder: (context) =>
                  //                               LoginScreen()));
                  //                 },
                  //               ),
                  //             ],
                  //           ));
                  //     });
                  return;
                }
                controller.processCarBooking();
              },
              // onTap: controller.routeToPhoneVerification,
              isLoading: controller.isLoading.value,
            ),
          );
  }
}
