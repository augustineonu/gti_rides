import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/renter/home/search_result/reviews/review_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/shimmer_loading/box_shimmer.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class ReviewsBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ReviewController>(ReviewController());
  }
}

TextEditingController textController = TextEditingController();

class ReviewsScreen extends GetView<ReviewController> {
  ReviewsScreen([Key? key]) : super(key: key);
  @override
  final controller = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: appbar(),
      body: body(context, size),

      // }
    );
  }

  Widget body(BuildContext context, Size size) {
    return controller.obx(
      (state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Image.asset('assets/images/small_car.png'),
                      carImage(
                          imgUrl: controller.photoUrl.value,
                          height: 35.sp,
                          width: 35.sp),
                      SizedBox(
                        width: 6.w,
                      ),
                      textWidget(
                        text: controller.vehicleName.value,
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
                          title: AppStrings.positiveR.trArgs(['0']),
                          onTap: () => controller.selectedIndex.value = 1,
                          selected: controller.selectedIndex.value == 1),
                      reviewTypeBox(
                          title: AppStrings.negativeR.trArgs(['0']),
                          onTap: () => controller.selectedIndex.value = 2,
                          selected: controller.selectedIndex.value == 2),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: controller.reviews!.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                // controller: ScrollController(initialScrollOffset: 5),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var review = controller.reviews![index];
                  // var reviewPercentage = review.reviewPercentage
                  // int? reviewPercentage = int.tryParse(review.reviewPercentage);
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0.sp, vertical: 16.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
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
                                        SvgPicture.asset(
                                          ImageAssets.thumbsUpGreen,),
                                          //  reviewPercentage! >= 50 ? ImageAssets.thumbsUpGreen : ImageAssets.thumbsDown),
                                        const SizedBox(width: 3),
                                        textWidget(
                                          text: '100%',
                                            // text: review.reviewPercentage != null ? review.reviewPercentage.toString() : '0',
                                            style: getMediumStyle(
                                                fontSize: 12.sp, color: grey5)),
                                      ],
                                    ),
                                    SizedBox(height: 3.sp),
                                    textWidget(
                                        text: isSingleDateSelection(
                                            date: review.createdAt!),
                                        style: getLightStyle(
                                            fontSize: 12.sp, color: grey3)),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10.sp),
                            textWidget(
                                text:
                                    review.message.toString(),
                                textOverflow: TextOverflow.visible,
                                textAlign: TextAlign.start,
                                style: getMediumStyle(
                                        fontSize: 10.sp, color: grey2)
                                    .copyWith(fontWeight: FontWeight.w400)),
                          ],
                        ),
                        divider(color: borderColor),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, lol) => const SizedBox(
                  height: 5,
                ),
              ),
            ),
          ],
        );
      },
      onEmpty: Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
        child: Center(
            child: textWidget(
                textOverflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                text: AppStrings.noReviewsYet,
                style: getExtraBoldStyle(fontSize: 18))),
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
      leading: Icon(
        Icons.arrow_back_rounded,
        color: black,
        size: 24.sp,
      ),
      title: textWidget(
          text: 'Reviews',
          style: getMediumStyle(color: grey5)
              .copyWith(fontWeight: FontWeight.w500)),
    );
  }
}
