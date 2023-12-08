import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20renter/home/search_result/search_result_controller.dart';
import 'package:gti_rides/screens/car%20renter/widgets/build_carousel_dot.dart';
import 'package:gti_rides/screens/car%20renter/widgets/car_availability_tag.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class SearchResultBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<SearchResultController>(SearchResultController());
  }
}

class SearchResultScreen extends GetView<SearchResultController> {
  const SearchResultScreen([Key? key]) : super(key: key);
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
            scale: 0.5,
            child: SvgPicture.asset(ImageAssets.arrowLeft, color: black)),
        centerTitle: false,
        title: textWidget(
            text: "Surulere, Lagos",
            style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
        titleColor: iconColor(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10),
            child: InkWell(
              onTap: () => controller.routeToSearchFilter(),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: verticalDivider(color: grey1),
                  ),
                  textWidget(
                      text: "1 - 5 Nov",
                      style: getRegularStyle(color: black)
                          .copyWith(fontWeight: FontWeight.w500)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: verticalDivider(color: grey1),
                  ),
                  SvgPicture.asset(ImageAssets.filter)
                ],
              ),
            ),
          )
        ]);
  }

  Widget body(size, context) {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 24.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => controller.routeToCarSelection(),
                  child: Container(
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
                        SizedBox(
                          height: 150.sp,
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
                                    // borderRadius:
                                    //     BorderRadius.all(Radius.circular(4.r)),
                                    child: Image.asset(
                                      "assets/images/range.png",
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  ClipRRect(
                                    // borderRadius:
                                    //     BorderRadius.all(Radius.circular(4.r)),
                                    child: Image.asset("assets/images/car.png"),
                                  ),
                                  ClipRRect(
                                    // borderRadius:
                                    //     BorderRadius.all(Radius.circular(4.r)),
                                    child: Image.asset("assets/images/car.png"),
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: 10,
                                right: 0,
                                left: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: List.generate(
                                    3,
                                    (index) => BuildCarouselDot(
                                      currentIndex: 1,
                                      index: index,
                                    ),
                                  ),
                                ),
                              ),
                              carAvailabilityTag(
                                  positionRight: 7.sp,
                                  positionTop: 6.sp,
                                  status: AppStrings.available),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: textWidget(
                            text: '20212 KIA Sportage',
                            style: getMediumStyle().copyWith(
                                fontFamily: 'Neue',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            text: '97%',
                                            style: getMediumStyle(
                                              fontSize: 12.sp,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: ' (66 trips)',
                                                  style: getLightStyle(
                                                      fontSize: 12.sp,
                                                      color: grey2),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          // navigate to desired screen
                                                        })
                                            ]),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2.sp,
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(ImageAssets.location1),
                                      SizedBox(
                                        width: 5.sp,
                                      ),
                                      textWidget(
                                        text: 'Surulere, Lagos state',
                                        style: getMediumStyle().copyWith(
                                          fontFamily: 'Neue',
                                        ),
                                      ),
                                    ],
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
                                    text: '5,000/day',
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
                ); // Display the widgets from filteredPages
              },
              separatorBuilder: (context, _) => SizedBox(height: 24.h),
            ),
            textWidget(
                text: controller.testString.value, style: getMediumStyle()),
            SizedBox(
              height: size.height * 0.02,
            ),
            // continueButton(),
          ],
        ));
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
