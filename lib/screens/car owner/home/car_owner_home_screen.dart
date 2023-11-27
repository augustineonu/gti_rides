import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20owner/home/car_owner_home_controller.dart';
import 'package:gti_rides/screens/car%20renter/widgets/build_carousel_dot.dart';
import 'package:gti_rides/shared_widgets/date_time_col_widget.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/how_gti_works_widget.dart';
import 'package:gti_rides/shared_widgets/switch_profile_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:iconsax/iconsax.dart';

class CarOwnerBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<CarOwnerHomeController>(CarOwnerHomeController());
  }
}

class CarOwnerHomeScreen extends StatefulWidget {
  const CarOwnerHomeScreen({
    super.key,
  });

  @override
  State<CarOwnerHomeScreen> createState() => _CarRenterHomeScreenState();
}

class _CarRenterHomeScreenState extends State<CarOwnerHomeScreen> {
  late Timer timer;
  RxInt currentIndex = 0.obs;

  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  late PageController cardPageController;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init called>>>");
    cardPageController = PageController(initialPage: 0);

    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentIndex.value < 2) {
        // currentIndex.value++;
        print("next page ${currentIndex.value}>>>");
      } else {
        currentIndex.value = 0;
      }

      if (scrollController.hasClients) {
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
    final ctrl = Get.put<CarOwnerHomeController>(CarOwnerHomeController());
    return Obx(
      () => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              appBar(size, ctrl),
              body(ctrl),
            ],
          ),
        ),
      ),
    );
  }

  Widget body(
    CarOwnerHomeController ctrl,
  ) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 16.sp),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getCarListedCard(onTap: () {}),
            manageListedVehicles(),
            howGtiWorksCard(onTap: () {}, imageUrl: ImageAssets.guyWorks),
            // textWidget(
            //   text: AppStrings.recentViewCar,
            //   style: getRegularStyle(),
            // ),

            SizedBox(
              height: 235.sp,
              child: Stack(
                children: [
                  PageView(
                    physics: const ScrollPhysics(),
                    controller: cardPageController,
                    onPageChanged: (int index) {
                      currentIndex.value = index;
                    },
                    scrollDirection: Axis.horizontal,
                    children: [
                      carCardWidget(),
                      carCardWidget(),
                      carCardWidget(),
                    ],
                  ),
                  Positioned(
                    bottom: 3,
                    right: 0,
                    left: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => BuildCarouselDot(
                          currentIndex: currentIndex.value,
                          index: index,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Text(
              ctrl.exampleText.value,
            ),
          ],
        ),
      ),
    );
  }

  Widget carCardWidget() {
    return Card(
      color: white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.r),
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(4.r),
              topLeft: Radius.circular(4.r),
            ),
            child: Image.asset(
              "assets/images/car.png",
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(11.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textWidget(
                        text: '2019 KIA SPORTAGE',
                        textOverflow: TextOverflow.visible,
                        style: getSemiBoldStyle(fontSize: 14.sp).copyWith(
                          height: 1.2.sp,
                          fontWeight: FontWeight.w600,
                          // fontFamily: 'neue'
                        )),
                    Row(
                      children: [
                        SvgPicture.asset(ImageAssets.naira),
                        SizedBox(
                          width: 2.sp,
                        ),
                        textWidget(
                          text: '100,000 ',
                          style: getMediumStyle(fontSize: 12.sp).copyWith(
                            fontFamily: 'Neue',
                          ),
                        ),
                        SvgPicture.asset(
                          ImageAssets.close,
                          height: 6,
                          color: secondaryColor,
                        ),
                        textWidget(
                          text: ' 5days',
                          style: getMediumStyle(fontSize: 12.sp).copyWith(
                            fontFamily: 'Neue',
                          ),
                        ),
                      ],
                    ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textWidget(
                                  text: AppStrings.startDate,
                                  style: getLightStyle(
                                      fontSize: 7.sp, color: black)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              dateTimeColWIdget(
                                alignment: CrossAxisAlignment.start,
                                title: 'Wed, 1 Nov,',
                                titleFontSize: 10.sp,
                                subTitleFontSize: 10.sp,
                                subTitleFontWeight: FontWeight.w500,
                                subTitle: '9:00am',
                              ),
                              SvgPicture.asset(
                                ImageAssets.arrowForwardRounded,
                                height: 10.sp,
                                width: 10.sp,
                                color: secondaryColor,
                              ),
                              dateTimeColWIdget(
                                  alignment: CrossAxisAlignment.start,
                                  title: 'Wed, 1 Nov,',
                                  titleFontSize: 10.sp,
                                  subTitleFontSize: 10.sp,
                                  subTitleFontWeight: FontWeight.w500,
                                  subTitle: '9:00am'),
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
    );
  }

  Widget manageListedVehicles() {
    return Container(
      height: 66.sp,
      //width: size.width,
      margin: EdgeInsets.symmetric(vertical: 20.sp),
      decoration: BoxDecoration(
          color: primaryColorLight,
          borderRadius: BorderRadius.all(
            Radius.circular(4.r),
          ),
          image: const DecorationImage(
              alignment: Alignment.centerRight,
              image: AssetImage(ImageAssets.manageListedBg))),

      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.r), bottomLeft: Radius.circular(4.r)),
          child: Image.asset(
            ImageAssets.steering1,
            fit: BoxFit.fitHeight,
          ),
        ),
        // SizedBox(
        //   width: 10.sp,),
        SizedBox(
          width: 147.sp,
          height: 66.sp,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 2, bottom: 5),
            child: Column(
              children: [
                textWidget(
                    text: AppStrings.manageListedVehicles,
                    textOverflow: TextOverflow.visible,
                    style: getSemiBoldStyle(fontSize: 15.sp).copyWith(
                        height: 1.2.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'neue')),
                SizedBox(
                  height: 2.sp,
                ),
                Expanded(
                  child: textWidget(
                      text: AppStrings.manageYourVehicleAViailability,
                      textOverflow: TextOverflow.visible,
                      style: getLightStyle(fontSize: 10.sp).copyWith(
                        fontWeight: FontWeight.w400,
                        height: 1.2.sp,
                      )),
                ),
              ],
            ),
          ),
        )
      ]),
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

  Widget headerText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        textWidget(
            text: AppStrings.welcomeBack.trArgs(['Tade']),
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
}

Widget appBar(Size size, CarOwnerHomeController ctrl) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        profileAvatar(
          height: 40,
          width: 40,
          imgUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ88joJfjwoaz_jWaMQhbZn2X11VHGBzWKiQg&usqp=CAU',
        ),
        switchProfileWidget(
            size: size,
            title: AppStrings.carOwner,
            imageUrl: ImageAssets.owner,
            onTapCarRenter: ctrl.routeToCarRenterLanding),
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
