import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/Partner/home/manage_vehicle/manage_vehicle_controller.dart';
import 'package:gti_rides/screens/Partner/rent_history/rent_history_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/tab_indicator.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:iconsax/iconsax.dart';

class RentHistoryBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<RentHistoryController>(RentHistoryController());
  }
}

class RentHistoryScreen extends GetView<RentHistoryController> {
  const RentHistoryScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final controller = Get.put<RentHistoryController>(RentHistoryController());
    return Obx(() => Scaffold(
          // body: body(size, context)),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, top: 13.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(6.sp),
                    decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(4.r))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tabIndicator(
                            width: 150.sp,
                            title: AppStrings.active,
                            selected: controller.selectedIndex.value == 0,
                            onTap: () => controller.selectedIndex.value = 0),
                        tabIndicator(
                            width: 150.sp,
                            title: AppStrings.completed,
                            selected: controller.selectedIndex.value == 1,
                            onTap: () => controller.selectedIndex.value = 1),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.sp,
                  ),
                  buildBody(context, size),
                  textWidget(
                      text: controller.testString.value,
                      style: getRegularStyle()),
                ],
              ),
            ),
          ),
          // }
        ));
  }

  Widget buildBody(context, Size size) {
    switch (controller.selectedIndex.value) {
      case 0:
        // Active trips
        return ListView.separated(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            return cardWidget(
              context,
              size,
              title: 'Tesla Model Y',
              amount: '100,000 ',
              noOfDays: '5days',
              startDateTime: "wed, 1 Nov, 9:00am",
              endDateTime: "wed, 1 Nov, 9:00am",
              trailling: Positioned(
                right: 12.sp,
                top: 12.sp,
                child: InkWell(
                    onTap: () {
                      quickOptionsSheet(size);
                    },
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset(ImageAssets.popUpMenu))),
              ),
            );
          },
          separatorBuilder: (context, _) => const SizedBox(height: 15),
        );

      case 1:
        // Completed trips
        return cardWidget(
          context,
          size,
          title: 'Tesla Model Y',
          amount: '100,000 ',
          noOfDays: '5days',
          startDateTime: "wed, 1 Nov, 9:00am",
          endDateTime: "wed, 1 Nov, 9:00am",
          trailling: Positioned(
            right: 7.sp,
            top: 11.sp,
            child: InkWell(
              onTap: controller.routeToCompletedTrip,
              child: Row(children: [
                textWidget(
                    text: AppStrings.completed,
                    style:
                        getRegularStyle(fontSize: 10.sp, color: primaryColor)),
                const Icon(
                  Iconsax.arrow_right_3,
                  color: primaryColor,
                  size: 12,
                )
              ]),
            ),
          ),
        );

      default:
        return const SizedBox();
    }
  }

  Widget cardWidget(context, Size size,
      {required String title,
      required String amount,
      required String noOfDays,
      required String startDateTime,
      required String endDateTime,
      required Widget trailling}) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(color: greyLight),
              borderRadius: BorderRadius.all(Radius.circular(4.r))),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.r),
                        bottomLeft: Radius.circular(4.r)),
                    child: Image.asset(
                      'assets/images/fav_car.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      // width: 135.sp,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textWidget(text: title, style: getBoldStyle()),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            // crossAxisAlignment: alignment,
                            children: [
                              SvgPicture.asset(ImageAssets.naira),
                              textWidget(
                                  text: amount,
                                  style: getMediumStyle(fontSize: 10.sp)
                                      .copyWith(fontFamily: 'Neue')),
                              // textWidget(
                              //     text: ' x ', style: getMediumStyle(fontSize: 10.sp).copyWith(fontFamily: 'Neue')),
                              SvgPicture.asset(
                                ImageAssets.closeSmall,
                                width: 7.sp,
                                height: 7.sp,
                              ),
                              textWidget(
                                  text: ' $noOfDays',
                                  style: getMediumStyle(fontSize: 10.sp)
                                      .copyWith(fontFamily: 'Neue')),
                            ],
                          ),

                          /// Show the thumbs up and number trips
                          //  Row(
                          //       children: [
                          //         SvgPicture.asset(
                          //             ImageAssets.thumbsUpPrimaryColor),
                          //         SizedBox(
                          //           width: 5.sp,
                          //         ),
                          //         RichText(
                          //           text: TextSpan(
                          //               text: '97%',
                          //               style: getMediumStyle(
                          //                 fontSize: 12.sp,
                          //               ),
                          //               children: <TextSpan>[
                          //                 TextSpan(
                          //                   text: ' (66 trips)',
                          //                   style: getLightStyle(
                          //                       fontSize: 12.sp, color: grey2),
                          //                 )
                          //               ]),
                          //         ),
                          //       ],
                          //     ),

                          ////////
                          const SizedBox(
                            height: 10,
                          ),

                          textWidget(
                            text: AppStrings.tripDate,
                            // show AppStrings.aAvailabilityDate
                            style: getRegularStyle(
                              color: grey3,
                              fontSize: 10.sp,
                            ),
                          ),

                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textWidget(
                                  text: startDateTime,
                                  textOverflow: TextOverflow.visible,
                                  style: getMediumStyle(fontSize: 10.sp)
                                      .copyWith(fontFamily: 'Neue')),
                              SizedBox(width: 2),
                              SvgPicture.asset(
                                ImageAssets.arrowForwardRounded,
                                height: 8.sp,
                                width: 8.sp,
                              ),
                              SizedBox(width: 2),
                              textWidget(
                                  text: endDateTime,
                                  textOverflow: TextOverflow.visible,
                                  style: getMediumStyle(fontSize: 10.sp)
                                      .copyWith(fontFamily: 'Neue')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        trailling
      ],
    );
  }

  Future<dynamic> quickOptionsSheet(Size size) {
    return Get.bottomSheet(
      SizedBox(
        height: size.height * 0.2.sp,
        width: size.width.sp,
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          itemCount: controller.quickOptions.length,
          itemBuilder: (context, index) {
            final option = controller.quickOptions[index];
            return InkWell(
              onTap: () {
                switch (index) {
                  case 0:
                  // report trip to admin;

                  case 1:
                    // controller.routeToCarHistory();

                    break;
                  default:
                }
              },
              child: Row(
                children: [
                  SvgPicture.asset(option['imageUrl']!),
                  const SizedBox(
                    width: 6,
                  ),
                  textWidget(
                      text: option['title'],
                      style: getRegularStyle(color: primaryColor)),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: 18,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.r), topRight: Radius.circular(4.r)),
      ),
    );
  }

  Widget continueButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 50.sp,
            width: 3000.sp,
            text: "continue".tr,
            color: primaryColor,
            // onTap: controller.routeToPhoneVerification,
            isLoading: controller.isLoading.value,
          );
  }
}
