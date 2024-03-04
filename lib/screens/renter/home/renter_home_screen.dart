import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/renter/home/renter_home_controller.dart';
import 'package:gti_rides/screens/renter/landing_controller.dart';
import 'package:gti_rides/screens/renter/widgets/build_carousel_dot.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/how_gti_works_widget.dart';
import 'package:gti_rides/shared_widgets/shimmer_loading/box_shimmer.dart';
import 'package:gti_rides/shared_widgets/switch_profile_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/helpers.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

class CarRenterBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<CarRenterHomeController>(CarRenterHomeController());
  }
}

class CarRenterHomeScreen extends StatefulWidget {
  const CarRenterHomeScreen({
    super.key,
  });

  @override
  State<CarRenterHomeScreen> createState() => _CarRenterHomeScreenState();
}

class _CarRenterHomeScreenState extends State<CarRenterHomeScreen> {
  final controller =
      Get.put<CarRenterHomeController>(CarRenterHomeController());

  late Timer timer;
  RxInt currentIndex = 0.obs;
  RxList visibleCars = [].obs;

  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  late PageController cardPageController;
  ScrollController scrollController = ScrollController();
  final GlobalKey pageViewKey1 = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init called>>>");

    cardPageController = PageController(
        viewportFraction: calculateViewportFraction(), initialPage: 0);

    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentIndex.value < visibleCars.length) {
        print("visible cars:: ${visibleCars}");
        setState(() {
          currentIndex.value++;
        });
        print("next page ${currentIndex.value}>>>");
      } else {
        setState(() {
          currentIndex.value = 0;
        });
      }

      if (pageViewKey1.currentState != null && scrollController.hasClients) {
        cardPageController.animateToPage(
          currentIndex.value,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeIn,
        );
      }
    });
  }

  double calculateViewportFraction() {
    if (visibleCars.value.length == 1) {
      // If there is only one visible car, set the viewport to fill the screen width
      return 1.0;
    } else {
      // If there are more than one visible cars, use the initial set value
      return 0.9;
    }
  }

  @override
  void dispose() {
    // Cancel the timer to prevent calling setState after dispose
    timer.cancel();
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
          onRefresh: controller.getRecentCars,
          child: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    // appBar(size, controller: controller),
                    appBar(size, controller),
                    body(controller, size),
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
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar(Size size, CarRenterHomeController controller) {
    final renterController = Get.put(RenterLandingController());
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              print("Hellor world");
              renterController.tabIndex.value = 3;
            },
            child: profileAvatar(
                height: 40, width: 40, imgUrl: controller.user.value.profilePic!
                // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ88joJfjwoaz_jWaMQhbZn2X11VHGBzWKiQg&usqp=CAU',
                ),
          ),
          switchProfileWidget(
              size: size,
              title: AppStrings.renter,
              imageUrl: ImageAssets.renter,
              onTapCarOwner: controller.switchProfileToOwner),
          GestureDetector(
            onTap: controller.routeToNotification,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                Iconsax.notification4,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget body(CarRenterHomeController controller, Size size) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            headerText(controller),
            discoverCity(onTap: () => controller.routeToSearchCity()),
            howGtiWorksCard(
                onTap: () {
                  controller.launchWebsite();
                },
                imageUrl: ImageAssets.ladyPick),
            textWidget(
              text: AppStrings.recentViewCar,
              style: getRegularStyle(),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 205.sp,
              child: controller.obx(
                (state) {
                  visibleCars.value = state?.take(5).toList() ?? [];
                  return Stack(
                    children: [
                      PageView(
                        key: pageViewKey1,
                        padEnds: false,
                        physics: const ScrollPhysics(),
                        controller: cardPageController,
                        onPageChanged: (int index) {
                          setState(() {
                            currentIndex.value = index;
                          });
                        },
                        scrollDirection: Axis.horizontal,
                        children:
                            List<Widget>.generate(visibleCars.length, (index) {
                          // final car = controller.recentlyViewedCar[index];
                          final recentCar = visibleCars[index];

                          return GestureDetector(
                            onTap: () => controller.routeToCarSelectionResult(
                                arguments: {"carId": recentCar.carId}),
                            child: Container(
                              // width: 350,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4.r),
                                  ),
                                  border: Border.all(color: borderColor)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  carImage(
                                    imgUrl: recentCar.photoUrl,
                                    height: 140.sp,
                                    width: size.width.sp,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    child: textWidget(
                                      // brand years is left to be added
                                      text:
                                          "${recentCar.brandName} ${recentCar.brandModelName}",
                                      style: getMediumStyle().copyWith(
                                          fontFamily: 'Neue',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                ImageAssets.thumbsUpGreen),
                                            SizedBox(
                                              width: 5.sp,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  // text: '${car.ratings}%',
                                                  text:
                                                      '${recentCar.percentageRate.toString()}%',
                                                  style: getMediumStyle(
                                                    fontSize: 12.sp,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          ' (${recentCar.tripsCount.toString()} trips)',
                                                      style: getLightStyle(
                                                          fontSize: 12.sp,
                                                          color: grey2),
                                                    )
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(ImageAssets.tag),
                                            SizedBox(
                                              width: 2.sp,
                                            ),
                                            SvgPicture.asset(ImageAssets.naira),
                                            SizedBox(
                                              width: 2.sp,
                                            ),
                                            textWidget(
                                              text:
                                                  '${recentCar.pricePerDay.toString() ?? ''}/day',
                                              style: getMediumStyle().copyWith(
                                                fontFamily: 'Neue',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      Positioned(
                        bottom: 70,
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
                  );
                },
                // onEmpty: Padding(
                //   padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
                //   child: Center(
                //       child: textWidget(
                //           text: AppStrings.noViewedCarsYet,
                //           style: getMediumStyle())),
                // ),
                onEmpty: SizedBox(
                   height: 235.sp,
                  width: size.width.sp,
                  child: Card(
                    color: white,
                    surfaceTintColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/Lx570.png',
                          height: 140.sp,
                          width: size.width,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidget(
                                      text: 'Lx570',
                                      textOverflow: TextOverflow.visible,
                                      style: getSemiBoldStyle(
                                              fontSize: 14.sp)
                                          .copyWith(
                                        height: 1.2.sp,
                                        fontWeight: FontWeight.w600,
                                        // fontFamily: 'neue'
                                      )),
                                  // car.status.toString() ==
                                  //         'booked'
                                  //     ? Row(
                                  //         children: [
                                  //           SvgPicture.asset(
                                  //               ImageAssets
                                  //                   .naira),
                                  //           SizedBox(
                                  //             width: 2.sp,
                                  //           ),
                                  //           textWidget(
                                  //             text: car
                                  //                     .pricePerDay ??
                                  //                 0.toString(),
                                  //             style: getMediumStyle(
                                  //                     fontSize:
                                  //                         12.sp)
                                  //                 .copyWith(
                                  //               fontFamily:
                                  //                   'Neue',
                                  //             ),
                                  //           ),
                                  //           SvgPicture
                                  //               .asset(
                                  //             ImageAssets
                                  //                 .close,
                                  //             height: 6,
                                  //             color:
                                  //                 secondaryColor,
                                  //           ),
                                  //           textWidget(
                                  //             text:
                                  //                 ' days',
                                  //             style: getMediumStyle(
                                  //                     fontSize:
                                  //                         12.sp)
                                  //                 .copyWith(
                                  //               fontFamily:
                                  //                   'Neue',
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       )
                                  //     : const SizedBox(),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment
                              //           .spaceBetween,
                              //   children: [
                              //     SizedBox(
                              //       width: 145.sp,
                              //       child: Column(
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment
                              //                 .start,
                              //         children: [
                              //           SizedBox(
                              //             height: 6.sp,
                              //           ),
                              //           Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment
                              //                     .spaceBetween,
                              //             children: [
                              //               textWidget(
                              //                   text: AppStrings
                              //                       .startDate,
                              //                   style: getLightStyle(
                              //                       fontSize: 7
                              //                           .sp,
                              //                       color:
                              //                           black)),
                              //               SizedBox(
                              //                 width: 5.sp,
                              //               ),
                              //               textWidget(
                              //                   text: AppStrings
                              //                       .endDate,
                              //                   style: getLightStyle(
                              //                       fontSize: 7
                              //                           .sp,
                              //                       color:
                              //                           black)),
                              //               SizedBox(
                              //                 width: 2.sp,
                              //               ),
                              //             ],
                              //           ),
                              //           Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment
                              //                     .spaceBetween,
                              //             children: [
                              //               dateTimeColWIdget(
                              //                 alignment:
                              //                     CrossAxisAlignment
                              //                         .start,
                              //                 // title: 'lol',
                              //                 title:
                              //                     "${formatDayDate1(car.startDate.toString())},",
                              //                 titleFontSize:
                              //                     10.sp,
                              //                 subTitleFontSize:
                              //                     10.sp,
                              //                 subTitleFontWeight:
                              //                     FontWeight
                              //                         .w500,
                              //                 // subTitle: 'lol'
                              //                 subTitle:
                              //                     formatTime1(
                              //                         car.startDate),
                              //               ),
                              //               SvgPicture
                              //                   .asset(
                              //                 ImageAssets
                              //                     .arrowForwardRounded,
                              //                 height:
                              //                     10.sp,
                              //                 width:
                              //                     10.sp,
                              //                 color:
                              //                     secondaryColor,
                              //               ),
                              //               dateTimeColWIdget(
                              //                   alignment:
                              //                       CrossAxisAlignment
                              //                           .start,
                              //                   title: formatDayDate1(car
                              //                       .endDate),
                              //                   titleFontSize:
                              //                       10.sp,
                              //                   subTitleFontSize:
                              //                       10.sp,
                              //                   subTitleFontWeight:
                              //                       FontWeight
                              //                           .w500,
                              //                   // subTitle: 'lol')
                              //                   subTitle:
                              //                       formatTime1(
                              //                           car.startDate)),
                              //             ],
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //     Row(
                              //       children: [
                              //         SvgPicture.asset(
                              //             ImageAssets
                              //                 .thumbsUpPrimaryColor),
                              //         SizedBox(
                              //           width: 5.sp,
                              //         ),
                              //         RichText(
                              //           text: TextSpan(
                              //               text:
                              //                   '${car.percentageRate}%',
                              //               style:
                              //                   getMediumStyle(
                              //                 fontSize:
                              //                     12.sp,
                              //               ),
                              //               children: <TextSpan>[
                              //                 TextSpan(
                              //                   text:
                              //                       ' (${car.tripsCount} trips)',
                              //                   style:
                              //                       getLightStyle(
                              //                     fontSize:
                              //                         12.sp,
                              //                   ),
                              //                 )
                              //               ]),
                              //         ),
                              //       ],
                              //     )
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
                onLoading: boxShimmer(height: 200.sp),
              ),
            ),

            // Text(
            //   controller.exampleText.value,
            // ),
          ],
        ),
      ),
    );
  }

  Widget headerText(CarRenterHomeController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        textWidget(
            text: AppStrings.welcomeBack
                .trArgs([extractFirstName(controller.user.value.fullName!)]),
            style: getRegularStyle().copyWith(fontWeight: FontWeight.w400)),
        SizedBox(
          width: 5.sp,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: SvgPicture.asset(ImageAssets.wavingHand),
        ),
      ],
    );
  }

  Widget discoverCity({void Function()? onTap}) {
    return Container(
      width: MediaQuery.of(context).size.width.sp,
      padding: EdgeInsets.symmetric(vertical: 15.sp),
      child: Stack(alignment: Alignment.center, children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4.r)),
              child: Image.asset(
                ImageAssets.ikiyiLinkBridge,
                fit: BoxFit.fitHeight,
                height: 260.sp,
              )),
        ),
        Positioned(
          bottom: 30.sp,
          left: 15,
          right: 15,
          child: Container(
            height: 130.sp,
            padding: EdgeInsets.all(20.sp),
            decoration: BoxDecoration(
                color: primaryColorDark.withOpacity(0.6),
                image: const DecorationImage(
                  // filterQuality: FilterQuality.medium,
                  image: AssetImage("assets/images/splash_bg.png"),
                ),
                borderRadius: BorderRadius.all(Radius.circular(4.r))),
            child: Column(
              children: [
                textWidget(
                    text: "Discover your perfect Ride.",
                    style: getBoldStyle(fontSize: 18.sp, color: white).copyWith(
                        fontWeight: FontWeight.w900, fontFamily: 'neue')),
                textWidget(
                    text: "Feel free to search for car in your location",
                    style:
                        getLightStyle(fontSize: 12.sp, color: white).copyWith(
                      fontWeight: FontWeight.w400,
                    )),
                SizedBox(
                  height: 10.sp,
                ),
                GestureDetector(
                    onTap: onTap,
                    child: SvgPicture.asset('assets/svg/search_field.svg')),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
