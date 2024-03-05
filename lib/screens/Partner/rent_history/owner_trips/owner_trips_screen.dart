import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/Partner/rent_history/owner_trips/owner_trips_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:iconsax/iconsax.dart';

class OwnerTripsBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<OwnerTripsController>(OwnerTripsController());
  }
}

TextEditingController textController = TextEditingController();

class OwnerTripsScreen extends GetView<OwnerTripsController> {
   OwnerTripsScreen([Key? key]) : super(key: key);
  final controller = Get.put(OwnerTripsController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: appbar(),
        body: body(context, size),
      ),
      // }
    );
  }

  Widget body(BuildContext context, Size size) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/small_car.png'),
                    SizedBox(
                      width: 6.w,
                    ),
                    textWidget(
                      text: 'Tesla Model Y',
                      textOverflow: TextOverflow.visible,
                      style: getBoldStyle(
                              fontWeight: FontWeight.w700, color: black)
                          .copyWith(
                        fontFamily: "Neue",
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 5),
                // trips type boxes
                Row(
                  children: [
                    reviewTypeBox(
                        title: AppStrings.all,
                        onTap: () => controller.selectedIndex.value = 0,
                        selected: controller.selectedIndex.value == 0),
                    reviewTypeBox(
                        title: AppStrings.activeNum.trArgs(['2']),
                        onTap: () => controller.selectedIndex.value = 1,
                        selected: controller.selectedIndex.value == 1),
                    reviewTypeBox(
                        title: AppStrings.completedNum.trArgs(['4']),
                        onTap: () => controller.selectedIndex.value = 2,
                        selected: controller.selectedIndex.value == 2),
                  ],
                ),

                const SizedBox(
                  height: 25,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              // crossAxisAlignment: alignment,
                              children: [
                                Transform.scale(
                                  scale: 0.8.sp,
                                  child: SvgPicture.asset(
                                    ImageAssets.naira,
                                  ),
                                ),
                                textWidget(
                                    text: '100,000 ',
                                    style: getMediumStyle()
                                        .copyWith(fontFamily: 'Neue')),
                                // textWidget(
                                //     text: ' x ', style: getRegularStyle()),

                                SvgPicture.asset(
                                  ImageAssets.closeSmall,
                                  width: 7.sp,
                                  height: 7.sp,
                                ),
                                textWidget(
                                    text: '5days',
                                    style: getRegularStyle(color: grey5)
                                        .copyWith(fontFamily: 'Neue')),
                              ],
                            ),
                            SizedBox(
                              height: 5.sp,
                            ),
                            textWidget(
                              text: AppStrings.tripDate,
                              style:
                                  getRegularStyle(fontSize: 10.sp, color: grey3)
                                      .copyWith(
                                fontFamily: 'Neue',
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              textWidget(
                                  text: AppStrings.active,
                                  style: getRegularStyle(
                                      fontSize: 10.sp, color: primaryColor)),
                              SizedBox(
                                width: 5.sp,
                              ),
                              Icon(
                                Iconsax.arrow_right_3,
                                color: primaryColor,
                                size: 14.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        textWidget(
                            text: "wed, 1 Nov, 9:00am",
                            style: getMediumStyle(fontSize: 10.sp)
                                .copyWith(fontFamily: 'Neue')),
                        SizedBox(
                          width: 6.sp,
                        ),
                        SvgPicture.asset(
                          ImageAssets.arrowForwardRounded,
                          height: 10.sp,
                          width: 10.sp,
                        ),
                        SizedBox(
                          width: 6.sp,
                        ),
                        textWidget(
                            text: "wed, 1 Nov, 9:00am",
                            style: getMediumStyle(fontSize: 10.sp)
                                .copyWith(fontFamily: 'Neue')),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textWidget(
                            text: AppStrings.tripId,
                            style:
                                getRegularStyle(fontSize: 10.sp, color: grey3)
                                    .copyWith(
                              fontFamily: 'Neue',
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              controller.copy(value: "GTI123456");
                            },
                            child: Row(
                              children: [
                                textWidget(
                                  text: 'GTI123456',
                                  style: getRegularStyle(
                                    fontSize: 10.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 3.sp,
                                ),
                                SvgPicture.asset(ImageAssets.docCopy),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                divider(color: borderColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget reviewTypeBox(
      {required String title, required bool selected, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? primaryColor : greyLight,
          borderRadius: BorderRadius.all(
            Radius.circular(2.r),
          ),
        ),
        child: textWidget(
            text: title,
            style: getMediumStyle(
              fontSize: 12.sp,
            ).copyWith(fontWeight: FontWeight.w600)),
      ),
    );
  }

  AppBar appbar() {
    return gtiAppBar(
      onTap: controller.goBack,
      leading: Icon(
        Icons.arrow_back_rounded,
        color: black,
        size: 24.sp,
      ),
      title: textWidget(
          text: AppStrings.trips,
          style: getMediumStyle(color: grey5)
              .copyWith(fontWeight: FontWeight.w500)),
    );
  }
}
