import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20renter/more/identity_verification/identity_verification_controller.dart';
import 'package:gti_rides/screens/car%20renter/more/more_controller.dart';
import 'package:gti_rides/shared_widgets/dropdown_widget.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/sqaure_check_box_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/phone_number_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/shared_widgets/upload_image_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class ReferralCodeScreen extends GetView<MoreController> {
  const ReferralCodeScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // final controller = Get.put(AccountVerificationController());
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(),
      body: body(size, context, controller: controller),
      // }
    );
  }

  AppBar appBar() {
    return gtiAppBar(
      onTap: controller.goBack,
      leading: const Icon(Icons.arrow_back),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.referral,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(Size size, context, {required MoreController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              header(),
              const SizedBox(height: 34),
              referralCode(size),
              const SizedBox(height: 40),
              shareReferralLink(size),
            ],
          ),
    );
  }

  Widget shareReferralLink(Size size) {
    return Column(
      children: [
        Container(
          width: size.width,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20.sp),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.r), topRight: Radius.circular(4.r)),
          ),
          child: Column(
            children: [
              textWidget(
                  text: AppStrings.yourReferralLink,
                  textAlign: TextAlign.center,
                  textOverflow: TextOverflow.visible,
                  style: getRegularStyle(color: grey1)),
              textWidget(
                  text: 'https://gtirides.com/ytihj',
                  textAlign: TextAlign.center,
                  textOverflow: TextOverflow.visible,
                  style: getSemiBoldStyle(fontSize: 18..sp)),
            ],
          ),
        ),
        Container(
          width: size.width,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20.sp),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(4.r),
                bottomLeft: Radius.circular(4.r)),
          ),
          child: Center(
            child: textWidget(
                text: AppStrings.shareLink,
                textAlign: TextAlign.center,
                textOverflow: TextOverflow.visible,
                style: getMediumStyle(color: white)),
          ),
        ),
      ],
    );
  }

  Widget referralCode(Size size) {
    return SizedBox(
      height: 70.sp,
      width: size.width,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(top: 11, left: 20.sp, right: 10),
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.r),
                      bottomLeft: Radius.circular(4.r))),
              child: Column(
                children: [
                  textWidget(
                      text: AppStrings.yourReferralCode,
                      textAlign: TextAlign.center,
                      textOverflow: TextOverflow.visible,
                      style: getRegularStyle(color: grey1)),
                  textWidget(
                      text: 'XETYOIJJB',
                      textAlign: TextAlign.center,
                      textOverflow: TextOverflow.visible,
                      style: getSemiBoldStyle(fontSize: 18..sp)),
                ],
              ),
            ),
          ),
          Container(
            height: size.height,
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, right: 15, left: 15),
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4.r),
                    bottomRight: Radius.circular(4.r))),
            child: Center(
              child: Row(
                children: [
                  textWidget(
                      text: AppStrings.copyCode,
                      textAlign: TextAlign.center,
                      textOverflow: TextOverflow.visible,
                      style: getMediumStyle(color: white)),
                  SizedBox(
                    width: 5,
                  ),
                  SvgPicture.asset(ImageAssets.copy)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(20.sp),
          decoration: const BoxDecoration(color: white, shape: BoxShape.circle),
          child: SvgPicture.asset(ImageAssets.prize),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: 230.sp,
          child: textWidget(
              text: AppStrings.getDiscountOnEveryOneYouTell,
              textAlign: TextAlign.center,
              textOverflow: TextOverflow.visible,
              style: getRegularStyle(color: grey3)),
        ),
      ],
    );
  }

  Widget saveButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 55.sp,
            width: 370,
            text: AppStrings.shareLink,
            // color: secondaryColor,
            onTap: () {},
            isLoading: controller.isLoading.value,
          );
  }
}