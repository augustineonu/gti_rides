import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/cars_model.dart';
import 'package:gti_rides/screens/renter/home/search_result/search_result_controller.dart';
import 'package:gti_rides/screens/renter/widgets/build_carousel_dot.dart';
import 'package:gti_rides/screens/renter/widgets/car_availability_tag.dart';
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
            text:
                "${controller.selectedCity.value}, ${controller.selectedState.value}",
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
                      text:
                          "${controller.startDate.value} - ${controller.endDate.value}",
                      style: getRegularStyle(color: black, fontSize: 12.sp)
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

  Widget body(size, BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 24.sp),
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<SearchResultController>(
                init: SearchResultController(),
                initState: (_) {},
                builder: (_) {
                  return ListView.separated(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.carListData!.length,
                    itemBuilder: (context, index) {
                      var carData = controller.carListData![index];
                      return InkWell(
                        onTap: () => controller.routeToCarSelection(arguments: {
                          "carId": carData.carId,
                          "startDateTime": controller.startDateTime.value,
                          "endDateTime": controller.endDateTime.value,
                          "differenceInDays": controller.differenceInDays.value
                        }),
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
                                      controller: controller.pageController,
                                      onPageChanged: (int index) =>
                                          controller.onPageChanged(index),
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        for (Photo? carPhoto
                                            in carData.photo!.take(5))
                                          if (carPhoto != null)
                                            carImage(
                                              imgUrl: carPhoto.photoUrl!,
                                              height: 200.sp,
                                              width: 400.sp,
                                              fit: BoxFit.fitWidth,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(4.r),
                                                  topRight:
                                                      Radius.circular(4.r)),
                                            ),
                                      ],
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      right: 0,
                                      left: 0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: List.generate(
                                          carData.photo!.take(5).length,
                                          (index) => BuildCarouselDot(
                                            currentIndex:
                                                controller.currentIndex.value,
                                            index: index,
                                          ),
                                        ),
                                      ),
                                    ),
                                    carAvailabilityTag(
                                        positionRight: 7.sp,
                                        positionTop: 6.sp,
                                        status: carData.availability ==
                                                'available'.toLowerCase()
                                            ? AppStrings.available
                                            : AppStrings.unavailable),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 10),
                                child: textWidget(
                                  text:
                                      '${carData.brandName ?? ''} ${carData.brandModelName}',
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  text:
                                                      '${carData.percentageRate.toString()}%',
                                                  style: getMediumStyle(
                                                    fontSize: 12.sp,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            ' (${carData.tripsCount.toString()} trips)',
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
                                            SvgPicture.asset(
                                                ImageAssets.location1),
                                            SizedBox(
                                              width: 5.sp,
                                            ),
                                            textWidget(
                                              text:
                                                  '${controller.selectedCity.value}, ${controller.selectedState.value}',
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
                                          text:
                                              '${carData.pricePerDay.toString()}/day',
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
                    },
                    separatorBuilder: (context, _) => SizedBox(height: 24.h),
                  );
                },
              ), // Display the widgets from filteredPages

              SizedBox(
                height: size.height * 0.02,
              ),
              // continueButton(),
            ],
          );
        }));
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
