import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/favorite_cars_model.dart';
import 'package:gti_rides/screens/Partner/home/partner_home_controller.dart';
import 'package:gti_rides/screens/Partner/partner_landing_controller.dart';
import 'package:gti_rides/screens/renter/widgets/build_carousel_dot.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/shared_widgets/car_availability_tag.dart';
import 'package:gti_rides/shared_widgets/date_time_col_widget.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/how_gti_works_widget.dart';
import 'package:gti_rides/shared_widgets/shimmer_loading/box_shimmer.dart';
import 'package:gti_rides/shared_widgets/switch_profile_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:iconsax/iconsax.dart';

class PartnerBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<PartnerHomeController>(PartnerHomeController());
  }
}

class PartnerHomeScreen extends StatefulWidget {
  const PartnerHomeScreen({
    super.key,
  });

  @override
  State<PartnerHomeScreen> createState() => _CarRenterHomeScreenState();
}

class _CarRenterHomeScreenState extends State<PartnerHomeScreen> {
  final controller = Get.put<PartnerHomeController>(PartnerHomeController());
  final landingController = Get.put(PartnerLandingController());

  late Timer timer;
  RxInt currentIndex = 0.obs;

  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  late PageController cardPageController;
  ScrollController scrollController = ScrollController();
  final GlobalKey pageViewKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init called>>>");
    cardPageController = PageController(initialPage: 0);

    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentIndex.value < 4) {
        setState(() {
          currentIndex.value++;
        });
        print("next page ${currentIndex.value}>>>");
      } else {
        setState(() {
          currentIndex.value = 0;
        });
      }

      if (pageViewKey.currentState != null && scrollController.hasClients) {
        cardPageController.animateToPage(
          currentIndex.value,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer to stop the animation
    cardPageController.dispose(); // Dispose of the PageController
    scrollController.dispose(); // Dispose of the ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = MediaQuery.of(context).size.height;
    return Obx(
      () => Scaffold(
        body: RefreshIndicator(
          onRefresh: controller.getAllCars,
          child: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    appBar(size, controller,
                        landingController: landingController),
                    // body(controller, size),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(
                            vertical: 10.sp, horizontal: 16.sp),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            getCarListedCard(
                                onTap: controller.routeTolistVehicle),
                            manageListedVehicles(
                                onTap: controller.routeToManageVehicle),
                            howGtiWorksCard(
                                onTap: () {
                                  controller.launchWebsite();
                                },
                                imageUrl: ImageAssets.guyWorks),
                            // textWidget(
                            //   text: AppStrings.recentViewCar,
                            //   style: getRegularStyle(),
                            // ),

                            Builder(builder: (context) {
                              return controller.obx(
                                (state) {
                                  final visibleCars =
                                      state?.take(5).toList() ?? [];

                                  return SizedBox(
                                    height: 235.sp,
                                    width: size.width,
                                    child: Stack(
                                      children: [
                                        PageView(
                                          key: pageViewKey,
                                          physics: const ScrollPhysics(),
                                          controller: cardPageController,
                                          onPageChanged: (int index) {
                                            setState(() {
                                              currentIndex.value = index;
                                            });
                                          },
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            for (var car in visibleCars)
                                              carCardWidget(size, car,
                                                  onTap: () => controller
                                                          .routeToCarHistory(
                                                              arguments: {
                                                            'brandModelName': car
                                                                .brandModelName
                                                                .toString(),
                                                            'photoUrl': car
                                                                .photoUrl
                                                                .toString(),
                                                            'carID': car.carId
                                                                .toString(),
                                                          })),
                                          ],
                                        ),
                                        Positioned(
                                          bottom: 95.sp,
                                          right: 0,
                                          left: 0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: List.generate(
                                              visibleCars.length,
                                              (index) => BuildCarouselDot(
                                                currentIndex:
                                                    currentIndex.value,
                                                index: index,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                onEmpty: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: context.height * 0.1),
                                  child: Center(
                                      child: textWidget(
                                          text: AppStrings.noListedCarsYet,
                                          style: getMediumStyle())),
                                ),
                                onError: (e) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: context.height * 0.1,
                                      horizontal: 20),
                                  child: Center(
                                    child: Text(
                                      "$e",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                onLoading: boxShimmer(height: 200.sp),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              controller.isLoading.isTrue
                  ? Stack(
                      children: [
                        const Opacity(
                          opacity: 0.5,
                          child: ModalBarrier(
                              dismissible: false, color: Colors.black),
                        ),
                        Center(
                          child: Center(child: centerLoadingIcon()),
                        ),
                      ],
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  Widget body(PartnerHomeController controller, Size size) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 16.sp),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getCarListedCard(onTap: controller.routeTolistVehicle),
            manageListedVehicles(onTap: controller.routeToManageVehicle),
            howGtiWorksCard(
                onTap: () {
                  controller.launchWebsite();
                },
                imageUrl: ImageAssets.guyWorks),
            // textWidget(
            //   text: AppStrings.recentViewCar,
            //   style: getRegularStyle(),
            // ),

            Builder(builder: (context) {
              return controller.obx(
                (state) {
                  final visibleCars = state?.take(5).toList() ?? [];

                  return SizedBox(
                    height: 235.sp,
                    width: size.width,
                    child: Stack(
                      children: [
                        PageView(
                          key: pageViewKey,
                          physics: const ScrollPhysics(),
                          controller: cardPageController,
                          onPageChanged: (int index) {
                            currentIndex.value = index;
                          },
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (var car in visibleCars)
                              carCardWidget(size, car,
                                  onTap: () =>
                                      controller.routeToCarHistory(arguments: {
                                        'brandModelName':
                                            car.brandModelName.toString(),
                                        'photoUrl': car.photoUrl.toString(),
                                        'carID': car.carId.toString(),
                                      })),
                          ],
                        ),
                        Positioned(
                          bottom: 95.sp,
                          right: 0,
                          left: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(
                              visibleCars.length,
                              (index) => BuildCarouselDot(
                                currentIndex: currentIndex.value,
                                index: index,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onEmpty: Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
                  child: Center(
                      child: textWidget(
                          text: AppStrings.noListedCarsYet,
                          style: getMediumStyle())),
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
            }),
          ],
        ),
      ),
    );
  }

  Widget carCardWidget(Size size, FavoriteCarData car,
      {void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size.width.sp,
        child: Stack(
          children: [
            Card(
              color: white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.r),
                ),
              ),
              child: Column(
                children: [
                  carImage(
                    height: 140.sp,
                    width: size.width.sp,
                    imgUrl: car.photoUrl.toString() != ''
                        ? car.photoUrl.toString()
                        : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnKpMPFWYvaoInINJ44Qh4weo_z8nDwDUf8Q&usqp=CAU',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textWidget(
                                text: car.brandModelName.toString(),
                                textOverflow: TextOverflow.visible,
                                style:
                                    getSemiBoldStyle(fontSize: 14.sp).copyWith(
                                  height: 1.2.sp,
                                  fontWeight: FontWeight.w600,
                                  // fontFamily: 'neue'
                                )),
                            car.status.toString() == 'booked'
                                ? Row(
                                    children: [
                                      SvgPicture.asset(ImageAssets.naira),
                                      SizedBox(
                                        width: 2.sp,
                                      ),
                                      textWidget(
                                        text: car.pricePerDay ?? 0.toString(),
                                        style: getMediumStyle(fontSize: 12.sp)
                                            .copyWith(
                                          fontFamily: 'Neue',
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        ImageAssets.close,
                                        height: 6,
                                        color: secondaryColor,
                                      ),
                                      textWidget(
                                        text: ' days',
                                        style: getMediumStyle(fontSize: 12.sp)
                                            .copyWith(
                                          fontFamily: 'Neue',
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 145.sp,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 6.sp,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      textWidget(
                                          text: AppStrings.startDate,
                                          style: getLightStyle(
                                              fontSize: 7.sp, color: black)),
                                      SizedBox(
                                        width: 5.sp,
                                      ),
                                      textWidget(
                                          text: AppStrings.endDate,
                                          style: getLightStyle(
                                              fontSize: 7.sp, color: black)),
                                      SizedBox(
                                        width: 2.sp,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      dateTimeColWIdget(
                                        alignment: CrossAxisAlignment.start,
                                        // title: 'lol',
                                        title:
                                            "${formatDayDate1(car.startDate.toString())},",
                                        titleFontSize: 10.sp,
                                        subTitleFontSize: 10.sp,
                                        subTitleFontWeight: FontWeight.w500,
                                        // subTitle: 'lol'
                                        subTitle: formatTime1(car.startDate),
                                      ),
                                      SvgPicture.asset(
                                        ImageAssets.arrowForwardRounded,
                                        height: 10.sp,
                                        width: 10.sp,
                                        color: secondaryColor,
                                      ),
                                      dateTimeColWIdget(
                                          alignment: CrossAxisAlignment.start,
                                         
                                          title: formatDayDate1(
                                          car.endDate),
                                          titleFontSize: 10.sp,
                                          subTitleFontSize: 10.sp,
                                          subTitleFontWeight: FontWeight.w500,
                                          // subTitle: 'lol')
                                      subTitle: formatTime1(
                                      car.startDate)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                    ImageAssets.thumbsUpPrimaryColor),
                                SizedBox(
                                  width: 5.sp,
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: '${car.percentageRate}%',
                                      style: getMediumStyle(
                                        fontSize: 12.sp,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: ' (${car.tripsCount} trips)',
                                          style: getLightStyle(
                                            fontSize: 12.sp,
                                          ),
                                        )
                                      ]),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            carAvailabilityTag(
                status:
                    '${AppStrings.carStatus} ${car.status == 'pending' ? AppStrings.pending : car.status == 'active' ? AppStrings.active : car.status}'),
          ],
        ),
      ),
    );
  }

  Widget manageListedVehicles({void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70.sp,
        //width: size.width,
        margin: EdgeInsets.symmetric(vertical: 20.sp),
        decoration: BoxDecoration(
            color: primaryColorLight,
            borderRadius: BorderRadius.all(
              Radius.circular(4.r),
            ),
            image: const DecorationImage(
                alignment: Alignment.centerRight,
                image: AssetImage(
                  ImageAssets.manageListedBg,
                ),
                fit: BoxFit.fitHeight)),

        child: Row(children: [
          Container(
            // width: 66.sp, // Set the width equal to the desired height
            height: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.r),
                  bottomLeft: Radius.circular(4.r)),
              child: Image.asset(
                ImageAssets.steering1,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          // SizedBox(
          //   width: 10.sp,),
          Container(
            width: 147.sp,
            height: 68.sp,
            padding: const EdgeInsets.only(left: 10, top: 2, bottom: 5),
            child: Column(
              children: [
                textWidget(
                    text: AppStrings.manageListedVehicles,
                    textOverflow: TextOverflow.visible,
                    style: getSemiBoldStyle(fontSize: 14.sp).copyWith(
                        height: 1.2.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'neue')),
                SizedBox(
                  height: 2.sp,
                ),
                textWidget(
                    text: AppStrings.manageYourVehicleAViailability,
                    textOverflow: TextOverflow.visible,
                    style: getLightStyle(fontSize: 10.sp).copyWith(
                      fontWeight: FontWeight.w400,
                      height: 1.2.sp,
                    )),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget getCarListedCard({void Function()? onTap}) {
    return Stack(
      children: [
        Container(
          height: 140.sp,
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8.sp),
          decoration: BoxDecoration(
              color: primaryColorLight3,
              borderRadius: BorderRadius.all(Radius.circular(4.r)),
              image: const DecorationImage(
                  image: AssetImage(ImageAssets.carListingBg),
                  fit: BoxFit.fitHeight)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 139.sp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWidget(
                      text: AppStrings.getYourCarListed,
                      style: getMediumStyle(),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Expanded(
                      child: textWidget(
                        text: AppStrings.doYouWantToListYourCar,
                        textOverflow: TextOverflow.visible,
                        style: getRegularStyle(fontSize: 10),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    GtiButton(
                      width: 90.sp,
                      height: 26.sp,
                      fontSize: 10.sp,
                      text: AppStrings.listMyCar,
                      onTap: onTap,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 5,
          right: 2,
          child: Image.asset(
            ImageAssets.greyCar,
            width: 190.sp,
          ),
        ),
      ],
    );
  }
}

Widget appBar(Size size, PartnerHomeController controller,
    {PartnerLandingController? landingController}) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            landingController!.tabIndex.value = 3;
          },
          child: profileAvatar(
            height: 40,
            width: 40,
            imgUrl: userService.user.value.profilePic!,
            // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ88joJfjwoaz_jWaMQhbZn2X11VHGBzWKiQg&usqp=CAU',
          ),
        ),
        switchProfileWidget(
            size: size,
            title: AppStrings.partner,
            imageUrl: ImageAssets.owner,
            onTapCarRenter: controller.switchProfileToRenter),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Icon(
            Iconsax.notification4,
            size: 24.sp,
          ),
        ),
      ],
    ),
  );
}
