import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/review_response_model.dart';
import 'package:gti_rides/screens/Partner/rent_history/feedbacks/feedbacks_controller.dart';
import 'package:gti_rides/screens/renter/home/search_result/reviews/review_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class FeedbacksBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<FeedbacksController>(FeedbacksController());
  }
}

TextEditingController textController = TextEditingController();

class FeedbacksScreen extends GetView<FeedbacksController> {
  FeedbacksScreen([Key? key]) : super(key: key);
  final controller = Get.put(FeedbacksController());

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              carImage(
                  imgUrl: controller.photoUrl.value,
                  height: 35.sp,
                  width: 35.sp,
                  borderRadius: BorderRadius.all(Radius.circular(4.r))),
              SizedBox(
                width: 6.w,
              ),
              textWidget(
                text: controller.vehicleName.value,
                textOverflow: TextOverflow.visible,
                style: getBoldStyle(fontWeight: FontWeight.w700, color: black)
                    .copyWith(
                  fontFamily: "Neue",
                ),
              ),
            ],
          ),
          Row(
            children: [
              reviewTypeBox(
                  title: AppStrings.all,
                  onTap: () {
                    controller.reviews!.refresh();
                    controller.selectedIndex.value = 0;
                  },
                  selected: controller.selectedIndex.value == 0),
              reviewTypeBox(
                  title: AppStrings.positiveR
                      .trArgs([controller.positiveReviews.length.toString()]),
                  onTap: () {
                    controller.positiveReviews.refresh();
                    controller.selectedIndex.value = 1;
                  },
                  selected: controller.selectedIndex.value == 1),
              reviewTypeBox(
                  title: AppStrings.negativeR
                      .trArgs([controller.negativeReviews.length.toString()]),
                  onTap: () {
                    controller.negativeReviews.refresh();
                    controller.selectedIndex.value = 2;
                  },
                  selected: controller.selectedIndex.value == 2),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          buildReviews(size, context),
        ],
      ),
    );
  }

  Widget buildReviews(Size size, BuildContext context) {
    switch (controller.selectedIndex.value) {
      case 0:
        return buildFeedbackLIst(itemCount: controller.reviews!.length);
      // break;
      case 1:
        return buildFeedbackLIst(itemCount: controller.positiveReviews.length);
      case 2:
        return buildFeedbackLIst(itemCount: controller.negativeReviews.length);
      default:
        return const SizedBox();
    }
  }

  Widget buildFeedbackLIst({
    required int itemCount,
  }) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: ()=> controller.getCarReviews(),
        child: ListView.separated(
          itemCount: itemCount,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            ReviewData review;
            if (controller.selectedIndex.value == 0) {
              review = controller.reviews![index];
            } else if (controller.selectedIndex.value == 1) {
              review = controller.positiveReviews[index];
            } else {
              review = controller.negativeReviews[index];
            }
        
            int? reviewPercentage = int.tryParse(review.reviewPercentage);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Image.asset('assets/images/user_pic.png'),
                    carImage(
                        imgUrl: controller.photoUrl.value,
                        height: 35.sp,
                        width: 35.sp,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            textWidget(
                                text: review.user!.userName,
                                style: getMediumStyle(
                                    fontSize: 12.sp, color: secondaryColor)),
                            textWidget(
                                text: " | ",
                                style:
                                    getLightStyle(fontSize: 12.sp, color: grey3)),
                            SvgPicture.asset(reviewPercentage! >= 50
                                      ? ImageAssets.thumbsUpGreen
                                      : ImageAssets.thumbsDown,
                                  color: reviewPercentage >= 50 ? null : red),
                            const SizedBox(width: 3),
                            textWidget(
                                text:  review.reviewPercentage != null
                                        ? "${review.reviewPercentage.toString()}%" 
                                        : '0%',
                                style: getMediumStyle(
                                    fontSize: 12.sp, color: grey5)),
                          ],
                        ),
                        Row(
                          children: [
                            textWidget(
                                text: isSingleDateSelection(
                                    date: review.createdAt!),
                                style: getRegularStyle(
                                    fontSize: 10.sp, color: grey3)),
                            // SvgPicture.asset(ImageAssets.arrowForwardRounded),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.sp),
                textWidget(
                    text: review.message.toString(),
                        textOverflow: TextOverflow.visible,
                        textAlign: TextAlign.start,
                        style: getMediumStyle(fontSize: 12.sp, color: grey5)
                            .copyWith(fontWeight: FontWeight.w300)),
              ],
            );
          },
          separatorBuilder: (_, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: divider(color: borderColor),
          ),
        ),
      ),
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
