import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20owner/rent_history/feedbacks/feedbacks_controller.dart';
import 'package:gti_rides/screens/car%20renter/home/search_result/reviews/review_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class FeedbacksBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<FeedbacksController>(FeedbacksController());
  }
}

TextEditingController textController = TextEditingController();

class FeedbacksScreen extends GetView<FeedbacksController> {
  const FeedbacksScreen([Key? key]) : super(key: key);

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
                // review type boxes
                Row(
                  children: [
                    reviewTypeBox(
                        title: AppStrings.all,
                        onTap: () => controller.selectedIndex.value = 0,
                        selected: controller.selectedIndex.value == 0),
                    reviewTypeBox(
                        title: AppStrings.positiveR.trArgs(['2']),
                        onTap: () => controller.selectedIndex.value = 1,
                        selected: controller.selectedIndex.value == 1),
                    reviewTypeBox(
                        title: AppStrings.negativeR.trArgs(['4']),
                        onTap: () => controller.selectedIndex.value = 2,
                        selected: controller.selectedIndex.value == 2),
                  ],
                ),

                SizedBox(
                  height: 25,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/user_pic.png'),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                textWidget(
                                    text: "Gift Joy",
                                    style: getMediumStyle(
                                        fontSize: 12.sp,
                                        color: secondaryColor)),
                                textWidget(
                                    text: " | ",
                                    style: getLightStyle(
                                        fontSize: 12.sp, color: grey3)),
                                SvgPicture.asset(ImageAssets.thumbsUpGreen),
                                const SizedBox(width: 3),
                                textWidget(
                                    text: '100%',
                                    style: getMediumStyle(
                                        fontSize: 12.sp, color: grey5)),
                              ],
                            ),
                            Row(
                              children: [
                                textWidget(
                                    text: 'Wed, 1 Nov, 9:00am',
                                    style: getLightStyle(
                                        fontSize: 12.sp, color: grey3)),
                                SvgPicture.asset(
                                    ImageAssets.arrowForwardRounded),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.sp),
                    textWidget(
                        text:
                            "The car I rented through the app was in great condition and the booking process was effortless. I had a smooth and enjoyable experience.",
                        textOverflow: TextOverflow.visible,
                        style: getMediumStyle(fontSize: 10.sp, color: grey2)
                            .copyWith(fontWeight: FontWeight.w400)),
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
        margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(
            color: black,
            ImageAssets.arrowLeft,
          )),
      title: textWidget(
          text: AppStrings.feedbacks,
          style: getMediumStyle(color: grey5)
              .copyWith(fontWeight: FontWeight.w500)),
    );
  }
}
