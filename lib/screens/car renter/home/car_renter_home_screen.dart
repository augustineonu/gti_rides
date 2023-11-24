import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20renter/home/car_renter_home_controller.dart';
import 'package:gti_rides/screens/car%20renter/widgets/build_carousel_dot.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:iconsax/iconsax.dart';

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
        currentIndex.value++;
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
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ctrl = Get.put<CarRenterHomeController>(CarRenterHomeController());
    return Obx(
      () => Scaffold(
        appBar: appBar(),
        body: SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 16.sp),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
                width: 50,
                child: imageAvatar(
                          imgUrl:
                  "https://img.freepik.com/premium-vector/avatar-profile-icon_188544-4755.jpg",
                          height: 34.sp,
                          width: 34.sp),
              ),

              imageAvatar1(  imgUrl:
                  "https://img.freepik.com/premium-vector/avatar-profile-icon_188544-4755.jpg",
                          height: 34.sp,
                          width: 34.sp),

              headerText(),
              discoverCity(onTap: () => ctrl.routeToSearchCity()),
              howGtiWorksCard(onTap: () {}),
              textWidget(
                text: AppStrings.recentViewCar,
                style: getRegularStyle(),
              ),
              // ClipRRect(
              //   borderRadius: BorderRadius.all(Radius.circular(4.r)),
              //   child: Image.asset("assets/images/car.png"),
              // ),
              SizedBox(
                height: 150.sp,
                child: Stack(
                  children: [
                    PageView(
                      physics: ScrollPhysics(),
                      controller: cardPageController,
                      onPageChanged: (int index) {
                        currentIndex.value = index;
                      },
                      scrollDirection: Axis.horizontal,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(4.r)),
                          child: Image.asset(
                            "assets/images/car.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(4.r)),
                          child: Image.asset("assets/images/car.png"),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(4.r)),
                          child: Image.asset("assets/images/car.png"),
                        ),
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
      ),
    );
  }

  Widget howGtiWorksCard({void Function()? onTap}) {
    return Container(
      // height: 125.sp,
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: primaryColorLight,
        borderRadius: BorderRadius.all(
          Radius.circular(4.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(
              // width: 120.sp,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWidget(
                        text: AppStrings.howGtiWorks,
                        style: getSemiBoldStyle(fontSize: 16.sp).copyWith(
                            fontWeight: FontWeight.w600, fontFamily: 'neue')),
                    SizedBox(
                      height: 7.sp,
                    ),
                    textWidget(
                        text: AppStrings.weArePeer,
                        style: getLightStyle(fontSize: 10.sp)
                            .copyWith(fontWeight: FontWeight.w400)),
                    SizedBox(
                      height: 7.sp,
                    ),
                    InkWell(
                      onTap: onTap,
                      child: textWidget(
                          text: AppStrings.readMore,
                          style: getLightStyle(fontSize: 10.sp).copyWith(
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(
                4.r,
              ),
              bottomRight: Radius.circular(
                4.r,
              ),
            ),
            child: Image.asset(
              ImageAssets.ladyWorks,
              width: 170.sp,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }

  Widget discoverCity({void Function()? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.sp),
      child: Stack(children: [
        ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4.r)),
            child: Image.asset(
              ImageAssets.ladyHandout,
              fit: BoxFit.cover,
              height: 260.sp,
            )),
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

AppBar appBar() {
  return gtiAppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: imageAvatar(
            imgUrl:
                "https://img.freepik.com/premium-vector/avatar-profile-icon_188544-4755.jpg",
            height: 34.sp,
            width: 34.sp),
      ),
      title: Container(
        // width: 138.sp,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: BoxDecoration(
          color: primaryColorLight,
          borderRadius: BorderRadius.all(
            Radius.circular(4.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset("assets/images/key.png"),
            SizedBox(
              width: 4.w,
            ),
            textWidget(
                text: AppStrings.carRenter,
                style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
            SizedBox(
              width: 8.w,
            ),
            CircleAvatar(
              radius: 15.r,
              backgroundColor: primaryColor,
              child: SvgPicture.asset(
                ImageAssets.arrowDown,
                height: 11.sp,
              ),
            )
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Icon(
            Iconsax.notification4,
            size: 24.sp,
          ),
        )
      ]);
}
